classdef GenericDialog < handle
% A generic dialog, similar to ImageJ's.
%
%   Class GenericDialog
%
%   Example
%     % creates a new dialog, and populates it with some fields
%     gd = imagem.gui.GenericDialog('Create Image');
%     addTextField(gd, 'Name: ', 'New Image');
%     addNumericField(gd, 'Width: ', 320, 0);
%     addNumericField(gd, 'Height: ', 200, 0);
%     addChoice(gd, 'Type: ', {'uint8', 'uint16', 'double'}, 'uint8');
%     addCheckBox(gd, 'Display', true);
%
%     % displays the dialog, and waits for user
%     showDialog(gd);
%     % check if ok or cancel was clicked
%     if wasCanceled(gd)
%         return;
%     end
%
%     % gets the user inputs
%     name = gd.getNextString();
%     width = getNextNumber(gd);
%     height = getNextNumber(gd);
%     type = getNextString(gd);
%     display = getNextBoolean(gd);
%
%     % Creates new image, and displays if requested
%     img = Image.create([width height], type);
%     img.Name = name;
%     if display
%         show(img); title(name);
%     end
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2014-04-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2014 INRA - Cepia Software Platform.


%% Properties
properties
    Handles;
    
    ControlHandles = [];
    CurrentIndex = 1;
    
    BoxSizes = [];
    
    % a list of answers (one cell for each item that was added).
    Answers = {};
    
    % the string corresponding to the button used to close the dialog.
    % can be one of 'ok', 'cancel'.
    ClosingButton = '';
    
end % end properties


%% Constructor
methods
    function obj = GenericDialog(varargin)
    % Constructor for GenericDialog class.

        createLayout(obj, varargin{:});
    end

end % end constructors

methods (Access = private)
    function createLayout(obj, varargin)
        % initialize the layout (figure and widgets).
        hf = createFigure(obj, varargin{:});
        obj.Handles.Figure = hf;
        
        % vertical layout for widgets and control panels
        vb  = uix.VBox('Parent', hf, 'Spacing', 5, 'Padding', 5);
        
        % create an empty panel that will contain widgets
        obj.Handles.MainPanel = uix.VBox('Parent', vb);
        
        % button for control panel
        buttonsPanel = uix.HButtonBox('Parent', vb, 'Padding', 5);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'OK', ...
            'Callback', @obj.onButtonOK);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'Cancel', ...
            'Callback', @obj.onButtonCancel);
        
        set(vb, 'Heights', [-1 40] );

    end
    
     function hf = createFigure(obj, varargin)
        % create new figure and return its handle.
        
        % parse dialog title
        if isempty(varargin)
            dlgName = 'Generic Dialog';
        else
            dlgName = varargin{1};
        end

        % computes a new handle index large enough not to collide with
        % common figure handles
        while true
            newFigHandle = 30000 + randi(10000);
            if ~ishandle(newFigHandle)
                break;
            end
        end
        
        % create the figure that will contains the display
        hf = figure(newFigHandle);
        
        set(hf, ...
            'Name', dlgName, ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', ...
            'Toolbar', 'none', ...
            'NextPlot', 'new', ...
            'WindowStyle', 'modal', ...
            'CloseRequestFcn', @obj.closeFigure, ...
            'Visible', 'off');
        
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = [300 250];
        set(hf, 'Position', pos);
        
        obj.Handles.Figure = hf;
     end
end

%% Methods
methods
    function [h, ht] = addTextField(obj, label, text, cb)
        % Add a text field to this dialog.
        %
        % usage:
        %   addTextField(GD, LABEL, INPUTTEXT);
        
        
        hLine = uix.HBox('Parent', obj.Handles.MainPanel, ...
            'Spacing', 5, 'Padding', 5);
        
        % Label of the widget
        ht = addLabel(hLine, label);
        
        % creates the new control
        %         bgColor = getWidgetBackgroundColor(obj);
        bgColor = [1 1 1];
        h = uicontrol(...
            'Style', 'Edit', ...
            'Parent', hLine, ...
            'String', text, ...
            'BackgroundColor', bgColor);
        if isa('cb', 'var')
            set(h, 'Callback', cb);
        end
        
        % keep widget handle for future use
        obj.ControlHandles = [obj.ControlHandles h];
        
        % setup size in horizontal direction
        set(hLine, 'Widths', [-5 -5]);
        
        % update vertical size of widgets
        obj.BoxSizes = [obj.BoxSizes 35];
        set(obj.Handles.MainPanel, 'Heights', obj.BoxSizes);
    end
    
    function [h, ht] = addNumericField(obj, label, value, nDigits, cb)
        % Add a numeric field to this dialog.
        %
        % usage:
        %   addNumericField(GD, LABEL, DEFAULTVALUE);
        %   Adds a new text field containing a numeric value.
        %
        %   addNumericField(GD, LABEL, DEFAULTVALUE, NDIGITS);
        %   Also specifies the number of digits after decimal mark. De
        %
        %   addNumericField(GD, LABEL, DEFAULTVALUE, NDIGITS, CB);
        %   Also specifies a callback function.
        %
        
        % choose default values if they are not specified
        if nargin < 4
            nDigits = 0;
        end
        
        % create horizontal box
        hLine = uix.HBox('Parent', obj.Handles.MainPanel, ...
            'Spacing', 5, 'Padding', 5);
        
        % Label of the widget
        ht = addLabel(hLine, label);
        
        % create initial text from value
        pattern = ['%.' num2str(nDigits) 'f'];
        text = sprintf(pattern, value);
        
        % creates the new control
        %         bgColor = getWidgetBackgroundColor(obj);
        bgColor = [1 1 1];
        h = uicontrol(...
            'Style', 'Edit', ...
            'Parent', hLine, ...
            'String', text, ...
            'BackgroundColor', bgColor);
        if isa('cb', 'var')
            set(h, 'Callback', cb);
            set(h, 'KeyPressFcn', cb);
        end
        
%         % try to add a key press listener
%         jtf = findjobj(h);
%         jtfh = handle(jtf, 'callbackproperties');
%         set(jtfh, 'KeyPressedCallback', 'disp(''text modified'')')
%         h2 = uicontrol('style', 'edit', 'string', 'Hello!');
        
        % keep widget handle for future use
        obj.ControlHandles = [obj.ControlHandles h];
        
        % setup size in horizontal direction
        set(hLine, 'Widths', [-5 -5]);
        
        % update vertical size of widgets
        obj.BoxSizes = [obj.BoxSizes 35];
        set(obj.Handles.MainPanel, 'Heights', obj.BoxSizes);
    end
    
    function h = addCheckBox(obj, label, checked, cb)
        % Add  text field to this dialog.
        %
        % usage:
        %   addTextField(GD, LABEL, INPUTTEXT);
        
        if ~exist('checked', 'var')
            checked = false;
        end
        
        % create horizontal box
        hLine = uix.HBox('Parent', obj.Handles.MainPanel, ...
            'Spacing', 5, 'Padding', 5);
      
        % creates the new control
        %         bgColor = getWidgetBackgroundColor(obj);
%         bgColor = [1 1 1];
        h = uicontrol(...
            'Style', 'Checkbox ', ...
            'Parent', hLine, ...
            'String', label, ...
            'Value', checked);
        if exist('cb', 'var')
            set(h, 'Callback', cb);
        end
        
        % keep widget handle for future use
        obj.ControlHandles = [obj.ControlHandles h];
        
        % setup size in horizontal direction
        set(hLine, 'Widths', -5);
        
        % update vertical size of widgets
        obj.BoxSizes = [obj.BoxSizes 25];
        set(obj.Handles.MainPanel, 'Heights', obj.BoxSizes);
    end
    
    function [h, ht] = addChoice(obj, label, choiceLabels, initialValue, cb)
        % Add choice as a popupmenu.
        %
        % usage:
        %   addChoice(GD, LABEL, CHOICES, INITIALVALUE);
        
        
        hLine = uix.HBox('Parent', obj.Handles.MainPanel, ...
            'Spacing', 5, 'Padding', 5);
        
        % Label of the widget
        ht = addLabel(hLine, label);
        
        % set initial value as numeric if not the case
        if isa('initialValue', 'var') && ischar(initialValue)
            ind = find(strcmp(choiceLabels, initialValue), 1);
            if isempty(ind)
                error(['Could not find initial value [' initialValue ...
                    '] within the list of choices']);
            end
            initialValue = ind;
        else
            initialValue = 1;
        end
        
        % creates the new control
        %         bgColor = getWidgetBackgroundColor(obj);
        bgColor = [1 1 1];
        h = uicontrol(...
            'Style', 'PopupMenu', ...
            'Parent', hLine, ...
            'String', choiceLabels, ...
            'Value', initialValue, ...
            'BackgroundColor', bgColor);
        if isa('cb', 'var')
            set(h, 'Callback', cb);
        end
        
        % keep widget handle for future use
        obj.ControlHandles = [obj.ControlHandles h];
        
        % setup size in horizontal direction
        set(hLine, 'Widths', [-5 -5]);
        
        % update vertical size of widgets
        obj.BoxSizes = [obj.BoxSizes 35];
        set(obj.Handles.MainPanel, 'Heights', obj.BoxSizes);
    end
    
    function ht = addMessage(obj, text)
        % Add a text message to this dialog.
        %
        % usage:
        %   addMessage(GD, MSGTEXT);
        
        
        hLine = uix.HBox('Parent', obj.Handles.MainPanel, ...
            'Spacing', 5, 'Padding', 5);
        
        % Label of the widget
        ht = addLabel(hLine, text);
        
        % setup size in horizontal direction
        set(hLine, 'Widths', -1);
        
        % update vertical size of widgets
        obj.BoxSizes = [obj.BoxSizes 25];
        set(obj.Handles.MainPanel, 'Heights', obj.BoxSizes);
       end
    
end % end methods


%% get widget results
methods
    function string = getNextString(obj)
        h = getNextControlHandle(obj);
        
        string = get(h, 'String');
        
        if strcmp(get(h, 'style'), 'popupmenu')
            index = get(h, 'value');
            string = string{index};
        end
    end
    
    function index = getNextChoiceIndex(obj)
        h = getNextControlHandle(obj);
        
        if ~strcmp(get(h, 'style'), 'popupmenu')
            error('Next control must be a popup menu');
        end
        index = get(h, 'value');
    end
    
    function value = getNextNumber(obj)
        h = getNextControlHandle(obj);
        
        string = get(h, 'String');
        value = str2double(string);
        if isnan(value)
            error(['Could not parse value in string: ' string]);
        end
    end
    
    function value = getNextBoolean(obj)
        h = getNextControlHandle(obj);
        
        type = get(h, 'style');
        if ~strcmp(type, 'checkbox')
            error(['Next item must be a checkbox, not a ' type]);
        end
        value = get(h, 'value');
    end
    
    function h = getNextControlHandle(obj)
        % iterate along the widgets, and returns the next handle.
        % throw an error if no more 
        if obj.CurrentIndex > length(obj.ControlHandles)
            error('No more widget to process');
        end
        
        h = obj.ControlHandles(obj.CurrentIndex);
        obj.CurrentIndex = obj.CurrentIndex + 1;
    end
    
    function resetCounter(obj)
        obj.CurrentIndex = 1;
    end
end


%% Figure and control Callback
methods
    function onButtonOK(obj, varargin)
        obj.ClosingButton = 'ok';
        set(obj.Handles.Figure, 'Visible', 'off');
    end
    
    function onButtonCancel(obj, varargin)
        obj.ClosingButton = 'cancel';
        set(obj.Handles.Figure, 'Visible', 'off');
    end
    
    function showDialog(obj)
        % makes the dialog visible, and waits for user validation
        setVisible(obj, true);
        waitForUser(obj);
    end
    
    function setVisible(obj, value)
        if value
            set(obj.Handles.Figure, 'Visible', 'on');
            set(obj.Handles.Figure, 'WindowStyle', 'modal');
        else
            set(obj.Handles.Figure, 'Visible', 'off');
        end
    end
    
    function setSize(obj, newSize)
        set(obj.Handles.Figure, 'Units', 'pixels');
        pos = get(obj.Handles.Figure, 'Position');
        pos(3:4) = newSize;
        set(obj.Handles.Figure, 'Position', pos);
    end
    
    function b = wasOked(obj)
        b = strcmp(obj.ClosingButton, 'ok');
    end
    
    function b = wasCanceled(obj)
        b = strcmp(obj.ClosingButton, 'cancel');
    end
    
    function button = waitForUser(obj)
        waitfor(obj.Handles.Figure, 'Visible', 'off');
        button = obj.ClosingButton;
    end
    
    function closeFigure(obj, varargin)
        % close the current figure
        obj.ClosingButton = 'cancel';
        if ~isempty(obj.Handles.Figure)
            delete(obj.Handles.Figure);
        end
    end
    
end

end % end classdef

function ht = addLabel(parent, label)
% add a label to a widget, with predefined settings.
ht = uicontrol('Style', 'Text', ...
    'Parent', parent, ...
    'String', label, ...
    'FontWeight', 'Normal', ...
    'FontSize', 10, ...
    'FontWeight', 'Normal', ...
    'HorizontalAlignment', 'Right');
end

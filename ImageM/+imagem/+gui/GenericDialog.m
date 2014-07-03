classdef GenericDialog < handle
%GENERICDIALOG A generic dialog, similar to ImageJ's
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
%     img.name = name;
%     if display
%         show(img); title(name);
%     end
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2014-04-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2014 INRA - Cepia Software Platform.


%% Properties
properties
    handles;
    
    controlHandles = [];
    currentIndex = 1;
    
    boxSizes = [];
    
    % a list of answers (one cell for each item that was added).
    answers = {};
    
    % the string corresponding to the button used to close the dialog.
    % can be one of 'ok', 'cancel'.
    closingButton = '';
    
end % end properties


%% Constructor
methods
    function this = GenericDialog(varargin)
    % Constructor for GenericDialog class

        createLayout(this, varargin{:});
    end

end % end constructors

methods (Access = private)
    function createLayout(this, varargin)
        % initialize the layout (figure and widgets)
        hf = createFigure(this, varargin{:});
        this.handles.figure = hf;
        
        % vertical layout for widgets and control panels
        vb  = uiextras.VBox('Parent', hf, 'Spacing', 5, 'Padding', 5);
        
        % create an empty panel that will contain widgets
        this.handles.mainPanel = uiextras.VBox('Parent', vb);
        
        % button for control panel
        buttonsPanel = uiextras.HButtonBox( 'Parent', vb, 'Padding', 5);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'OK', ...
            'Callback', @this.onButtonOK);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'Cancel', ...
            'Callback', @this.onButtonCancel);
        
        set(vb, 'Sizes', [-1 40] );

    end
    
     function hf = createFigure(this, varargin)
        % create new figure and return its handle
        
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
            'Visible', 'off');
        
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = [200 250];
        set(hf, 'Position', pos);
        
        this.handles.figure = hf;
     end
end

%% Methods
methods
    function [h ht] = addTextField(this, label, text, cb)
        % Add a text field to this diaolg
        % usage:
        %   addTextField(GD, LABEL, INPUTTEXT);
        
        
        hLine = uiextras.HBox('Parent', this.handles.mainPanel, ...
            'Spacing', 5, 'Padding', 5);
        
        % Label of the widget
        ht = addLabel(hLine, label);
        
        % creates the new control
        %         bgColor = getWidgetBackgroundColor(this);
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
        this.controlHandles = [this.controlHandles h];
        
        % setup size in horizontal direction
        set(hLine, 'Sizes', [-5 -5]);
        
        % update vertical size of widgets
        this.boxSizes = [this.boxSizes 35];
        set(this.handles.mainPanel, 'Sizes', this.boxSizes);
    end
    
    function [h ht] = addNumericField(this, label, value, nDigits, cb)
        % Add a text field to this diaolg
        % usage:
        %   addTextField(GD, LABEL, INPUTTEXT);
        
        % create horizontal box
        hLine = uiextras.HBox('Parent', this.handles.mainPanel, ...
            'Spacing', 5, 'Padding', 5);
        
        % Label of the widget
        ht = addLabel(hLine, label);
        
        % create initial text from value
        pattern = ['%.' num2str(nDigits) 'f'];
        text = sprintf(pattern, value);
        
        % creates the new control
        %         bgColor = getWidgetBackgroundColor(this);
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
        this.controlHandles = [this.controlHandles h];
        
        % setup size in horizontal direction
        set(hLine, 'Sizes', [-5 -5]);
        
        % update vertical size of widgets
        this.boxSizes = [this.boxSizes 35];
        set(this.handles.mainPanel, 'Sizes', this.boxSizes);
    end
    
    function h = addCheckBox(this, label, checked, cb)
        % Add  text field to this diaolg
        % usage:
        %   addTextField(GD, LABEL, INPUTTEXT);
        
        % create horizontal box
        hLine = uiextras.HBox('Parent', this.handles.mainPanel, ...
            'Spacing', 5, 'Padding', 5);
      
        % creates the new control
        %         bgColor = getWidgetBackgroundColor(this);
%         bgColor = [1 1 1];
        h = uicontrol(...
            'Style', 'Checkbox ', ...
            'Parent', hLine, ...
            'String', label, ...
            'Value', checked);
        if isa('cb', 'var')
            set(h, 'Callback', cb);
        end
        
        % keep widget handle for future use
        this.controlHandles = [this.controlHandles h];
        
        % setup size in horizontal direction
        set(hLine, 'Sizes', -5);
        
        % update vertical size of widgets
        this.boxSizes = [this.boxSizes 25];
        set(this.handles.mainPanel, 'Sizes', this.boxSizes);
    end
    
    function [h ht] = addChoice(this, label, choiceLabels, initialValue, cb)
        % Add choice as a popupmenu
        % usage:
        %   addChoice(GD, LABEL, CHOICES, INITIALVALUE);
        
        
        hLine = uiextras.HBox('Parent', this.handles.mainPanel, ...
            'Spacing', 5, 'Padding', 5);
        
        % Label of the widget
        ht = addLabel(hLine, label);
        
        % set initial value as numeric if not the case
        if ischar(initialValue)
            ind = find(strcmp(choiceLabels, initialValue), 1);
            if isempty(ind)
                error(['Could not find initial value [' initialValue ...
                    '] within the list of choices']);
            end
            initialValue = ind;
        end
        
        % creates the new control
        %         bgColor = getWidgetBackgroundColor(this);
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
        this.controlHandles = [this.controlHandles h];
        
        % setup size in horizontal direction
        set(hLine, 'Sizes', [-5 -5]);
        
        % update vertical size of widgets
        this.boxSizes = [this.boxSizes 35];
        set(this.handles.mainPanel, 'Sizes', this.boxSizes);
    end
    
   
end % end methods


%% get widget results
methods
    function string = getNextString(this)
        h = getNextControlHandle(this);
        
        string = get(h, 'String');
        
        if strcmp(get(h, 'style'), 'popupmenu')
            index = get(h, 'value');
            string = string{index};
        end
    end
    
    function index = getNextChoiceIndex(this)
        h = getNextControlHandle(this);
        
        if ~strcmp(get(h, 'style'), 'popupmenu')
            error('Next control must be a popup menu');
        end
        index = get(h, 'value');
    end
    
    function value = getNextNumber(this)
        h = getNextControlHandle(this);
        
        string = get(h, 'String');
        value = str2double(string);
        if isnan(value)
            error(['Could not parse value in string: ' string]);
        end
    end
    
    function value = getNextBoolean(this)
        h = getNextControlHandle(this);
        
        type = get(h, 'style');
        if ~strcmp(type, 'checkbox')
            error(['Next item must be a checkbox, not a ' type]);
        end
        value = get(h, 'value');
    end
    
    function h = getNextControlHandle(this)
        % iterate along the widgets, and returns the next handle.
        % throw an error if no more 
        if this.currentIndex > length(this.controlHandles)
            error('No more widget to process');
        end
        
        h = this.controlHandles(this.currentIndex);
        this.currentIndex = this.currentIndex + 1;
    end
    
    function resetCounter(this)
        this.currentIndex = 1;
    end
end


%% Figure and control Callback
methods
    function onButtonOK(this, varargin)
        this.closingButton = 'ok';
        set(this.handles.figure, 'Visible', 'off');
    end
    
    function onButtonCancel(this, varargin)
        this.closingButton = 'cancel';
        set(this.handles.figure, 'Visible', 'off');
    end
    
    function showDialog(this)
        % makes the dialog visible, and waits for user validation
        setVisible(this, true);
        waitForUser(this);
    end
    
    function setVisible(this, value)
        if value
            set(this.handles.figure, 'Visible', 'on');
            set(this.handles.figure, 'WindowStyle', 'modal');
        else
            set(this.handles.figure, 'Visible', 'off');
        end
    end
    
    function b = wasOked(this)
        b = strcmp(this.closingButton, 'ok');
    end
    
    function b = wasCanceled(this)
        b = strcmp(this.closingButton, 'cancel');
    end
    
    function button = waitForUser(this)
        waitfor(this.handles.figure, 'Visible', 'off');
        button = this.closingButton;
    end
    
    function closeFigure(this)
        % close the current figure
        if ~isempty(this.handles.figure);
            close(this.handles.figure);
        end
    end
    
end

end % end classdef

function ht = addLabel(parent, label)
% add a label to a widget, with predefined settings
ht = uicontrol('Style', 'Text', ...
    'Parent', parent, ...
    'String', label, ...
    'FontWeight', 'Normal', ...
    'FontSize', 10, ...
    'FontWeight', 'Normal', ...
    'HorizontalAlignment', 'Right');
end
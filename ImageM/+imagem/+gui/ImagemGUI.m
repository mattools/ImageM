classdef ImagemGUI < handle
% GUI manager for the ImageM application.
%
%   This class manages the list of opens documents, and creates appropriate
%   menus for viewers.
%
%   output = ImagemGUI(input)
%
%   Example
%   ImagemGUI
%
%   See also
%     PlanarImageViewer
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2011-03-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

%% Properties
properties
    % the application instance that contains and manages documents.
    App;
    
    % some options for widgets creation, as an instance of GuiOptions.
    Options;
end 

%% Constructor
methods
    function obj = ImagemGUI(appli, varargin)
        % IMAGEM constructor
        %
        % IM = ImageM(APP)
        % where APP is an instance of ImagemApp.
        %
        
        obj.App = appli;
        
        obj.Options = imagem.gui.GuiOptions();
        
    end % constructor 

end % construction function


%% General methods
methods
    function [frame, doc] = createImageFrame(obj, image)
        % Create a new image viewer frame.
        %
        % FRAME = createImageFrame(obj, image);
        % Creates a new frame from image instance.
        %
        % [FRAME, DOC] = createImageFrame(obj, image);
        % Also returns the created doc.
        
        % in case of empty image, create an "empty view"
        if isempty(image)
            doc = [];
            frame = imagem.gui.PlanarImageViewer(obj, doc);
            return;
        end
        
        doc = createImageDocument(obj.App, image);
       
        % creates a display for the new image depending on image dimension
        if ~isempty(image) && size(image, 3) > 1
            frame = imagem.gui.Image3DSliceViewer(obj, doc);
        else
            frame = imagem.gui.PlanarImageViewer(obj, doc);
        end
        addView(doc, frame);
    end

    function [doc, viewer] = addImageDocument(obj, image, newName, refTag)
        % Create a new document from image, add it to app, and display img.
        % (Deprecated, replaced by createImageFrame).
        %
        
        % in case of empty image, create an "empty view"
        if isempty(image)
            doc = [];
            viewer = imagem.gui.PlanarImageViewer(obj, doc);
            return;
        end
        
        if ~exist('newName', 'var')
            newName = [];
        end
        if ~exist('refTag', 'var')
            refTag = 'img';
        end
        
        doc = createImageDocument(obj.App, image, newName, refTag);
       
        % creates a display for the new image depending on image dimension
        if ~isempty(image) && size(image, 3) > 1
            viewer = imagem.gui.Image3DSliceViewer(obj, doc);
        else
            viewer = imagem.gui.PlanarImageViewer(obj, doc);
        end
        addView(doc, viewer);
    end

    function [frame, doc] = createTableFrame(obj, table, varargin)
        % Create a new Frame for displaying the table.
        %
        % Usage:
        %   FRAME = createTableFrame(obj, table);
        %   Creates a new frame from Image instance.
        %
        %   [FRAME, DOC] = createTableFrame(obj, table);
        %   Also returns the created doc.
        
        parentFrame = []; % will be used to locate the new frame
        tableDoc = [];
        
        while ~isempty(varargin)
            var1 = varargin{1};
            if isa(var1, 'imagem.gui.TableFrame')
                parentFrame = var1;
                tableDoc = currentDoc(parentFrame);
            elseif isa(var1, 'imagem.gui.ImagemFrame')
                parentFrame = var1;
            elseif isa(var1, 'imagem.app.TableDoc')
                tableDoc = var1;
            else
                error('Unable to process input argument of type %s', class(var1));
            end
            varargin(1) = [];
        end
        
        % create new doc
        if ~isempty(tableDoc)
            doc = createTableDocument(obj.App, table, tableDoc);
        else
            doc = createTableDocument(obj.App, table);
        end
        
        % create new frame for containing the doc.
        frame = imagem.gui.TableFrame(obj, doc);
    end

    function h = createPlotFrame(obj)
        % Create a new figure with standard options
        h = figure;
        clf; hold on;
        set(gca, obj.Options.TextOptions{:});
    end

    function addToHistory(obj, string)
        % Add the specified string to gui history
        
        warning('ImageM:ImagemGUI:deprecated', ...
            'deprecated, should add to app history directly');
        addToHistory(obj.App, string);
        fprintf(string);
    end
    
    function exit(obj)
        % EXIT Close all viewers
        
        docList = getDocuments(obj.App);
        for d = 1:length(docList)
            doc = docList{d};
%             disp(['closing doc: ' doc.image.Name]);
            
            views = getViews(doc);
            for v = 1:length(views)
                view = views{v};
                removeView(doc, view);
                close(view);
            end
        end
    end
    
end % general methods

%% GUI Creation methods
methods
    function createFigureMenu(obj, hf, frame)
        builder = imagem.gui.FrameMenuBuilder(obj, frame);
        buildMenu(builder, hf);
    end
    
    function createTableMenu(obj, hf, frame)
        disp('deprecated, use ''createFigureMenu'' instead');
        builder = imagem.gui.FrameMenuBuilder(obj, frame);
        buildMenu(builder, hf);
    end
end

methods (Static)
    
    function enable = updateMenuEnable(menu)
        % Enables/Disable a menu item or a menu
        % If menuitem -> enable depending on action
        % if menu -> enabled if at least one item is enabled
        %
        
        % default is false
        enable = false;
        
        % first, process recursion on children
        children = get(menu, 'children');
        if ~isempty(children)
            % process menu with submenus:
            % menu is active if at least one sub-item is active
            for i = 1:length(children)
                en = imagem.gui.ImagemGUI.updateMenuEnable(children(i));
                enable = enable || en;
            end
            
        else
            % process final menu item
            data = get(menu, 'UserData');
            if ~isempty(data) && isstruct(data) && isfield(data, 'Action') && ~isempty(data.Action)
                enable = isActivable(data.Action);
            end
        end
        
        % switch meanu item state
        if enable
            set(menu, 'Enable', 'on');
        else
            set(menu, 'Enable', 'off');
        end
        
    end
    
end

methods
    function [h, ht] = addInputTextLine(obj, parent, label, text, cb)
        
        hLine = uix.HBox('Parent', parent, ...
            'Spacing', 5, 'Padding', 5);
        
        % Label of the widget
        ht = uicontrol('Style', 'Text', ...
            'Parent', hLine, ...
            'String', label, ...
            'FontWeight', 'Normal', ...
            'FontSize', 10, ...
            'HorizontalAlignment', 'Right');
        
        % creates the new control
        bgColor = getWidgetBackgroundColor(obj);
        h = uicontrol(...
            'Style', 'Edit', ...
            'Parent', hLine, ...
            'String', text, ...
            'BackgroundColor', bgColor);
        if nargin > 4
            set(h, 'Callback', cb);
        end
        
        % setup size in horizontal direction
        set(hLine, 'Widths', [-5 -5]);
    end
    
    function [h, ht] = addComboBoxLine(obj, parent, label, choices, cb)
        
        hLine = uix.HBox('Parent', parent, ...
            'Spacing', 5, 'Padding', 5);
        
        % Label of the widget
        ht = uicontrol('Style', 'Text', ...
            'Parent', hLine, ...
            'String', label, ...
            'FontWeight', 'Normal', ...
            'FontSize', 10, ...
            'HorizontalAlignment', 'Right');
        
        % creates the new control
        bgColor = getWidgetBackgroundColor(obj);
        h = uicontrol('Style', 'PopupMenu', ...
            'Parent', hLine, ...
            'String', choices, ...
            'BackgroundColor', bgColor, ...
            'Value', 1);
        if nargin > 4
            set(h, 'Callback', cb);
        end
        
        % setup size in horizontal direction
        set(hLine, 'Widths', [-5 -5]);
    end
    
    function h = addCheckBox(obj, parent, label, state, cb) %#ok<INUSL>
        
        hLine = uix.HBox('Parent', parent, ...
            'Spacing', 5, 'Padding', 5);
        
        % default value if not specified
        if nargin < 4 || isempty(state)
            state = false;
        end
        
        % creates the new widget
        h = uicontrol('Style', 'CheckBox', ...
            'Parent', hLine, ...
            'String', label, ...
            'Value', state);
        if nargin > 4
            set(h, 'Callback', cb);
        end
    end
end


methods
    function bgColor = getWidgetBackgroundColor(obj) %#ok<MANU>
        % compute background color of most widgets
        if ispc
            bgColor = 'White';
        else
            bgColor = get(0, 'defaultUicontrolBackgroundColor');
        end
    end
end

end % classdef

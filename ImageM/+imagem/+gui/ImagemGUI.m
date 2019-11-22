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
    % application
    App;
    
    Options;
end 

%% Constructor
methods
    function obj = ImagemGUI(appli, varargin)
        % IMAGEM constructor
        %
        % IM = ImageM(APP)
        % where APP is an instance of ImagemApp
        %
        
        obj.App = appli;
        
        obj.Options = imagem.gui.GuiOptions();
        
    end % constructor 

end % construction function


%% General methods
methods
    function [doc, viewer] = addImageDocument(obj, image, newName, refTag)
        % Create a new document from image, add it to app, and display img
        
        if isempty(image)
            % in case of empty image, create an "empty view"
            doc = [];
            viewer = imagem.gui.PlanarImageViewer(obj, doc);
            return;
        end
        
        if nargin < 3 || isempty(newName)
            % find a 'free' name for image
            newName = createDocumentName(obj.App, image.Name);
        end
        image.Name = newName;
        
        % creates new instance of ImageDoc
        doc = imagem.app.ImagemDoc(image);
        
        % setup document tag
        if nargin < 4
            tag = createImageTag(obj.App, image);
        else
            tag = createImageTag(obj.App, image, refTag);
        end
        doc.Tag = tag;
        
        % compute LUT of label image
        if ~isempty(image)
            if isLabelImage(image)
                doc.LutName = 'jet';
                nLabels = double(max(image.Data(:)));
                if nLabels < 255
                    baseLut = jet(255);
                    inds = floor((1:nLabels)*255/nLabels);
                    doc.Lut = baseLut(inds,:);
                else
                    doc.Lut = jet(nLabels);
                end
            end
        end
        
        % add ImageDoc to the application
        addDocument(obj.App, doc);
        
        % creates a display for the new image depending on image dimension
        if ~isempty(image) && size(image, 3) > 1
            viewer = imagem.gui.Image3DSliceViewer(obj, doc);
        else
            viewer = imagem.gui.PlanarImageViewer(obj, doc);
        end
        addView(doc, viewer);
    end

    function [frame, doc] = createTableFrame(obj, table)
        % Create a new Frame for displaying the table.
        %
        % Usage:
        %    [frame, doc] = createTableFrame(obj, table);
        %
        
        % initialize table doc
        doc = imagem.app.TableDoc(table);
        
        % setup document tag
        if nargin < 4
            tag = createTableTag(obj.App, table);
        else
            tag = createTableTag(obj.App, table, refTag);
        end
        doc.Tag = tag;

        % add ImageDoc to the application
        addDocument(obj.App, doc);

        frame = imagem.gui.TableFrame(obj, doc);
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

classdef ImageViewer < imagem.gui.ImagemFrame
% Base class for all viewers (figures) containing images.
%
%   Class ImageViewer
%
%   Usage
%   % in sub-class constructor:
%   obj = obj@imagem.gui.ImageViewer(gui, doc);
%
%   Example
%     classdef PlanarImageViewer < imagem.gui.ImageViewer
%     methods
%         function obj = PlanarImageViewer(gui, doc)
%             % create new viewer by calling ImageViewer constructor
%             obj = obj@imagem.gui.ImageViewer(gui, doc);
%         end
%     end % end methods
%     end % end classdef
%
%   See also
%     ImagemFrame, PlanarImageViewer, Image3DSliceViewer
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2019-08-21,    using Matlab 9.6.0.1072779 (R2019a)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    % The image document.
    Doc;
    
    
    % A row vector of two values indicating minimal and maximal displayable
    % values for grayscale and intensity images.
    DisplayRange;
    
    
    % The set of image display listeners, stored as a cell array.
    ImageDisplayListeners = [];
    
    % The set of mouse listeners, stored as a cell array.
    MouseListeners = [];
    
    % The currently selected tool.
    CurrentTool = [];
    
end % end properties


%% Getter / Setter methods
methods
    function set.CurrentTool(obj, newTool)
        
        % remove previous tool
        if ~isempty(obj.CurrentTool)
            deselect(obj.CurrentTool);
            removeMouseListener(obj, obj.CurrentTool);
        end
        
        % set the new tool
        obj.CurrentTool = newTool;
        
        % initialize new tool if not empty
        if ~isempty(newTool)
            select(newTool);
            addMouseListener(obj, newTool);
        end
    end
    
end % getter / setter methods


%% Abstract methods
methods (Abstract)
    % Refresh display of current image.
    updateDisplay(obj);
    
end


%% Constructor
methods
    function obj = ImageViewer(gui, doc)
        % Constructor for ImageViewer class.
        %
        %  Usage:
        %  OBJ = imagem.gui.ImageViewer(GUI, DOC);
        %  where GUI is an instance of ImagemGUI, and DOC is an instance of
        %  ImageDoc.
        
        % call constructor of super class
        obj = obj@imagem.gui.ImagemFrame(gui);
        obj.Doc = doc;
    end

end % end constructors


%% Methods
methods

    function updateTitle(obj)
        % Set up title of the figure, depending on image size and type.
        
        % small checkup, because function can be called before figure was
        % initialised
        if ~isfield(obj.Handles, 'Figure')
            return;
        end
        
        if isempty(obj.Doc) || isempty(obj.Doc.Image)
            return;
        end
        
        % setup name to display
        imgName = imageNameForDisplay(obj.Doc);
    
        % determine the type to display:
        % * data type for intensity / grayscale image
        % * type of image otherwise
        switch obj.Doc.Image.Type
            case 'grayscale'
                type = class(obj.Doc.Image.Data);
            case 'color'
                type = 'color';
            otherwise
                type = obj.Doc.Image.Type;
        end
        
        % compute image zoom
        zoom = currentZoomLevel(obj);
        
        % compute new title string
        nd = ndims(obj.Doc.Image);
        sizePattern = ['%d' repmat(' x %d', 1, nd-1)];
        sizeString = sprintf(sizePattern, size(obj.Doc.Image, 1:nd));
        nf = size(obj.Doc.Image, 5);
        if nf > 1
            sizeString = sprintf('%s (x%d)', sizeString, nf);
        end
        zoomString = sprintf('%g:%g', max(1, zoom), max(1, 1/zoom));
        titlePattern = '%s [%s %s] - %s - ImageM';
        titleString = sprintf(titlePattern, imgName, sizeString, type, zoomString);
        
        % display new title
        set(obj.Handles.Figure, 'Name', titleString);
    end
    
    function z = currentZoomLevel(obj) %#ok<MANU>
        % Default method for returning zoom level (default value is 1).
        z = 1;
    end
end % end methods

%% Utility methods
methods
    function doc = currentDoc(obj)
        doc = obj.Doc;
    end
    
    function img = currentImage(obj)
        % Return the current image (may be empty).
        img = [];
        doc = obj.Doc;
        if ~isempty(doc)
            img = doc.Image;
        end
    end
    
    function updatePreviewImage(obj, image)
        % Update preview image of document and refresh display.
        obj.Doc.PreviewImage = image;
        updateDisplay(obj);
    end
    
    function clearPreviewImage(obj)
        % Clear preview image of document and refresh display.
        obj.Doc.PreviewImage = [];
        updateDisplay(obj);
    end
end


%% Figure management
methods
    function close(obj, varargin)
        % Default implementation for closing frame.
        %
        % Actions:
        % * remove the view from the doc
        % * if this view was the last one attached to the doc, remove the
        %   doc from the app
        % * close the Figure widget
        
        if ~isempty(obj.Doc)
            try
                removeView(obj.Doc, obj);
                
                if isempty(obj.Doc.Views)
                    obj.Gui.App.removeDocument(obj.Doc);
                end
                
            catch ME %#ok<NASGU>
                warning([mfilename ':close'], ...
                    'Current view is not referenced in document...');
            end
        end
        delete(obj.Handles.Figure);
    end
end    


%% Image display listeners management
methods
    function addImageDisplayListener(obj, listener)
        % Add a mouse listener to obj viewer.
        obj.ImageDisplayListeners = [obj.ImageDisplayListeners {listener}];
    end
    
    function removeImageDisplayListener(obj, listener)
        % Remove a mouse listener from obj viewer.
        
        % find which listeners are the same as the given one
        inds = false(size(obj.ImageDisplayListeners));
        for i = 1:numel(obj.ImageDisplayListeners)
            if obj.ImageDisplayListeners{i} == listener
                inds(i) = true;
            end
        end
        
        % remove first existing listener
        inds = find(inds);
        if ~isempty(inds)
            obj.ImageDisplayListeners(inds(1)) = [];
        end
    end
    
    function processDisplayRangeChanged(obj, hObject, eventdata)
        % propagates image display event to all listeners.
        for i = 1:length(obj.ImageDisplayListeners)
            onDisplayRangeChanged(obj.ImageDisplayListeners{i}, hObject, eventdata);
        end
    end
    
    function processCurrentSliceChanged(obj, hObject, eventdata)
        % propagates image display event to all listeners.
        for i = 1:length(obj.ImageDisplayListeners)
            onCurrentSliceChanged(obj.ImageDisplayListeners{i}, hObject, eventdata);
        end
    end
    
    function processCurrentChannelChanged(obj, hObject, eventdata)
        % propagates image display event to all listeners.
        for i = 1:length(obj.ImageDisplayListeners)
            onCurrentChannelChanged(obj.ImageDisplayListeners{i}, hObject, eventdata);
        end
    end
end


%% Mouse listeners management
methods
    function addMouseListener(obj, listener)
        % Add a mouse listener to obj viewer.
        obj.MouseListeners = [obj.MouseListeners {listener}];
    end
    
    function removeMouseListener(obj, listener)
        % Remove a mouse listener from obj viewer.
        
        % find which listeners are the same as the given one
        inds = false(size(obj.MouseListeners));
        for i = 1:numel(obj.MouseListeners)
            if obj.MouseListeners{i} == listener
                inds(i) = true;
            end
        end
        
        % remove first existing listener
        inds = find(inds);
        if ~isempty(inds)
            obj.MouseListeners(inds(1)) = [];
        end
    end
    
    function processMouseButtonPressed(obj, hObject, eventdata)
        % propagates mouse event to all listeners.
        for i = 1:length(obj.MouseListeners)
            onMouseButtonPressed(obj.MouseListeners{i}, hObject, eventdata);
        end
    end
    
    function processMouseButtonReleased(obj, hObject, eventdata)
        % propagates mouse event to all listeners.
        for i = 1:length(obj.MouseListeners)
            onMouseButtonReleased(obj.MouseListeners{i}, hObject, eventdata);
        end
    end
    
    function processMouseMoved(obj, hObject, eventdata)
        % propagates mouse event to all listeners.
        for i = 1:length(obj.MouseListeners)
            onMouseMoved(obj.MouseListeners{i}, hObject, eventdata);
        end
    end
end

end % end classdef


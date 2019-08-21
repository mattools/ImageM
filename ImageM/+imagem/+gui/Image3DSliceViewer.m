classdef Image3DSliceViewer < imagem.gui.ImageViewer
% Viewer for 3D images that displays a single slice
%
%   Class Image3DSliceViewer
%
%   Example
%   Image3DSliceViewer
%
%   See also
%     ImageViewer, PlanarImageViewer
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-08-21,    using Matlab 9.6.0.1072779 (R2019a)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    % The index of the visible slice (between 1 and ZMax).
    SliceIndex;
    
    % The XY slice to be displayed, as an instance of Image class.
    SliceImage;
    
    % A row vector of two values indicating minimal and maximal displayable
    % values for grayscale and intensity images.
    DisplayRange;
    
    % Specify how to change the zoom when figure is resized. 
    % Can be one of:
    % 'adjust'  -> find best zoom (default)
    % 'fixed'   -> keep previous zoom factor
    ZoomMode = 'adjust';
    
    % The set of mouse listeners, stored as a cell array.
    MouseListeners = [];
    
    % The currently selected tool.
    CurrentTool = [];
    
    % A selected shape.
    Selection = [];
end % end properties


%% Constructor
methods
    function obj = Image3DSliceViewer(gui, doc)
    % Constructor for Image3DSliceViewer class
        
        % call constructor of super class
        obj = obj@imagem.gui.ImageViewer(gui, doc);
        
        % setup initial slice index
        obj.SliceIndex = ceil(size(obj.Doc.Image, 3) / 2);

        % computes a new handle index large enough not to collide with
        % common figure handles
        while true
            newFigHandle = 23000 + randi(10000);
            if ~ishandle(newFigHandle)
                break;
            end
        end

        % create the figure that will contains the display
        fig = figure(newFigHandle);
        set(fig, ...
            'MenuBar', 'none', ...
            'NumberTitle', 'off', ...
            'NextPlot', 'new', ...
            'Name', 'Image3D Slice Viewer', ...
            'Visible', 'Off', ...
            'CloseRequestFcn', @obj.close);
        obj.Handles.Figure = fig;

        % create main figure menu
        createFigureMenu(gui, fig, obj);
        
        % creates the layout
        setupLayout(fig);
        
        updateDisplay(obj);
        updateTitle(obj);
        
        % adjust zoom to view the full image
        api = iptgetapi(obj.Handles.ScrollPanel);
        mag = api.findFitMag();
        api.setMagnification(mag);

        % setup listeners associated to the figure
        if ~isempty(doc) && ~isempty(doc.Image)
            set(fig, 'WindowButtonDownFcn',     @obj.processMouseButtonPressed);
            set(fig, 'WindowButtonUpFcn',       @obj.processMouseButtonReleased);
            set(fig, 'WindowButtonMotionFcn',   @obj.processMouseMoved);

            % setup mouse listener for display of mouse coordinates
            tool = imagem.gui.tools.ShowCursorPositionTool(obj, 'showMousePosition');
            addMouseListener(obj, tool);
            
            % setup key listener
            set(fig, 'KeyPressFcn',     @obj.onKeyPressed);
            set(fig, 'KeyReleaseFcn',   @obj.onKeyReleased);
        end
        
        set(fig, 'UserData', obj);
        set(fig, 'Visible', 'On');
        
        function setupLayout(hf)
            
            % vertical layout: image display and status bar
            mainPanel = uix.VBox('Parent', hf, ...
                'Units', 'normalized', ...
                'Position', [0 0 1 1]);
            
            % panel for image display
            displayPanel = uix.HBox('Parent', mainPanel);

            % Slider for choosing slice index
            img = obj.Doc.Image;
            if ~isempty(img)
                % slider for slice
                zmin = 1;
                zmax = size(img, 3);
                zstep1 = 1/zmax;
                zstep2 = min(10/zmax, .5);
                obj.Handles.ZSlider = uicontrol('Style', 'slider', ...
                    'Parent', displayPanel, ...
                    'Min', zmin, 'Max', zmax', ...
                    'SliderStep', [zstep1 zstep2], ...
                    'Value', obj.SliceIndex, ...
                    'Callback', @obj.onSliceSliderChanged, ...
                    'BackgroundColor', [1 1 1]);
                
                % code for dragging the slider thumb
                % @see http://undocumentedmatlab.com/blog/continuous-slider-callback
                addlistener(obj.Handles.ZSlider, ...
                    'ContinuousValueChange', @obj.onSliceSliderChanged);
            end
%             sliceIndexPanel = uipanel('Parent', displayPanel, ...
%                 'resizeFcn', @obj.onScrollPanelResized);

            % scrollable panel for image display
            scrollPanel = uipanel('Parent', displayPanel, ...
                'resizeFcn', @obj.onScrollPanelResized);
          
            % creates an axis that fills the available space
            ax = axes('Parent', scrollPanel, ...
                'Units', 'Normalized', ...
                'NextPlot', 'add', ...
                'Position', [0 0 1 1]);
            
            % initialize image display with default image. 
            hIm = imshow(ones(10, 10), 'parent', ax);
            obj.Handles.ScrollPanel = imscrollpanel(scrollPanel, hIm);

            displayPanel.Widths = [20 -1];
            
            % keep widgets handles
            obj.Handles.ImageAxis = ax;
            obj.Handles.Image = hIm;

            % in case of empty doc, hides the axis
            if isempty(obj.Doc) || isempty(obj.Doc.Image)
                set(ax, 'Visible', 'off');
                set(hIm, 'Visible', 'off');
            end

            % info panel for cursor position and value
            obj.Handles.InfoPanel = uicontrol(...
                'Parent', mainPanel, ...
                'Style', 'text', ...
                'String', ' x=    y=     I=', ...
                'HorizontalAlignment', 'left');
                        
            % set up relative sizes of layouts
            mainPanel.Heights = [-1 20];

            % once each panel has been resized, setup image magnification
            api = iptgetapi(obj.Handles.ScrollPanel);
            mag = api.findFitMag();
            api.setMagnification(mag);
        end

    end

end % end constructors

%% Methods specific to Image3DSliceViewer
methods
    function updateSliceIndex(obj, newIndex)
        if isempty(obj.Doc.Image)
            return;
        end
        
        obj.SliceIndex = newIndex;
        
%         updateSliceImage(obj);
        
        updateDisplay(obj);
%         set(obj.Handles.Image, 'CData', obj.Slice);
        
        % update gui information for slider and textbox
        set(obj.Handles.ZSlider, 'Value', newIndex);
%         set(obj.Handles.ZEdit, 'String', num2str(newIndex));
    end
    
    function updateSliceImage(obj)
        % Recompute the slice image from current image and slice index.

        % current image is either the document image, or the preview image
        % if there is one
        img = obj.Doc.Image;
        if ~isempty(obj.Doc.PreviewImage)
            img = obj.Doc.PreviewImage;
        end
        
        index = obj.SliceIndex;
        
        obj.SliceImage = slice(img, 3, index);
        
        if strcmpi(obj.SliceImage.Type, 'vector')
            obj.SliceImage = norm(obj.SliceImage);
        end
    end
    
end

%% Methods for Display
methods
    
    function updateDisplay(obj)
        % Refresh image display of the current slice

        % basic check up to avoid problems when display is already closed
        if ~ishandle(obj.Handles.ScrollPanel)
            return;
        end
        
        % check up doc validity
        if isempty(obj.Doc) || isempty(obj.Doc.Image)
            return;
        end
        
        updateSliceImage(obj);
        img = obj.SliceImage;
        
        % compute display data
        % TODO: label image need to use LUT and BGCOLOR
        cdata = imagem.gui.ImageUtils.computeDisplayImage(img);
       
        % changes current display data
        api = iptgetapi(obj.Handles.ScrollPanel);
%         loc = api.getVisibleLocation();
        api.replaceImage(cdata, 'PreserveView', true);
        
        % extract calibration data
        spacing = img.Spacing;
        origin  = img.Origin;
        
        % set up spatial calibration
        dim     = size(img);
        xdata   = ([0 dim(1)-1] * spacing(1) + origin(1));
        ydata   = ([0 dim(2)-1] * spacing(2) + origin(2));
        
        set(obj.Handles.Image, 'XData', xdata);
        set(obj.Handles.Image, 'YData', ydata);
        
        % setup axis extent from image extent
        extent = physicalExtent(img);
        set(obj.Handles.ImageAxis, 'XLim', extent(1:2));
        set(obj.Handles.ImageAxis, 'YLim', extent(3:4));
%         api.setVisibleLocation(loc);
        
        % eventually adjust displayrange
        if isGrayscaleImage(img) || isIntensityImage(img) || isVectorImage(img)
            % get min and max display values, or recompute them
            if isempty(obj.DisplayRange)
                [mini, maxi] = imagem.gui.ImageUtils.computeDisplayRange(img);
            else
                mini = obj.DisplayRange(1);
                maxi = obj.DisplayRange(2);
            end
            
            set(obj.Handles.ImageAxis, 'CLim', [mini maxi]);
        end
        
        % set up lookup table (if not empty)
        if ~isColorImage(img) && ~isempty(obj.Doc.Lut)
            colormap(obj.Handles.ImageAxis, obj.Doc.Lut);
        end
        
        % remove all axis children that are not image
        children = get(obj.Handles.ImageAxis, 'Children');
        for i = 1:length(children)
            child = children(i);
            if ~strcmpi(get(child, 'type'), 'image')
                delete(child);
            end
        end
        
%         % display each shape stored in document
%         drawShapes(obj);
    end
    

    function updateTitle(obj)
        % Set up title of the figure, containing name of figure and current zoom
        
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
        zoom = getZoom(obj);
        
        % compute new title string 
        titlePattern = 'ImageM - %s [%d x %d x %d %s] - %g:%g';
        titleString = sprintf(titlePattern, imgName, ...
            size(obj.Doc.Image), type, max(1, zoom), max(1, 1/zoom));

        % display new title
        set(obj.Handles.Figure, 'Name', titleString);
    end
    
    function copySettings(obj, that)
        % copy display settings from another viewer
        obj.DisplayRange = that.DisplayRange;
        obj.ZoomMode = that.ZoomMode;
    end
end


%% Zoom Management
methods
    function zoom = getZoom(obj)
        api = iptgetapi(obj.Handles.ScrollPanel);
        zoom = api.getMagnification();
    end
    
    function setZoom(obj, newZoom)
        api = iptgetapi(obj.Handles.ScrollPanel);
        api.setMagnification(newZoom);
    end
    
    function zoom = findBestZoom(obj)
        api = iptgetapi(obj.Handles.ScrollPanel);
        zoom = api.findFitMag();
    end
    
    function mode = getZoomMode(obj)
        mode = obj.ZoomMode;
    end
    
    function setZoomMode(obj, mode)
        switch lower(mode)
            case 'adjust'
                obj.ZoomMode = 'adjust';
            case 'fixed'
                obj.ZoomMode = 'fixed';
            otherwise
                error(['Unrecognized zoom mode option: ' mode]);
        end
    end
end

%% GUI Widgets listeners
methods
    function onSliceSliderChanged(obj, hObject, eventdata) %#ok<*INUSD>
        if isempty(obj.Doc.Image)
            return;
        end
        
        zslice = round(get(hObject, 'Value'));
        zslice = max(get(hObject, 'Min'), min(get(hObject, 'Max'), zslice));

        updateSliceIndex(obj, zslice);
    end
end

%% Mouse listeners management
methods
    function addMouseListener(obj, listener)
        % Add a mouse listener to obj viewer
        obj.MouseListeners = [obj.MouseListeners {listener}];
    end
    
    function removeMouseListener(obj, listener)
        % Remove a mouse listener from obj viewer
        
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
        % propagates mouse event to all listeners
        for i = 1:length(obj.MouseListeners)
            onMouseButtonPressed(obj.MouseListeners{i}, hObject, eventdata);
        end
    end
    
    function processMouseButtonReleased(obj, hObject, eventdata)
        % propagates mouse event to all listeners
        for i = 1:length(obj.MouseListeners)
            onMouseButtonReleased(obj.MouseListeners{i}, hObject, eventdata);
        end
    end
    
    function processMouseMoved(obj, hObject, eventdata)
        % propagates mouse event to all listeners
        for i = 1:length(obj.MouseListeners)
            onMouseMoved(obj.MouseListeners{i}, hObject, eventdata);
        end
    end
end

%% Mouse listeners management
methods
    function onKeyPressed(obj, hObject, eventdata) %#ok<INUSL>
%         disp(['key pressed: ' eventdata.Character]);
        
        key = eventdata.Character;
        switch key
        case '+'
            zoom = getZoom(obj);
            setZoom(obj, zoom * sqrt(2));
            updateTitle(obj);
            
        case '-'
            zoom = getZoom(obj);
            setZoom(obj, zoom / sqrt(2));
            updateTitle(obj);
            
        case '='
            setZoom(obj, 1);
            updateTitle(obj);
            
        end
    end
    
    function onKeyReleased(obj, hObject, eventdata) %#ok<INUSD>
%         disp(['key relased: ' eventdata.Character]);
    end
    
end

%% Figure management
methods
    function close(obj, varargin)
%         disp('Close image viewer');
        if ~isempty(obj.Doc)
            try
                removeView(obj.Doc, obj);
            catch ME %#ok<NASGU>
                warning('PlanarImageViewer:close', ...
                    'Current view is not referenced in document...');
            end
        end
        delete(obj.Handles.Figure);
    end
    
    function onScrollPanelResized(obj, varargin)
        % function called when the Scroll panel has been resized
        
       if strcmp(obj.ZoomMode, 'adjust')
            if ~isfield(obj.Handles, 'scrollPanel')
                return;
            end
            scroll = obj.Handles.ScrollPanel;
            api = iptgetapi(scroll);
            mag = api.findFitMag();
            api.setMagnification(mag);
            updateTitle(obj);
        end
    end
    
end

end % end classdef


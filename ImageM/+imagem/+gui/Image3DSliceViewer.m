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
    
   
    % Specify how to change the zoom when figure is resized. 
    % Can be one of:
    % 'adjust'  -> find best zoom (default)
    % 'fixed'   -> keep previous zoom factor
    ZoomMode = 'adjust';
    
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

        % setup default display options
        [mini, maxi] = imagem.gui.ImageUtils.computeDisplayRange(obj.Doc.Image);
        obj.DisplayRange = [mini maxi];
        
        
        % create the figure that will contains the display
        fig = createNewFigure(gui, ...
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
            tool = imagem.tools.ShowCursorPosition(obj, 'showMousePosition');
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
    
    function sliceImage = updateSliceImage(obj)
        % Recompute the slice image from current image and slice index.

        % current image is either the document image, or the preview image
        % if there is one
        img = obj.Doc.Image;
        if ~isempty(obj.Doc.PreviewImage)
            img = obj.Doc.PreviewImage;
        end
        
        index = obj.SliceIndex;
        obj.SliceImage = slice(img, index);
        
        if strcmpi(obj.SliceImage.Type, 'vector')
            obj.SliceImage = norm(obj.SliceImage);
        end
        
        if nargout > 0
            sliceImage = obj.SliceImage;
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
        
        img = obj.Doc.Image;
        sliceImage = updateSliceImage(obj);
        
        % compute display data
        cdata = imagem.gui.ImageUtils.computeDisplayImage(sliceImage, obj.Doc.ColorMap, obj.DisplayRange, obj.Doc.BackgroundColor);
       
        % changes current display data
        api = iptgetapi(obj.Handles.ScrollPanel);
%         loc = api.getVisibleLocation();
        api.replaceImage(cdata, 'PreserveView', true);
        
        % extract calibration data
        spacing = sliceImage.Spacing;
        origin  = sliceImage.Origin;
        
        % set up spatial calibration
        dim     = size(sliceImage);
        xdata   = ([0 dim(1)-1] * spacing(1) + origin(1));
        ydata   = ([0 dim(2)-1] * spacing(2) + origin(2));
        
        set(obj.Handles.Image, 'XData', xdata);
        set(obj.Handles.Image, 'YData', ydata);
        
        % setup axis extent from image extent
        extent = physicalExtent(sliceImage);
        set(obj.Handles.ImageAxis, 'XLim', extent(1:2));
        set(obj.Handles.ImageAxis, 'YLim', extent(3:4));
%         api.setVisibleLocation(loc);
        
        % eventually adjust displayrange (for the whole image)
        if isGrayscaleImage(img) || isIntensityImage(img) || isVectorImage(img)
            mini = obj.DisplayRange(1);
            maxi = obj.DisplayRange(2);
            set(obj.Handles.ImageAxis, 'CLim', [mini maxi]);
        end
        
        % set up lookup table (if not empty)
        if ~isColorImage(sliceImage) && ~isLabelImage(img) && ~isempty(obj.Doc.ColorMap)
            colormap(obj.Handles.ImageAxis, obj.Doc.ColorMap);
        end
        
        % remove all axis children that are not image
        children = get(obj.Handles.ImageAxis, 'Children');
        for i = 1:length(children)
            child = children(i);
            if ~strcmpi(get(child, 'Type'), 'Image')
                delete(child);
            end
        end
        
%         % display each shape stored in document
%         drawShapes(obj);
    end
    
    function copySettings(obj, that)
        % copy display settings from another viewer
        obj.DisplayRange = that.DisplayRange;
        obj.ZoomMode = that.ZoomMode;
    end
end


%% Zoom Management
methods
    function zoom = currentZoomLevel(obj)
        api = iptgetapi(obj.Handles.ScrollPanel);
        zoom = api.getMagnification();
    end
    
    function zoom = getZoom(obj)
        warning('getZoom is deprecated, use currentZoomLevel instead');
        zoom = currentZoomLevel(obj);
    end
    
    function setCurrentZoomLevel(obj, newZoom)
        api = iptgetapi(obj.Handles.ScrollPanel);
        api.setMagnification(newZoom);
    end
    
    function setZoom(obj, newZoom)
        warning('setZoom is deprecated, use setCurrentZoomLevel instead');
        setCurrentZoomLevel(obj, newZoom);
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
        
        % propagate change of current slice event to ImageDisplayListeners
        evt = struct('Source', obj, 'EventName', 'CurrentSliceChanged');
        processCurrentSliceChanged(obj, obj.Handles.Figure, evt);
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
    function onScrollPanelResized(obj, varargin)
        % function called when the Scroll panel has been resized
        
       if strcmp(obj.ZoomMode, 'adjust')
            if ~isfield(obj.Handles, 'ScrollPanel')
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


classdef Image5DSliceViewer < imagem.gui.ImageViewer
% Viewer for 5D images that displays a single slice.
%
%   This class displas a side panel that allows to choose:
%   * the current slice index (Z coordinate)
%   * the current frame index (T coordinate)
%   * the current channel, or the way the channels are displayed.
%
%   Example
%   Image5DSliceViewer
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
    
    % The index of the visible slice (between 1 and TMax).
    FrameIndex;
    
    % The way to display vector images.
    % Default is to display the norm.
    VectorImageConverter = imagem.util.vectorImage.VectorImageNorm();
    
    % The image to be displayed, as a 2D intensity or RGB Image.
    ImageToDisplay;
   
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
    function obj = Image5DSliceViewer(gui, doc)
        % Constructor for Image5DSliceViewer class
        
        % call constructor of super class
        obj = obj@imagem.gui.ImageViewer(gui, doc);
        
        % setup initial slice and frame indices
        obj.SliceIndex = ceil(size(obj.Doc.Image, 3) / 2);
        obj.FrameIndex = ceil(size(obj.Doc.Image, 5) / 2);
        
        % initialize the image to display
        updateImageToDisplay(obj);
        computeDefaultDisplayRange(obj);
        
        
        % create the figure that will contains the display
        fig = createNewFigure(gui, ...
            'Name', 'Image5D Viewer', ...
            'Visible', 'Off', ...
            'CloseRequestFcn', @obj.close);
        obj.Handles.Figure = fig;

        % create main figure menu
        createFigureMenu(gui, fig, obj);
        
        % creates the layout
        setupLayout(obj);
        
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
    end
end

% helper methods for contructor
methods (Access = private)
    
    function setupLayout(obj)
        
        hf = obj.Handles.Figure;
         
        img = obj.Doc.Image;
           
        % horizontal panel: main view in the middle, options left and right
        obj.Handles.HorzPanel = uix.HBoxFlex('Parent', hf, ...
            'Units', 'normalized', ...
            'Position', [0 0 1 1], ...
            'Spacing', 5);
        
        % The panel containing the display options
        obj.Handles.DisplayOptionsPanel = uix.VBox(...
            'Parent', obj.Handles.HorzPanel, ...
            'Padding', 5);


        % setup widgets for vector images display
        vectorImage = 'off';
        if isVectorImage(img) && ~isColorImage(img)
            vectorImage = 'on';
        end
        obj.Handles.VectorImageConvertLabel = uicontrol(...
            'Parent', obj.Handles.DisplayOptionsPanel, ...
            'Style', 'text', ...
            'String', 'Vector Image Display', ...
            'Enable', vectorImage, ...
            'HorizontalAlignment', 'left');
        
        obj.Handles.VectorImageConvertCombo = uicontrol('Style', 'popupmenu', ...
            'Parent', obj.Handles.DisplayOptionsPanel, ...
            'String', {'Norm', 'Max Channel', 'First Channel'}, ...
            'Value', 1, ...
            'Enable', vectorImage, ...
            'Callback', @obj.onVectorImageConvertChanged, ...
            'BackgroundColor', [1 1 1]);

        
        % setup widgets for slice index
        zmin = 1;
        zmax = size(img, 3);
        zstep1 = 1/zmax;
        zstep2 = max(min(10/zmax, .5), zstep1);
        
        text = sprintf('Slice index (%d/%d)', obj.SliceIndex, zmax);
        obj.Handles.SliceIndexLabel = uicontrol(...
            'Parent', obj.Handles.DisplayOptionsPanel, ...
            'Style', 'text', ...
            'String', {'', text}, ...
            'HorizontalAlignment', 'left');
        
        obj.Handles.SliceIndexSlider = uicontrol('Style', 'slider', ...
            'Parent', obj.Handles.DisplayOptionsPanel, ...
            'Min', zmin, 'Max', zmax', ...
            'SliderStep', [zstep1 zstep2], ...
            'Value', obj.SliceIndex, ...
            'Callback', @obj.onSliceSliderChanged, ...
            'BackgroundColor', [1 1 1]);
        % code for dragging the slider thumb
        % @see http://undocumentedmatlab.com/blog/continuous-slider-callback
        addlistener(obj.Handles.SliceIndexSlider, ...
            'ContinuousValueChange', @obj.onSliceSliderChanged);
        if zmin == zmax
            set([obj.Handles.SliceIndexLabel obj.Handles.SliceIndexSlider], ...
                'Enable', 'off');
        end
        

        % setup widgets for frame index
        tmin = 1;
        tmax = size(img, 5);
        tstep1 = 1/tmax;
        tstep2 = max(min(10/tmax, .5), tstep1);

        text = sprintf('Frame index (%d/%d)', obj.FrameIndex, tmax);
        obj.Handles.FrameIndexLabel = uicontrol(...
            'Parent', obj.Handles.DisplayOptionsPanel, ...
            'Style', 'text', ...
            'String', {'', text}, ...
            'HorizontalAlignment', 'left');
        
        obj.Handles.FrameIndexSlider = uicontrol('Style', 'slider', ...
            'Parent', obj.Handles.DisplayOptionsPanel, ...
            'Min', tmin, 'Max', tmax', ...
            'SliderStep', [tstep1 tstep2], ...
            'Value', obj.FrameIndex, ...
            'Callback', @obj.onFrameSliderChanged, ...
            'BackgroundColor', [1 1 1]);
        % code for dragging the slider thumb
        % @see http://undocumentedmatlab.com/blog/continuous-slider-callback
        addlistener(obj.Handles.FrameIndexSlider, ...
            'ContinuousValueChange', @obj.onFrameSliderChanged);
        if tmin == tmax
            set([obj.Handles.FrameIndexLabel obj.Handles.FrameIndexSlider], ...
                'Enable', 'off');
        end

        obj.Handles.DisplayOptionsPanel.Heights = [30 20 30 20 30 20];
        
        % vertical layout: image display and status bar
        mainPanel = uix.VBox('Parent', obj.Handles.HorzPanel, ...
            'Units', 'normalized', ...
            'Position', [0 0 1 1]);
      
        % scrollable panel for image display
        scrollPanel = uipanel('Parent', mainPanel, ...
            'resizeFcn', @obj.onScrollPanelResized);
        
        % creates an axis that fills the available space
        ax = axes('Parent', scrollPanel, ...
            'Units', 'Normalized', ...
            'NextPlot', 'add', ...
            'Position', [0 0 1 1]);
        
        % initialize image display with default image.
        hIm = imshow(ones(10, 10), 'parent', ax);
        obj.Handles.ScrollPanel = imscrollpanel(scrollPanel, hIm);
        
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
        
        % set up relative sizes of layouts:
        % 20 pixels for status bar, the remaining for display
        mainPanel.Heights = [-1 20];
        
        obj.Handles.HorzPanel.Widths = [150 -1];
        
        % once each panel has been resized, setup image magnification
        api = iptgetapi(obj.Handles.ScrollPanel);
        mag = api.findFitMag();
        api.setMagnification(mag);
    end
end % end constructors


%% Methods specific to Image5DSliceViewer
methods
    function updateSliceIndex(obj, newIndex)
        if isempty(obj.Doc.Image)
            return;
        end
        
        obj.SliceIndex = newIndex;
        
        text = sprintf('Slice index (%d/%d)', newIndex, size(obj.Doc.Image, 3));
        set(obj.Handles.SliceIndexLabel, 'String', {'', text});
%         updateImageToDisplay(obj);
        
        updateDisplay(obj);
%         set(obj.Handles.Image, 'CData', obj.Slice);
        
        % update gui information for slider and textbox
%         set(obj.Handles.ZSlider, 'Value', newIndex);
%         set(obj.Handles.ZEdit, 'String', num2str(newIndex));
    end
    
    function updateFrameIndex(obj, newIndex)
        if isempty(obj.Doc.Image)
            return;
        end
        
        obj.FrameIndex = newIndex;

        text = sprintf('Frame index (%d/%d)', newIndex, size(obj.Doc.Image, 5));
        set(obj.Handles.FrameIndexLabel, 'String', {'', text});
        
        updateDisplay(obj);
        
        % update gui information for slider and textbox
%         set(obj.Handles.ZSlider, 'Value', newIndex);
    end
    
    
    function sliceImage = updateImageToDisplay(obj)
        % Recompute the image to display from slice/frame/channel indices.
        
        % current image is either the document image, or the preview image
        % if there is one
        img = obj.Doc.Image;
        if ~isempty(obj.Doc.PreviewImage)
            img = obj.Doc.PreviewImage;
        end
        
        % extract the 2D image to display (can be color or channel)
        obj.ImageToDisplay = slice(frame(img, obj.FrameIndex), obj.SliceIndex);
        
        if strcmpi(obj.ImageToDisplay.Type, 'vector')
            obj.ImageToDisplay = convert(obj.VectorImageConverter, obj.ImageToDisplay);
        end
        
        if nargout > 0
            sliceImage = obj.ImageToDisplay;
        end
    end
    
    function computeDefaultDisplayRange(obj)
        % Compute default display range from image to display.
        [mini, maxi] = imagem.gui.ImageUtils.computeDisplayRange(obj.ImageToDisplay);
        obj.DisplayRange = [mini maxi];
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
        sliceImage = updateImageToDisplay(obj);
        
        % compute display data
        cdata = imagem.gui.ImageUtils.computeDisplayImage(sliceImage, ...
            obj.Doc.ColorMap, obj.DisplayRange, obj.Doc.BackgroundColor);
       
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
        if isGrayscaleImage(sliceImage) || isIntensityImage(sliceImage)
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
    function onVectorImageConvertChanged(obj, hObject, eventdata) %#ok<*INUSD>
        if isempty(obj.Doc.Image)
            return;
        end
        
        index = round(get(hObject, 'Value'));
        switch index
            case 1
                obj.VectorImageConverter = imagem.util.vectorImage.VectorImageNorm();
            case 2
                obj.VectorImageConverter = imagem.util.vectorImage.VectorImageMaxChannel();
            case 3
                obj.VectorImageConverter = imagem.util.vectorImage.VectorImageSingleChannel(1);
            otherwise
                error('Can not interpret value');
        end
        
        % recompute image to display, to be able to update display ranges
        updateImageToDisplay(obj);
        computeDefaultDisplayRange(obj);
        
        updateDisplay(obj);
    end
    
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
    
    function onFrameSliderChanged(obj, hObject, eventdata) %#ok<*INUSD>
        if isempty(obj.Doc.Image)
            return;
        end
        
        tslice = round(get(hObject, 'Value'));
        tslice = max(get(hObject, 'Min'), min(get(hObject, 'Max'), tslice));
        
        updateFrameIndex(obj, tslice);
        
        % propagate change of current slice event to ImageDisplayListeners
        evt = struct('Source', obj, 'EventName', 'CurrentFrameChanged');
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


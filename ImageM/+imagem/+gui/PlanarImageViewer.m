classdef PlanarImageViewer < imagem.gui.ImageViewer
% A viewer for planar images.
%
%   VIEWER = PlanarImageViewer(GUI, DOC)
%   Creates a VIEWER for an ImageM document.
%   GUI: the instance of ImagemGUI that manages all frames
%   DOC: the instance of ImageDoc that contains the data to display.
%
%   Example
%     app = imagem.app.ImagemApp;
%     gui = imagem.gui.ImagemGUI(app);
%     img = Image.read('cameraman.tif');
%     doc = imagem.app.ImageDoc(image);
%     addDocument(app, doc);
%     viewer = imagem.gui.PlanarImageViewer(obj, doc);
%
%   See also
%     ImagemGUI, PlanarImageViewer, ImageDoc
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2011-03-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


properties
    % Specify how to change the zoom when figure is resized. 
    % Can be one of:
    % 'adjust'  -> find best zoom (default)
    % 'fixed'   -> keep previous zoom factor
    ZoomMode = 'adjust';
    
    % A selected shape, as an instance of a Geometry class.
    Selection = [];
end


%% Constructor
methods
    function obj = PlanarImageViewer(gui, doc)
        
        % call constructor of super class
        obj = obj@imagem.gui.ImageViewer(gui, doc);

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
            'Name', 'ImageM Main Figure', ...
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
            displayPanel = uix.VBox('Parent', mainPanel);
            
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
end

%% Methods

methods
    
    function updateDisplay(obj)
        % Refresh image display of the current slice

        % basic check up to avoid problems when display is already closed
        if ~ishandle(obj.Handles.ScrollPanel)
            return;
        end
        
        % check up doc validity
        doc = obj.Doc;
        if isempty(doc) || isempty(doc.Image)
            return;
        end
        
        % current image is either the document image, or the preview image
        % if there is one
        img = doc.Image;
        if ~isempty(doc.PreviewImage)
            img = doc.PreviewImage;
        end
        
        % compute display data
        cdata = imagem.gui.ImageUtils.computeDisplayImage(img, doc.ColorMap, obj.DisplayRange, doc.BackgroundColor);
       
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
        if ~isColorImage(img) && ~isLabelImage(img) && ~isempty(doc.ColorMap)
            colormap(obj.Handles.ImageAxis, doc.ColorMap);
        end
        
        % remove all axis children that are not image
        children = get(obj.Handles.ImageAxis, 'Children');
        for i = 1:length(children)
            child = children(i);
            if ~strcmpi(get(child, 'type'), 'image')
                delete(child);
            end
        end
        
        % display each shape stored in document
        drawShapes(obj);
    end

    function copySettings(obj, that)
        % copy display settings from another viewer
        obj.DisplayRange = that.DisplayRange;
        obj.ZoomMode = that.ZoomMode;
    end
end

%% Shapes and Annotation management
methods
        
    function drawShapes(obj)
        shapes = obj.Doc.Shapes;
        for i = 1:length(shapes)
            drawShape(obj, shapes{i});
        end
    end
    
    function h = drawShape(obj, shape)
        
        % extract current axis
        ax = obj.Handles.ImageAxis;
        
        h = draw(ax, shape);
    end

end

%% Zoom Management
methods
    function zoom = currentZoomLevel(obj)
        api = iptgetapi(obj.Handles.ScrollPanel);
        zoom = api.getMagnification();
    end
    
    function setCurrentZoomLevel(obj, newZoom)
        api = iptgetapi(obj.Handles.ScrollPanel);
        api.setMagnification(newZoom);
    end
    
    function setZoom(obj, newZoom)
        warning('deprecated function, use "setCurrentZoomLevel" instead');
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


%% Key listeners management
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
                name = obj.Doc.Image.Name;
                warning('PlanarImageViewer:close', ...
                    'Current view is not referenced in document ''%s''...', name);
            end
        end
        delete(obj.Handles.Figure);
    end
    
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

end
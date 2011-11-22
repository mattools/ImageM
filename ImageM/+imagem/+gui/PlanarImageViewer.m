classdef PlanarImageViewer < handle
%PLANARIMAGEVIEWER  A viewer for planar images
%
%   output = PlanarImageViewer(input)
%
%   Example
%   PlanarImageViewer
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-03-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


properties
    % reference to the GUI
    gui;
   
    % list of handles to the various gui items
    handles;
    
    % the image document
    doc;
    
    mouseListeners = [];
    
    % the tool currently selected
    currentTool = [];
end

methods
    function this = PlanarImageViewer(gui, doc)
        this.gui = gui;
        this.doc = doc;
        
        % create default figure
        fig = figure(...
            'MenuBar', 'none', ...
            'NumberTitle', 'off', ...
            'NextPlot', 'new', ...
            'Name', 'ImageM Main Figure');
        
        % create main figure menu
        setupMenu(fig);
        setupLayout(fig);
        
        this.handles.figure = fig;
        
        updateDisplay(this);
        updateTitle(this);
        
        % setup listeners associated to the figure
        set(fig, 'WindowButtonDownFcn',     @this.processMouseButtonPressed);
        set(fig, 'WindowButtonUpFcn',       @this.processMouseButtonReleased);
        set(fig, 'WindowButtonMotionFcn',   @this.processMouseMoved);

        % setup mouse listener for display of mouse coordinates
        tool = imagem.gui.tools.ShowCursorPositionTool(this, 'showMousePosition');
        addMouseListener(this, tool);
        
        set(fig, 'UserData', this);
        
        function setupMenu(hf)
            
            import imagem.gui.actions.*;
            import imagem.gui.tools.*;
            
            % File Menu Definition 
            
            fileMenu = uimenu(hf, 'Label', 'Files');
            
            action = SayHelloAction(this, 'sayHello');
            uimenu(fileMenu, 'Label', 'Say Hello!', ...
                'Callback', @action.actionPerformed);
            
            demoMenu = uimenu(fileMenu, 'Label', 'Open Demo');
            
%             action = ShowDemoFigureAction(this, 'showCameraman');
%             uimenu(fileMenu, 'Label', 'Show Demo Image', ...
%                 'Callback', @(hObject,eventdata)action.actionPerformed(hObject, eventdata));
            action = ShowDemoFigureAction(this, 'showCameraman');
            uimenu(fileMenu, 'Label', 'Show Demo Image', ...
                'Callback', @(hObject,eventdata)action.actionPerformed(hObject, eventdata));
            
            action = OpenDemoImageAction(this, 'openDemoCameraman', 'cameraman.tif');
            uimenu(demoMenu, 'Label', 'Cameraman', ...
                'Callback', @action.actionPerformed);
            
            action = OpenDemoImageAction(this, 'openDemoRice', 'rice.png');
            uimenu(demoMenu, 'Label', 'Rice', ...
                'Callback', @action.actionPerformed);
            
            action = OpenDemoImageAction(this, 'openDemoPeppers', 'peppers.png');
            uimenu(demoMenu, 'Label', 'Peppers', ...
                'Callback', @action.actionPerformed);
            
            action = OpenDemoImageAction(this, 'openDemoCircles', 'circles.png');
            uimenu(demoMenu, 'Label', 'Circles', ...
                'Callback', @action.actionPerformed);
            
            
            uimenu(fileMenu, 'Label', 'Quit', ...
                'Separator', 'On', ...
                'Callback', @this.close);
            

            % Image Menu Definition 
            
            imageMenu = uimenu(hf, 'Label', 'Image');
            
            action = InvertImageAction(this, 'invertImage');
            uimenu(imageMenu, 'Label', 'Invert Image', ...
                'Callback', @action.actionPerformed);
            
            action = ImageThresholdAction(this, 'thresholdImage');
            uimenu(imageMenu, 'Label', 'Threshold...', ...
                'Callback', @action.actionPerformed);
            
            action = ImageGradientAction(this, 'imageGradient');
            uimenu(imageMenu, 'Label', 'Gradient', ...
                'Callback', @action.actionPerformed);
            
            action = ImageNormAction(this, 'imageNorm');
            uimenu(imageMenu, 'Label', 'Norm', ...
                'Callback', @action.actionPerformed);
            
            action = showImageHistogramAction(this, 'showImageHistogram');
            uimenu(imageMenu, 'Label', 'Histogram', ...
                'Callback', @action.actionPerformed);
            
            action = ApplyImageFunctionAction(this, 'applyImageMethod', 'distanceMap');
            uimenu(imageMenu, 'Label', 'Distance Map', ...
                'Callback', @action.actionPerformed);
            
            
            action = PrintImageDocListAction(this, 'printImageDocList');
            uimenu(imageMenu, 'Label', 'Print Image List', ...
                'Separator', 'on', ...
                'Callback', @action.actionPerformed);

            
            tool = PrintCurrentPointTool(this, 'printCurrentPoint');
            action = SelectToolAction(this, 'selectTool', tool);
            uimenu(imageMenu, 'Label', 'Print Current Point', ...
                'Separator', 'on', ...
                'Callback', @action.actionPerformed);

            tool = SetPixelToWhiteTool(this, 'setPixelToWhite');
            action = SelectToolAction(this, 'selectTool', tool);
            uimenu(imageMenu, 'Label', 'Set Pixel to White', ...
                'Separator', 'on', ...
                'Callback', @action.actionPerformed);

            tool = LineProfileTool(this, 'lineProfile');
            action = SelectToolAction(this, 'selectTool', tool);
            uimenu(imageMenu, 'Label', 'Plot Line Profile', ...
                'Callback', @action.actionPerformed);

        end
        
        function setupLayout(hf)
            
            % vertical layout: image display and status bar
            mainPanel = uiextras.VBox('Parent', hf, ...
                'Units', 'normalized', ...
                'Position', [0 0 1 1]);
            
            % panel for image display
            displayPanel = uiextras.VBox('Parent', mainPanel);
            
            % scrollable panel for image display
            scrollPanel = uipanel('Parent', displayPanel, ...
                'resizeFcn', @this.onScrollPanelResized);
            
            ax = axes('parent', scrollPanel, ...
                'units', 'normalized', ...
                'position', [0 0 1 1]);
            
            % intialize image display with default image. 
            hIm = imshow(ones(10, 10), 'parent', ax);
            this.handles.scrollPanel = imscrollpanel(scrollPanel, hIm);
            
            % keep widgets handles
            this.handles.imageAxis = ax;
            this.handles.image = hIm;

            % info panel for cursor position and value
            this.handles.infoPanel = uicontrol(...
                'Parent', mainPanel, ...
                'Style', 'text', ...
                'String', ' x=    y=     I=', ...
                'HorizontalAlignment', 'left');
                        
            % set up relative sizes of layouts
            mainPanel.Sizes = [-1 20];

            % once each panel has been resized, setup image magnification
            api = iptgetapi(this.handles.scrollPanel);
            mag = api.findFitMag();
            api.setMagnification(mag);
        end
      
    end
end

methods
    
    function updateDisplay(this)
        % Refresh image display of the current slice
        
        % extract or compute display data
        if isGrayscaleImage(this.doc.image) || isColorImage(this.doc.image)
            cdata = permute(this.doc.image.data, [2 1 4 3]);
            mini = 0;
            if islogical(cdata)
                maxi = 1;
            else
                maxi = intmax(class(cdata));
            end
            
        elseif isVectorImage(this.doc.image) 
            imgNorm = norm(this.doc.image);
            cdata = permute(imgNorm.data, [2 1 4 3]);
            mini = min(cdata(:));
            maxi = max(cdata(:));

        else
            % intensity or unknown type
            cdata = permute(this.doc.image.data, [2 1 4 3]);
            mini = min(cdata(:));
            maxi = max(cdata(:));
            
        end
        
        % changes current display data
        api = iptgetapi(this.handles.scrollPanel);
        api.replaceImage(cdata);
        
        % extract calibration data
        spacing = this.doc.image.spacing;
        origin  = this.doc.image.origin;
        
        % set up spatial calibration
        dim     = size(this.doc.image);
        xdata   = ([0 dim(1)-1] * spacing(1) + origin(1));
        ydata   = ([0 dim(2)-1] * spacing(2) + origin(2));
        
        set(this.handles.image, 'XData', xdata);
        set(this.handles.image, 'YData', ydata);
        
        % setup axis extent from imaeg extent
        extent = physicalExtent(this.doc.image);
        set(this.handles.imageAxis, 'XLim', extent(1:2));
        set(this.handles.imageAxis, 'YLim', extent(3:4));
        
        % for vector images, adjust displayrange
        if isVectorImage(this.doc.image) || isIntensityImage(this.doc.image)
            set(this.handles.imageAxis, 'CLim', [mini maxi]);
        end
        
        % adjust zoom to view the full image
        api = iptgetapi(this.handles.scrollPanel);
        mag = api.findFitMag();
        api.setMagnification(mag);
    end
    

    function updateTitle(this)
        % set up title of the figure, containing name of figure and current zoom
        
        % small checkup, because function can be called before figure was
        % initialised
        if ~isfield(this.handles, 'figure')
            return;
        end
        
        % setup name
        if isempty(this.doc.image.name)
            imgName = 'Unknown Image';
        else
            imgName = this.doc.image.name;
        end
    
        % determine the type to display:
        % * data type for intensity / grayscale image
        % * type of image otherwise
        switch this.doc.image.type
            case 'grayscale'
                type = class(this.doc.image.data);
            case 'color'
                type = 'color';
            otherwise
                type = this.doc.image.type;
        end
        
        % compute image zoom
        api = iptgetapi(this.handles.scrollPanel);
        zoom = api.getMagnification();
        
        % compute new title string 
        titlePattern = 'ImageM - %s [%d x %d %s] - %g:%g';
        titleString = sprintf(titlePattern, imgName, ...
            size(this.doc.image), type, max(1, zoom), max(1, 1/zoom));

        % display new title
        set(this.handles.figure, 'Name', titleString);
    end
end

%% Zoom Management
methods
       
    function onZoomIn(this, varargin)
        % multiplies the current zoom by 2
        api = iptgetapi(this.handles.scrollPanel);
        mag = api.getMagnification();
        api.setMagnification(mag * 2);
        this.updateTitle();
    end
    
    function onZoomOut(this, varargin)
        % divides the current zoom by 2
        api = iptgetapi(this.handles.scrollPanel);
        mag = api.getMagnification();
        api.setMagnification(mag / 2);
        this.updateTitle();
    end
    
    function onZoomOne(this, varargin)
        % sete the current zoom to 1
        api = iptgetapi(this.handles.scrollPanel);
        api.setMagnification(1);
        this.updateTitle();
    end
    
    function onZoomBest(this, varargin) 
        % finds the best zoom for current image
        api = iptgetapi(this.handles.scrollPanel);
        mag = api.findFitMag();
        api.setMagnification(mag);
        this.updateTitle();
    end

end


%% Mouse management
methods
    function mouseButtonPressed(this, hObject, eventdata) %#ok<INUSD>
        point = get(this.handles.imageAxis, 'CurrentPoint');
        displayPixelCoords(this, point);
    end
    
    function mouseDragged(this, hObject, eventdata) %#ok<INUSD>
        point = get(this.handles.imageAxis, 'CurrentPoint');
        displayPixelCoords(this, point);
    end
    
    function mouseWheelScrolled(this, hObject, eventdata)
        % when mouse wheel is scrolled, zoom is modified
        if eventdata.VerticalScrollCount < 0
            onZoomIn(this, hObject, eventdata);
        else
            onZoomOut(this, hObject, eventdata);
        end
    end
    
    function displayPixelCoords(this, point)
        
        point = point(1, 1:2);
        coord = round(pointToIndex(this, point));
        
        % control on bounds of image
        if sum(coord < 1) > 0 || sum(coord > size(this.doc.image, [1 2])) > 0
            set(this.handles.infoPanel, 'string', '');
            return;
        end
        
        % Display coordinates of clicked point
        if this.doc.image.calibrated
            % Display pixel + physical position
            locString = sprintf('(x,y) = (%d,%d) px = (%5.2f,%5.2f) %s', ...
                coord(1), coord(2), point(1), point(2), ...
                this.doc.image.unitName);
        else
            % Display only pixel position
            locString = sprintf('(x,y) = (%d,%d) px', coord(1), coord(2));
        end
        
        % Display value of selected pixel
        if strcmp(this.doc.image.type, 'color')
            % case of color pixel: values are red, green and blue
            rgb = this.doc.image(coord(1), coord(2), :);
            valueString = sprintf('  RGB = (%d %d %d)', ...
                rgb(1), rgb(2), rgb(3));
            
        elseif strcmp(this.doc.image.type, 'vector')
            % case of vector image: compute norm of the pixel
            values  = this.doc.image(coord(1), coord(2), :);
            norm    = sqrt(sum(double(values(:)) .^ 2));
            valueString = sprintf('  value = %g', norm);
            
        else
            % case of a gray-scale pixel
            value = this.doc.image(coord(1), coord(2));
            if ~isfloat(value)
                valueString = sprintf('  value = %3d', value);
            else
                valueString = sprintf('  value = %g', value);
            end
        end
        
        set(this.handles.infoPanel, 'string', [locString '  ' valueString]);
    end

    function index = pointToIndex(this, point)
        % Converts coordinates of a point in physical dimension to image index
        % First element is column index, second element is row index, both are
        % given in floating point and no rounding is performed.
        spacing = this.doc.image.spacing(1:2);
        origin  = this.doc.image.origin(1:2);
        index   = (point - origin) ./ spacing + 1;
    end
end

%% Mouse listeners management
methods
    function addMouseListener(this, listener)
        this.mouseListeners = [this.mouseListeners {listener}];
    end
    
    function removeMouseListener(this, listener)
        
        % find which listeners are the same as the given one
        inds = false(size(this.mouseListeners));
        for i = 1:numel(this.mouseListeners)
            if this.mouseListeners{i} == listener
                inds(i) = true;
            end
        end
        
        % remove first existing listener
        inds = find(inds);
        if ~isempty(inds)
            this.mouseListeners(inds(1)) = [];
        end
    end
    
    function processMouseButtonPressed(this, hObject, eventdata)
        for i = 1:length(this.mouseListeners)
            onMouseButtonPressed(this.mouseListeners{i}, hObject, eventdata);
        end
    end
    
    function processMouseButtonReleased(this, hObject, eventdata)
        for i = 1:length(this.mouseListeners)
            onMouseButtonReleased(this.mouseListeners{i}, hObject, eventdata);
        end
    end
    
    function processMouseMoved(this, hObject, eventdata)
        for i = 1:length(this.mouseListeners)
            onMouseMoved(this.mouseListeners{i}, hObject, eventdata);
        end
    end
end

%% Figure management
methods
    function close(this, varargin)
        close(this.handles.figure);
        disp('Closed parent figure');
    end
        
    function onScrollPanelResized(this, varargin)
        % function called when the Scroll panel has been resized
        
        scroll = this.handles.scrollPanel;
        api = iptgetapi(scroll);
        mag = api.findFitMag();
        api.setMagnification(mag);
        updateTitle(this);
    end
    
end

end
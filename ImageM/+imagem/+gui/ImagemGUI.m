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
        
        % display settings
        if ~isempty(image)
            if isLabelImage(image)
                doc.Lut = 'jet';
            end
        end
        
        % add ImageDoc to the application
        addDocument(obj.App, doc);
        
        % creates a display for the new image
        if ~isempty(image) && size(image, 3) > 1
            viewer = imagem.gui.Image3DSliceViewer(obj, doc);
        else
            viewer = imagem.gui.PlanarImageViewer(obj, doc);
        end
        addView(doc, viewer);
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
    function createFigureMenu(obj, hf, frame) %#ok<INUSL>
        
        import imagem.gui.ImagemGUI;
        import imagem.gui.actions.*;
        import imagem.actions.*;
        import imagem.actions.file.*;
        import imagem.actions.edit.*;
        import imagem.actions.image.*;
        import imagem.actions.view.*;
        import imagem.actions.process.*;
        import imagem.actions.process.binary.*;
        import imagem.actions.analyze.*;
        import imagem.gui.tools.*;
        import imagem.tools.*;
                
        % File Menu Definition
        
        fileMenu = addMenu(hf, 'Files');
        
        addMenuItem(fileMenu, CreateImage(),            'New...', 'Accelerator', 'N');
        addMenuItem(fileMenu, OpenImage(),              'Open...', 'Accelerator', 'O');

        demoMenu = addMenu(fileMenu, 'Open Demo');
        addMenuItem(demoMenu, OpenDemoImage('cameraman.tif'), 	'Cameraman (grayscale)');
        addMenuItem(demoMenu, OpenDemoImage('rice.png'),    'Rice (grayscale)');
        addMenuItem(demoMenu, OpenDemoImage('coins.png'),   'Coins (grayscale)');
        addMenuItem(demoMenu, OpenDemoImage('peppers.png'), 'Peppers (RGB)');
        addMenuItem(demoMenu, OpenDemoImage('circles.png'), 'Circles (binary)');
        addMenuItem(demoMenu, OpenDemoImage('text.png'),    'Text (binary)');

        addMenuItem(fileMenu, ImportImageFromWorkspace(),   'Import From Workspace...');
        
        addMenuItem(fileMenu, SaveImage(),              'Save As...', ...
            'Separator', 'on', 'Accelerator', 'S');
        addMenuItem(fileMenu, ExportImageToWorkspace(), 'Export To Workspace...');
        addMenuItem(fileMenu, SaveSelection(),          'Save Selection...', 'Separator', 'on');

        item = addMenuItem(fileMenu, CloseFrame(),      'Close', 'Separator', 'on');
        set(item, 'Accelerator', 'W');

        item = addMenuItem(fileMenu, Exit(), 'Quit');
        set(item, 'Accelerator', 'Q');
        
        
        % Image Menu Definition
        
        imageMenu = addMenu(hf, 'Image');
        
        convertTypeMenu = addMenu(imageMenu,  'Set Image Type');
        addMenuItem(convertTypeMenu, ImageConvertType('binary'),    'Binary');
        addMenuItem(convertTypeMenu, ImageConvertType('grayscale'), 'Grayscale');
        addMenuItem(convertTypeMenu, ImageConvertType('intensity'), 'Intensity');
        addMenuItem(convertTypeMenu, ImageConvertType('label'),     'Label');

        colorMenu = addMenu(imageMenu, 'Color', 'Separator', 'on');
        addMenuItem(colorMenu, SplitImageRGB(),         'Split RGB');
        addMenuItem(colorMenu, SplitImageChannels(),    'Split Channels');
        addMenuItem(colorMenu, MergeImageChannels(),    'Merge Channels...');
        
        convertMenu = addMenu(imageMenu, 'Convert');
        addMenuItem(convertMenu, ConvertImage3DToVectorImage(),    '3D Image to Vector Image');
        addMenuItem(convertMenu, ConvertVectorImageToImage3D(),    'Vector Image to 3D Image');

        addMenuItem(imageMenu, FlipImage(1),            'Horizontal Flip', 'Separator', 'on');
        addMenuItem(imageMenu, FlipImage(2),            'Vertical Flip');
        addMenuItem(imageMenu, RotateImage90(1),        'Rotate Right');
        addMenuItem(imageMenu, RotateImage90(-1),       'Rotate Left');

        addMenuItem(imageMenu, InvertImage(),           'Invert Image', 'Accelerator', 'I', 'Separator', 'on');
        
        addMenuItem(imageMenu, RenameImage(),           'Rename', 'Separator', 'on');
        addMenuItem(imageMenu, DuplicateImage(),        'Duplicate', 'Accelerator', 'D');
        addMenuItem(imageMenu, ExtractSlice(),          'Extract Slice');
        addMenuItem(imageMenu, CropImageSelection(),    'Crop Selection');
        
        
        settingsMenu = addMenu(imageMenu, 'Settings', 'Separator', 'on');
        addMenuItem(settingsMenu, SetDefaultConnectivity(), 'Set Connectivity');
        addMenuItem(settingsMenu, SetBrushSize(),           'Set Brush Size');
        
        
        % View Menu Definition
        
        viewMenu = addMenu(hf, 'View');

        addMenuItem(viewMenu, ImageSetDisplayRange(),   'Set Display Range...');

        lutMenu = addMenu(viewMenu, 'Look-Up Table');
        addMenuItem(lutMenu, SetImageLut('gray'),           'Gray');
        addMenuItem(lutMenu, SetImageLut('inverted'),       'Inverted');
        addMenuItem(lutMenu, SetImageLut('blue-gray-red'),  'Blue-Gray-Red');
        
        addMenuItem(lutMenu, SetImageLut('jet'),            'Jet', 'Separator', 'on');
        addMenuItem(lutMenu, SetImageLut('hsv'),            'HSV');
        addMenuItem(lutMenu, SetImageLut('colorcube'),      'Color Cube');
        addMenuItem(lutMenu, SetImageLut('prism'),          'Prism');
        
        matlabLutMenu = addMenu(lutMenu, 'Matlab''s');
        addMenuItem(matlabLutMenu, SetImageLut('hot'),      'Hot');
        addMenuItem(matlabLutMenu, SetImageLut('cool'),     'Cool');
        addMenuItem(matlabLutMenu, SetImageLut('spring'),   'Spring');
        addMenuItem(matlabLutMenu, SetImageLut('summer'),   'Summer');
        addMenuItem(matlabLutMenu, SetImageLut('winter'),   'Winter');
        addMenuItem(matlabLutMenu, SetImageLut('autumn'),   'Autumn');
        addMenuItem(matlabLutMenu, SetImageLut('copper'),   'Copper');
        addMenuItem(matlabLutMenu, SetImageLut('bone'),     'Bone');
        addMenuItem(matlabLutMenu, SetImageLut('pink'),     'Pink');
        addMenuItem(matlabLutMenu, SetImageLut('lines'),    'Lines');
        
        colorLutMenu = addMenu(lutMenu, 'Simple Colors');
        addMenuItem(colorLutMenu, SetImageLut('blue'),      'Blue');
        addMenuItem(colorLutMenu, SetImageLut('red'),       'Red');
        addMenuItem(colorLutMenu, SetImageLut('green'),     'Green');
        addMenuItem(colorLutMenu, SetImageLut('cyan'),      'Cyan');
        addMenuItem(colorLutMenu, SetImageLut('yellow'),    'Yellow');
        addMenuItem(colorLutMenu, SetImageLut('magenta'),   'Magenta');

        
        addMenuItem(viewMenu, ZoomIn(),         'Zoom In', true);
        addMenuItem(viewMenu, ZoomOut(),        'Zoom Out');
        addMenuItem(viewMenu, ZoomOne(),        'Zoom 1:1');
        addMenuItem(viewMenu, ZoomBestFit(),    'Zoom Best');
        
        zoomsMenu = addMenu(viewMenu, 'Others');
        addMenuItem(zoomsMenu, SetCurrentZoomLevel(8),      'Zoom 8:1');
        addMenuItem(zoomsMenu, SetCurrentZoomLevel(4),      'Zoom 4:1');
        addMenuItem(zoomsMenu, SetCurrentZoomLevel(2),      'Zoom 2:1');
        addMenuItem(zoomsMenu, SetCurrentZoomLevel(1),      'Zoom 1:1');
        addMenuItem(zoomsMenu, SetCurrentZoomLevel(1/2),    'Zoom 1:2');
        addMenuItem(zoomsMenu, SetCurrentZoomLevel(1/4),    'Zoom 1:4');
        addMenuItem(zoomsMenu, SetCurrentZoomLevel(1/8),    'Zoom 1:8');

        zoomModesMenu = addMenu(viewMenu, 'Zoom Mode');
        adjustZoomAction = SetZoomMode('adjust');
        mi1 = addMenuItem(zoomModesMenu, adjustZoomAction,  'Adjust', 'Checked', 'on');
        setMenuItem(adjustZoomAction, mi1);
        
        fixedZoomAction = SetZoomMode('fixed');
        mi2 = addMenuItem(zoomModesMenu, fixedZoomAction,   'Fixed');
        setMenuItem(fixedZoomAction, mi2);

        actionGroup = [adjustZoomAction fixedZoomAction];
        for iAction = 1:2
            action = actionGroup(iAction);
            setActionGroup(action, actionGroup);
        end
        
        addMenuItem(viewMenu, PrintImageDocList(),      'Print Image List', 'Separator', 'on');
        
        
        % Process Menu Definition
        
        processMenu = addMenu(hf, 'Process');
        
        addMenuItem(processMenu, AdjustImageDynamic(),  'Adjust Dynamic');
        addMenuItem(processMenu, ImageLabelToRgb(),     'Label To RGB...');

        addMenuItem(processMenu, ImageBoxMeanFilter(),  'Box Mean Filter...', 'Separator', 'on');
        addMenuItem(processMenu, ImageMedianFilter(),   'Median Filter...');
        addMenuItem(processMenu, ImageGaussianFilter(), 'Gaussian Filter...');
                
        morphoMenu = addMenu(processMenu, 'Morphology');
        addMenuItem(morphoMenu, ImageErosion(),     'Erosion 3x3');
        addMenuItem(morphoMenu, ImageDilation(),    'Dilation 3x3');
        addMenuItem(morphoMenu, ImageOpening(),     'Opening 3x3');
        addMenuItem(morphoMenu, ImageClosing(),     'Closing 3x3');
        addMenuItem(morphoMenu, ImageMorphologicalFilter(), 'Morphological Filter...', 'Separator', 'on');    
        
        addMenuItem(processMenu, ImageThreshold(),      'Threshold...', ...
            'Separator', 'on', 'Accelerator', 'T');
        addMenuItem(processMenu, ImageAutoThresholdOtsu(),  'Auto Threshold (Otsu)');
        addMenuItem(processMenu, ImageGradient(),       'Gradient', ...
            'Separator', 'on', 'Accelerator', 'G');
        addMenuItem(processMenu, ImageMorphoGradient(), 'Morphological Gradient');
        addMenuItem(processMenu, ImageGradientVector(), 'Gradient Vector');
        addMenuItem(processMenu, VectorImageNorm(),     'Norm');

        minimaMenu = addMenu(processMenu, 'Minima / Maxima', 'Separator', 'on');
        addMenuItem(minimaMenu, ImageRegionalMinima(),  'Regional Minima');
        addMenuItem(minimaMenu, ImageRegionalMaxima(),  'Regional Maxima');
        addMenuItem(minimaMenu, ImageExtendedMinima(),  'Extended Minima...');
        addMenuItem(minimaMenu, ImageExtendedMaxima(),  'Extended Maxima...');
        addMenuItem(minimaMenu, ImageImposeMinima(),    'Impose Minima...');
        
        addMenuItem(processMenu, ImageWatershed(),      'Watershed...');
        addMenuItem(processMenu, ImageExtendedMinWatershed(),   'Extended Min Watershed...');
        
        addMenuItem(processMenu, ImageArithmetic(),     'Image Arithmetic...', true);
        addMenuItem(processMenu, ImageValuesTransform(),'Image Maths 1...');
        addMenuItem(processMenu, ImageMathematic(),     'Image Maths 2...');
        
        binaryMenu = addMenu(processMenu, 'Binary / Labels', 'Separator', 'on');
        addMenuItem(binaryMenu, KillImageBorders(),     'Kill Borders');
        addMenuItem(binaryMenu, ImageAreaOpening(),     'Area Opening');
        addMenuItem(binaryMenu, KeepLargestRegion(),    'Keep Largest Region');
        addMenuItem(binaryMenu, FillImageHoles(),       'Fill Holes');

        addMenuItem(binaryMenu, ApplyImageFunction('distanceMap'), 'Distance Map');
        addMenuItem(binaryMenu, ImageSkeleton(),        'Skeleton');
        addMenuItem(binaryMenu, ConnectedComponentsLabeling(),  'Connected Components Labeling');
        
        addMenuItem(binaryMenu, ImageBooleanOp(),       'Boolean Operation...', true);
        addMenuItem(binaryMenu, BinaryImageOverlay(),   'Image Overlay');
        
        % Interactive tools
        
        toolsMenu = addMenu(hf, 'Tools');
        
        tool = PrintCurrentPointPosition(frame);
        addMenuItem(toolsMenu, SelectTool(tool),        'Print Current Point');

        tool = ScrollImagePosition(frame);
        addMenuItem(toolsMenu, SelectTool(tool),        'Scroll Image');
        
        addMenuItem(toolsMenu, SelectTool(SelectRectangle(frame)),  'Select Rectangle', true);
        addMenuItem(toolsMenu, SelectTool(SelectPolyline(frame)),   'Select Polyline');
        addMenuItem(toolsMenu, SelectTool(SelectPoints(frame)),     'Select Points');
        addMenuItem(toolsMenu, SelectTool(SelectLineSegment(frame)),'Select Line Segment');

        addMenuItem(toolsMenu, SelectTool(SetPixelToWhite(frame)), ...
            'Set Pixel to White', true);
        
        addMenuItem(toolsMenu, SelectTool(Brush(frame)),            'Brush');
        addMenuItem(toolsMenu, PlotLabelMapCurvesFromTable(),       'Plot Curves From Labels...');
        
        
        % Analyze Menu Definition
        
        analyzeMenu = addMenu(hf, 'Analyze');
        
        addMenuItem(analyzeMenu, SetImageScale(),       'Set Image Scale');
        addMenuItem(analyzeMenu, AnalyzeImageRegions(), 'Analyze Regions');
        addMenuItem(analyzeMenu, ShowImageHistogram(),  'Histogram', ...
            'Accelerator', 'H');

        addMenuItem(analyzeMenu, PlotImageLineProfile(),'Plot Line Profile', ...
            'Accelerator', 'K');
        
        
        % Help menu definition
        helpMenu = addMenu(hf, 'Help');
        
        addMenuItem(helpMenu, ...
            imagem.actions.GenericAction(...
            @(frm) printHistory(frm.Gui.App)), ...
            'Print History');

        function menu = addMenu(parent, label, varargin)
            % Add a new menu to the given figure or menu
            % Computes the new level of the menu
            
            parentType = get(parent, 'type');
            if strcmp(parentType, 'figure')
                % counts the number of menus in the parent figure
                children = get(parent, 'children');
                children = children(strcmp(get(children, 'type'), 'uimenu'));
                inds = length(children) + 1;
                
            elseif strcmp(parentType, 'uimenu')
                % counts the number of sub-menus in the parent menu, and add
                % new position to the set of indices of parent menu
                children = get(parent, 'children');
                children = children(strcmp(get(children, 'type'), 'uimenu'));
                ind = length(children) + 1;
                data = get(parent, 'userdata');
                inds = [data.Inds ind];
                
            else
                error(['Can not manage parent of type ' parentType]);
            end
            
            menu = uimenu(parent, 'Label', label, varargin{:});
            data = struct('Inds', inds);
            set(menu, 'UserData', data);
            
        end

        function item = addMenuItem(menu, action, label, varargin)
            % Add a new menu item given as an "Action" instance

            % parse separator option
            separatorFlag = false;
            if ~isempty(varargin)
                var = varargin{1};
                if islogical(var)
                    separatorFlag = var;
                    varargin(1) = [];
                end
            end
            
            % Compute menu position as a set of recursive index positions
            children = get(menu, 'children');
            children = children(strcmp(get(children, 'type'), 'uimenu'));
            ind = length(children) + 1;
            data = get(menu, 'UserData');
            inds = [data.Inds ind];
            
            % create user data associated with obj menu
            data = struct('Action', action, 'Inds', inds);
            
            % creates new item
            item = uimenu(menu, 'Label', label, ...
                'UserData', data, ...
                'Callback', @(src, evt) action.run(frame));
            
            % eventually add separator above item
            if separatorFlag
                set(item, 'Separator', 'On');
            end
            
            if isActivable(action, frame)
                set(item, 'Enable', 'on');
            else
                set(item, 'Enable', 'off');
            end
            
            while length(varargin) > 1
                set(item, varargin{1}, varargin{2});
                varargin(1:2) = [];
            end
        end
        
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

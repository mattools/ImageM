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
        import imagem.actions.file.*;
        import imagem.actions.edit.*;
        import imagem.actions.image.*;
        import imagem.actions.view.*;
        import imagem.actions.process.*;
        import imagem.actions.process.binary.*;
        import imagem.actions.analyze.*;
        import imagem.gui.tools.*;
                
        % File Menu Definition
        
        fileMenu = addMenu(hf, 'Files');
        
        item = addMenuItem(fileMenu, CreateImage(), 'New...');
        set(item, 'Accelerator', 'N');
        
        item = addMenuItem(fileMenu, OpenImage(), 'Open...');
        set(item, 'Accelerator', 'O');


        demoMenu = addMenu(fileMenu, 'Open Demo');
        
        action = OpenDemoImage('cameraman.tif');
        addMenuItem(demoMenu, action, 'Cameraman (grayscale)');
        
        action = OpenDemoImage('rice.png');
        addMenuItem(demoMenu, action, 'Rice (grayscale)');
        
        action = OpenDemoImage('coins.png');
        addMenuItem(demoMenu, action, 'Coins (grayscale)');
        
        action = OpenDemoImage('peppers.png');
        addMenuItem(demoMenu, action, 'Peppers (RGB)');
        
        action = OpenDemoImage('circles.png');
        addMenuItem(demoMenu, action, 'Circles (binary)');
        
        action = OpenDemoImage('text.png');
        addMenuItem(demoMenu, action, 'Text (binary)');
        
        addMenuItem(fileMenu, ImportImageFromWorkspace(),   'Import From Workspace...');
        
        
        item = addMenuItem(fileMenu, SaveImage(), 'Save As...', true);
        set(item, 'Accelerator', 'S');

        addMenuItem(fileMenu, ExportImageToWorkspace(),     'Export To Workspace...');
        
        ImagemGUI.addMenuItem(fileMenu, ...
            SaveSelectionAction(frame), 'Save Selection...', true);

        item = addMenuItem(fileMenu, CloseFrame(), 'Close', true);
        set(item, 'Accelerator', 'W');

        item = addMenuItem(fileMenu, Exit(), 'Quit');
        set(item, 'Accelerator', 'Q');
        
        
        % Image Menu Definition
        
        imageMenu = addMenu(hf, 'Image');
        
        convertTypeMenu = addMenu(imageMenu,  'Convert Type');
        addMenuItem(convertTypeMenu, ImageConvertType('binary'),    'Binary');
        addMenuItem(convertTypeMenu, ImageConvertType('grayscale'), 'Grayscale');
        addMenuItem(convertTypeMenu, ImageConvertType('intensity'), 'Intensity');
        addMenuItem(convertTypeMenu, ImageConvertType('label'),     'Label');
        
        addMenuItem(imageMenu, FlipImage(1),                'Horizontal Flip', true);
        addMenuItem(imageMenu, FlipImage(2),                'Vertical Flip');
        addMenuItem(imageMenu, RotateImage90(1),            'Rotate Right');
        addMenuItem(imageMenu, RotateImage90(-1),           'Rotate Left');

        addMenuItem(imageMenu, SplitImageRGB(),             'Split RGB', true);
        addMenuItem(imageMenu, SplitImageChannels(),        'Split Channels');
        addMenuItem(imageMenu, MergeImageChannels(),        'Merge Channels...');

        item = addMenuItem(imageMenu, InvertImage(),        'Invert Image');
        set(item, 'Accelerator', 'I');
        
        addMenuItem(imageMenu, RenameImage(),               'Rename', true);
        item = addMenuItem(imageMenu, DuplicateImage(),     'Duplicate');
        set(item, 'Accelerator', 'D');
        ImagemGUI.addMenuItem(imageMenu, CropImageSelectionAction(frame), 	'Crop Selection');
        
        
        settingsMenu = addMenu(imageMenu, 'Settings', 'Separator', 'on');
        addMenuItem(settingsMenu, SetDefaultConnectivity(), 'Set Connectivity');
        addMenuItem(settingsMenu, SetBrushSize(),           'Set Brush Size');
        
        
        % View Menu Definition
        
        viewMenu = addMenu(hf, 'View');

        addMenuItem(viewMenu, ImageSetDisplayRange(),       'Set Display Range...');

        lutMenu = addMenu(viewMenu, 'Look-Up Table');
        addMenuItem(lutMenu, SetImageLut('gray'),           'Gray');
        addMenuItem(lutMenu, SetImageLut('inverted'),       'Inverted');
        addMenuItem(lutMenu, SetImageLut('blue-gray-red'),  'Blue-Gray-Red');
        
        addMenuItem(lutMenu, SetImageLut('jet'),            'Jet', true);
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
        mi1 = addMenuItem(zoomModesMenu, adjustZoomAction,  'Adjust');
        set(mi1, 'Checked', 'on');
        setMenuItem(adjustZoomAction, mi1);
        
        fixedZoomAction = SetZoomMode('fixed');
        mi2 = addMenuItem(zoomModesMenu, fixedZoomAction,   'Fixed');
        setMenuItem(fixedZoomAction, mi2);

        actionGroup = [adjustZoomAction fixedZoomAction];
        for iAction = 1:2
            action = actionGroup(iAction);
            setActionGroup(action, actionGroup);
        end
%         createCheckedMenuGroup([mi1 mi2], mi1);
        
        addMenuItem(viewMenu, PrintImageDocList(),  'Print Image List', true);
        
        
        % Process Menu Definition
        
        processMenu = addMenu(hf, 'Process');
        
        addMenuItem(processMenu, AdjustImageDynamic(),      'Adjust Dynamic');
        addMenuItem(processMenu, ImageLabelToRgb(),         'Label To RGB...');

%         ImagemGUI.addMenuItem(processMenu, ImageMeanFilter3x3Action(viewer),    'Mean', true);
        addMenuItem(processMenu, ImageBoxMeanFilter(),      'Box Mean Filter...', true);
        addMenuItem(processMenu, ImageMedianFilter(),       'Median Filter...');
        addMenuItem(processMenu, ImageGaussianFilter(),     'Gaussian Filter...');
                
        morphoMenu = addMenu(processMenu, 'Morphology');
        addMenuItem(morphoMenu, ImageErosion(),     'Erosion 3x3');
        addMenuItem(morphoMenu, ImageDilation(),    'Dilation 3x3');
        addMenuItem(morphoMenu, ImageOpening(),     'Opening 3x3');
        addMenuItem(morphoMenu, ImageClosing(),     'Closing 3x3');
        addMenuItem(morphoMenu, ImageMorphologicalFilter(), 'Morphological Filter...', true);    
        
        item = addMenuItem(processMenu, ImageThreshold(),   'Threshold...', true);
        set(item, 'Accelerator', 'T');
        addMenuItem(processMenu, ImageAutoThresholdOtsu(),  'Auto Threshold (Otsu)');
        item = addMenuItem(processMenu, ImageGradient(),    'Gradient', true);
        set(item, 'Accelerator', 'G');
        addMenuItem(processMenu, ImageMorphoGradient(),     'Morphological Gradient');
        addMenuItem(processMenu, ImageGradientVector(),     'Gradient Vector');
        addMenuItem(processMenu, VectorImageNorm(),         'Norm');

        minimaMenu = addMenu(processMenu, 'Minima / Maxima', 'Separator', 'on');
        addMenuItem(minimaMenu, ImageRegionalMinima(),      'Regional Minima');
        addMenuItem(minimaMenu, ImageRegionalMaxima(),      'Regional Maxima');
        addMenuItem(minimaMenu, ImageExtendedMinima(),      'Extended Minima...');
        addMenuItem(minimaMenu, ImageExtendedMaxima(),      'Extended Maxima...');
        addMenuItem(minimaMenu, ImageImposeMinima(),        'Impose Minima...');
        
        addMenuItem(processMenu, ImageWatershed(),          'Watershed...');
        addMenuItem(processMenu, ImageExtendedMinWatershed(),   'Extended Min Watershed...');
        
        addMenuItem(processMenu, ImageArithmetic(),         'Image Arithmetic...', true);
        addMenuItem(processMenu, ImageValuesTransform(),    'Image Maths 1...');
        addMenuItem(processMenu, ImageMathematic(),         'Image Maths 2...');
        
        binaryMenu = addMenu(processMenu, 'Binary / Labels', 'Separator', 'on');
        addMenuItem(binaryMenu, KillImageBorders(),         'Kill Borders');
        addMenuItem(binaryMenu, ImageAreaOpening(),         'Area Opening');
        addMenuItem(binaryMenu, KeepLargestRegion(),        'Keep Largest Region');
        addMenuItem(binaryMenu, FillImageHoles(),           'Fill Holes');

        addMenuItem(binaryMenu, ApplyImageFunction('distanceMap'), 'Distance Map');

        addMenuItem(binaryMenu, ImageSkeleton(),            'Skeleton');
        addMenuItem(binaryMenu, ConnectedComponentsLabeling(),  'Connected Components Labeling');
        
        addMenuItem(binaryMenu, ImageBooleanOp(),           'Boolean Operation...', true);
        addMenuItem(binaryMenu, BinaryImageOverlay(),       'Image Overlay');
        
        % Interactive tools
        
        toolsMenu = addMenu(hf, 'Tools');
        
        tool = PrintCurrentPointTool(frame);
        ImagemGUI.addMenuItem(toolsMenu, SelectToolAction(frame, tool), ...
            'Print Current Point');

        tool = ScrollImagePositionTool(frame);
        ImagemGUI.addMenuItem(toolsMenu, SelectToolAction(frame, tool), ...
            'Scroll Image');
        
        
        ImagemGUI.addMenuItem(toolsMenu, ...
            SelectToolAction(frame, SelectRectangleTool(frame)), ...
            'Select Rectangle', true);

        ImagemGUI.addMenuItem(toolsMenu, ...
            SelectToolAction(frame, SelectPolylineTool(frame)), ...
            'Select Polyline');

        ImagemGUI.addMenuItem(toolsMenu, ...
            SelectToolAction(frame, SelectPointsTool(frame)), ...
            'Select Points');

        ImagemGUI.addMenuItem(toolsMenu, ...
            SelectToolAction(frame, SelectLineSegmentTool(frame)), ...
            'Select Line Segment');


        ImagemGUI.addMenuItem(toolsMenu, ...
            SelectToolAction(frame, SetPixelToWhiteTool(frame)), ...
            'Set Pixel to White', true);
        
        ImagemGUI.addMenuItem(toolsMenu, ...
            SelectToolAction(frame, BrushTool(frame)), ...
            'Brush');
        
        ImagemGUI.addMenuItem(toolsMenu, ...
            PlotLabelMapCurvesFromTable(frame), ...
            'Plot Curves From Labels...');
        
        
        % Analyze Menu Definition
        
        analyzeMenu = addMenu(hf, 'Analyze');
        
        ImagemGUI.addMenuItem(analyzeMenu, ...
            SetImageScaleAction(frame), 'Set Image Scale');

        ImagemGUI.addMenuItem(analyzeMenu, ...
            ImageAnalyzeParticlesAction(frame), 'Analyze Particles');
        item = ImagemGUI.addMenuItem(analyzeMenu, ...
            ShowImageHistogramAction(frame), 'Histogram');
        set(item, 'Accelerator', 'H');

        item = ImagemGUI.addMenuItem(analyzeMenu, ...
            ImageSelectionLineProfileAction(frame), ...
            'Plot Line Profile');
        set(item, 'Accelerator', 'K');
        
        
        % Help menu definition
        helpMenu = addMenu(hf, 'Help');
        
        ImagemGUI.addMenuItem(helpMenu, ...
            GenericAction(frame, 'printHistory', ...
            @(src, evt) frame.Gui.App.printHistory), ...
            'Print History');
        
        
%         % check which menu items are selected or not
%         ImagemGUI.updateMenuEnable(fileMenu);
%         ImagemGUI.updateMenuEnable(imageMenu);
%         ImagemGUI.updateMenuEnable(viewMenu);
%         ImagemGUI.updateMenuEnable(processMenu);
%         ImagemGUI.updateMenuEnable(toolsMenu);
%         ImagemGUI.updateMenuEnable(analyzeMenu);
        
%         function createCheckedMenuGroup(itemList, initialMenu)
%             disp('init check boxes');
%             set(itemList, 'Checked', 'off');
%             set(initialMenu, 'Checked', 'on');
%             
%             disp('init action listeners');
%             manager = imagem.gui.MenuItemGroup(itemList);
%             for i = 1:length(itemList)
%                 item = itemList(i);
%                 cb = get(item, 'Callback');
%                 set(item, 'Callback', {cb @manager.actionPerformed});
%             end
%             
%             disp('check box ground initialized');
%         end

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
            if ~isempty(varargin)
                var = varargin{1};
                if islogical(var)
                    set(item, 'Separator', 'On');
                end
            end
        end
        
    end
    

end

methods (Static)
        
    function item = addMenuItem(menu, action, label, varargin)
        
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
            'Callback', @action.actionPerformed);        
        
        % eventually add separator above item
        if ~isempty(varargin)
            var = varargin{1};
            if islogical(var)
                set(item, 'Separator', 'On');
            end
        end
    end
    
    
%     function addMenuAccelerator(hFig, menuItem, accelerator)
%         
%         % find menu bar
%         jFrame = get(handle(hFig),'JavaFrame');
%         try
%             % R2008a and later
%             jMenuBar = jFrame.fHG1Client.getMenuBar;
%         catch %#ok<CTCH>
%             % R2007b and earlier
%             jMenuBar = jFrame.fFigureClient.getMenuBar;
%         end
%         
%         % get set of recursice indices to access menu item
%         data = get(menuItem, 'userdata');
%         inds = data.inds;
% 
%         % find the java menu corresponding to current item
%         jMenu = jMenuBar.getComponent(inds(1)-1);
%         for i = 2:length(inds)
%             jMenu = jMenu.getMenuComponent(inds(i)-1);
%         end
%         
%         % setup accelerator
%         jAccelerator = javax.swing.KeyStroke.getKeyStroke(accelerator);
%         jMenu.setAccelerator(jAccelerator);
%         
%     end
    
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

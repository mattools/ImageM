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
        import imagem.actions.image.*;
        import imagem.gui.tools.*;
                
        % File Menu Definition
        
        fileMenu = ImagemGUI.addMenu(hf, 'Files');
        
        item = addMenuItem(fileMenu, CreateImage(), 'New...');
        set(item, 'Accelerator', 'N');
        
        item = addMenuItem(fileMenu, OpenImage(), 'Open...');
        set(item, 'Accelerator', 'O');


        demoMenu = ImagemGUI.addMenu(fileMenu, 'Open Demo');
        
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
        
        addMenuItem(fileMenu, ImportImageFromWorkspace(), 'Import From Workspace...');
        
        
        item = addMenuItem(fileMenu, SaveImage(), 'Save As...', true);
        set(item, 'Accelerator', 'S');

        addMenuItem(fileMenu, ExportImageToWorkspace(), 'Export To Workspace...');
        
        ImagemGUI.addMenuItem(fileMenu, ...
            SaveSelectionAction(frame), 'Save Selection...', true);

        item = addMenuItem(fileMenu, CloseFrame(), 'Close', true);
        set(item, 'Accelerator', 'W');

        item = addMenuItem(fileMenu, Exit(), 'Quit');
        set(item, 'Accelerator', 'Q');
        
        
        % Image Menu Definition
        
        imageMenu = ImagemGUI.addMenu(hf, 'Image');
        
        convertTypeMenu = ImagemGUI.addMenu(imageMenu,  'Convert Type');
        addMenuItem(convertTypeMenu, ImageConvertType('binary'),    'Binary');
        addMenuItem(convertTypeMenu, ImageConvertType('grayscale'), 'Grayscale');
        addMenuItem(convertTypeMenu, ImageConvertType('intensity'), 'Intensity');
        addMenuItem(convertTypeMenu, ImageConvertType('label'),     'Label');
        
        addMenuItem(imageMenu, FlipImage(1),        'Horizontal Flip', true);
        addMenuItem(imageMenu, FlipImage(2),        'Vertical Flip');
        addMenuItem(imageMenu, RotateImage90(1),    'Rotate Right');
        addMenuItem(imageMenu, RotateImage90(-1),   'Rotate Left');

        addMenuItem(imageMenu, SplitImageRGB(),         'Split RGB', true);
        addMenuItem(imageMenu, SplitImageChannels(),    'Split Channels');
        addMenuItem(imageMenu, MergeImageChannels(),    'Merge Channels...');

        item = addMenuItem(imageMenu, InvertImage(),    'Invert Image');
        set(item, 'Accelerator', 'I');
        
        addMenuItem(imageMenu, RenameImage(),           'Rename', true);
        item = addMenuItem(imageMenu, DuplicateImage(), 'Duplicate');
        set(item, 'Accelerator', 'D');
        ImagemGUI.addMenuItem(imageMenu, CropImageSelectionAction(frame), 	'Crop Selection');
        
        
        settingsMenu = ImagemGUI.addMenu(imageMenu, 'Settings', 'Separator', 'on');
        addMenuItem(settingsMenu, SetDefaultConnectivity(), 'Set Connectivity');
        addMenuItem(settingsMenu, SetBrushSize(),       'Set Brush Size');
        
        
        % View Menu Definition
        
        viewMenu = ImagemGUI.addMenu(hf, 'View');

        ImagemGUI.addMenuItem(viewMenu, ImageSetDisplayRangeAction(frame), 'Set Display Range...');

        lutMenu = ImagemGUI.addMenu(viewMenu, 'Look-Up Table');
        ImagemGUI.addMenuItem(lutMenu, ChangeImageLutAction(frame, 'gray'), 'Gray');
        ImagemGUI.addMenuItem(lutMenu, ChangeImageLutAction(frame, 'inverted'), 'Inverted');
        ImagemGUI.addMenuItem(lutMenu, ChangeImageLutAction(frame, 'blue-gray-red'), 'Blue-Gray-Red');
        
        ImagemGUI.addMenuItem(lutMenu , ChangeImageLutAction(frame, 'jet'), 'Jet', true);
        ImagemGUI.addMenuItem(lutMenu , ChangeImageLutAction(frame, 'hsv'), 'HSV');
        ImagemGUI.addMenuItem(lutMenu , ChangeImageLutAction(frame, 'colorcube'), 'Color Cube');
        ImagemGUI.addMenuItem(lutMenu , ChangeImageLutAction(frame, 'prism'), 'Prism');
        
        matlabLutMenu = ImagemGUI.addMenu(lutMenu, 'Matlab''s');
        ImagemGUI.addMenuItem(matlabLutMenu, ChangeImageLutAction(frame, 'hot'), 'Hot');
        ImagemGUI.addMenuItem(matlabLutMenu, ChangeImageLutAction(frame, 'cool'), 'Cool');
        ImagemGUI.addMenuItem(matlabLutMenu, ChangeImageLutAction(frame, 'spring'), 'Spring');
        ImagemGUI.addMenuItem(matlabLutMenu, ChangeImageLutAction(frame, 'summer'), 'Summer');
        ImagemGUI.addMenuItem(matlabLutMenu, ChangeImageLutAction(frame, 'winter'), 'Winter');
        ImagemGUI.addMenuItem(matlabLutMenu, ChangeImageLutAction(frame, 'autumn'), 'Autumn');
        ImagemGUI.addMenuItem(matlabLutMenu, ChangeImageLutAction(frame, 'copper'), 'Copper');
        ImagemGUI.addMenuItem(matlabLutMenu, ChangeImageLutAction(frame, 'bone'), 'Bone');
        ImagemGUI.addMenuItem(matlabLutMenu, ChangeImageLutAction(frame, 'pink'), 'Pink');
        ImagemGUI.addMenuItem(matlabLutMenu, ChangeImageLutAction(frame, 'lines'), 'Lines');
        
        colorLutMenu = ImagemGUI.addMenu(lutMenu, 'Simple Colors');
        ImagemGUI.addMenuItem(colorLutMenu, ChangeImageLutAction(frame, 'blue'), 'Blue');
        ImagemGUI.addMenuItem(colorLutMenu, ChangeImageLutAction(frame, 'red'), 'Red');
        ImagemGUI.addMenuItem(colorLutMenu, ChangeImageLutAction(frame, 'green'), 'Green');
        ImagemGUI.addMenuItem(colorLutMenu, ChangeImageLutAction(frame, 'cyan'), 'Cyan');
        ImagemGUI.addMenuItem(colorLutMenu, ChangeImageLutAction(frame, 'yellow'), 'Yellow');
        ImagemGUI.addMenuItem(colorLutMenu, ChangeImageLutAction(frame, 'magenta'), 'Magenta');

        
        ImagemGUI.addMenuItem(viewMenu, ...
            ZoomInAction(frame), 'Zoom In', true);
        ImagemGUI.addMenuItem(viewMenu, ...
            ZoomOutAction(frame), 'Zoom Out');
        ImagemGUI.addMenuItem(viewMenu, ...
            ZoomOneAction(frame), 'Zoom 1:1');

        ImagemGUI.addMenuItem(viewMenu, ZoomBestAction(frame), 'Zoom Best');
        
        zoomsMenu = ImagemGUI.addMenu(viewMenu, 'Others');
        ImagemGUI.addMenuItem(zoomsMenu, ZoomChangeAction(frame, 8), 'Zoom 8:1');
        ImagemGUI.addMenuItem(zoomsMenu, ZoomChangeAction(frame, 4), 'Zoom 4:1');
        ImagemGUI.addMenuItem(zoomsMenu, ZoomChangeAction(frame, 2), 'Zoom 2:1');
        ImagemGUI.addMenuItem(zoomsMenu, ZoomChangeAction(frame, 1), 'Zoom 1:1');
        ImagemGUI.addMenuItem(zoomsMenu, ZoomChangeAction(frame, 1/2), 'Zoom 1:2');
        ImagemGUI.addMenuItem(zoomsMenu, ZoomChangeAction(frame, 1/4), 'Zoom 1:4');
        ImagemGUI.addMenuItem(zoomsMenu, ZoomChangeAction(frame, 1/8), 'Zoom 1:8');

        zoomModesMenu = ImagemGUI.addMenu(viewMenu, 'Zoom Mode');
        adjustZoomAction = ZoomSetModeAction(frame, 'adjust');
        mi1 = ImagemGUI.addMenuItem(zoomModesMenu, adjustZoomAction, 'Adjust');
        set(mi1, 'Checked', 'on');
        setMenuItem(adjustZoomAction, mi1);
        
        fixedZoomAction = ZoomSetModeAction(frame, 'fixed');
        mi2 = ImagemGUI.addMenuItem(zoomModesMenu, fixedZoomAction, 'Fixed');
        setMenuItem(fixedZoomAction, mi2);

        actionGroup = [adjustZoomAction fixedZoomAction];
        for iAction = 1:2
            action = actionGroup(iAction);
            setActionGroup(action, actionGroup);
        end
%         createCheckedMenuGroup([mi1 mi2], mi1);
        
        ImagemGUI.addMenuItem(viewMenu, ...
            PrintImageDocListAction(frame), 'Print Image List', true);
        
        
        % Process Menu Definition
        
        processMenu = ImagemGUI.addMenu(hf, 'Process');
        
        ImagemGUI.addMenuItem(processMenu, ImageAdjustDynamicAction(frame),    'Adjust Dynamic');
        ImagemGUI.addMenuItem(processMenu, ImageLabelToRgbAction(frame),       'Label To RGB...');

%         ImagemGUI.addMenuItem(processMenu, ImageMeanFilter3x3Action(viewer),    'Mean', true);
        ImagemGUI.addMenuItem(processMenu, ImageBoxMeanFilterAction(frame),    'Box Mean Filter...', true);
        ImagemGUI.addMenuItem(processMenu, ImageMedianFilterAction(frame),     'Median Filter...');
        ImagemGUI.addMenuItem(processMenu, ImageGaussianFilterAction(frame),     'Gaussian Filter...');
                
        morphoMenu = ImagemGUI.addMenu(processMenu, 'Morphology');
        ImagemGUI.addMenuItem(morphoMenu, ImageErosionAction(frame),     'Erosion 3x3');
        ImagemGUI.addMenuItem(morphoMenu, ImageDilationAction(frame),    'Dilation 3x3');
        ImagemGUI.addMenuItem(morphoMenu, ImageOpeningAction(frame),     'Opening 3x3');
        ImagemGUI.addMenuItem(morphoMenu, ImageClosingAction(frame),     'Closing 3x3');    
        ImagemGUI.addMenuItem(morphoMenu, ImageMorphologicalFilterAction(frame), ...
            'Morphological Filter...', true);    
        
        item = ImagemGUI.addMenuItem(processMenu, ImageThresholdAction(frame),  ...
            'Threshold...', true);
        set(item, 'Accelerator', 'T');
        ImagemGUI.addMenuItem(processMenu, ImageAutoThresholdOtsuAction(frame),  'Auto Threshold (Otsu)');
        item = ImagemGUI.addMenuItem(processMenu, ImageGradientAction(frame),   'Gradient', true);
        set(item, 'Accelerator', 'G');
        ImagemGUI.addMenuItem(processMenu, ImageMorphoGradientAction(frame), ...
            'Morphological Gradient');
        ImagemGUI.addMenuItem(processMenu, ImageGradientVectorAction(frame),   'Gradient Vector');
        ImagemGUI.addMenuItem(processMenu, ImageNormAction(frame),       'Norm');

        minimaMenu = ImagemGUI.addMenu(processMenu, 'Minima / Maxima', 'Separator', 'on');
        ImagemGUI.addMenuItem(minimaMenu, ImageRegionalMinimaAction(frame), 'Regional Minima');
        ImagemGUI.addMenuItem(minimaMenu, ImageRegionalMaximaAction(frame), 'Regional Maxima');
        ImagemGUI.addMenuItem(minimaMenu, ImageExtendedMinimaAction(frame), 'Extended Minima...');
        ImagemGUI.addMenuItem(minimaMenu, ImageExtendedMaximaAction(frame), 'Extended Maxima...');
        ImagemGUI.addMenuItem(minimaMenu, ImageImposeMinimaAction(frame),   'Impose Minima...');
        
        ImagemGUI.addMenuItem(processMenu, ImageWatershedAction(frame),      'Watershed...');
        ImagemGUI.addMenuItem(processMenu, ImageExtendedMinWatershedAction(frame), ...
            'Extended Min Watershed...');
        
        ImagemGUI.addMenuItem(processMenu, ImageArithmeticAction(frame), ...
            'Image Arithmetic...', true);
        ImagemGUI.addMenuItem(processMenu, ImageValuesTransformAction(frame), ...
            'Image Maths 1...');
        ImagemGUI.addMenuItem(processMenu, ImageMathematicAction(frame), ...
            'Image Maths 2...');
        
        binaryMenu = ImagemGUI.addMenu(processMenu, 'Binary / Labels', 'Separator', 'on');
        ImagemGUI.addMenuItem(binaryMenu, KillImageBordersAction(frame), ...
            'Kill Borders');
        ImagemGUI.addMenuItem(binaryMenu, ImageAreaOpeningAction(frame), ...
            'Area Opening');
        ImagemGUI.addMenuItem(binaryMenu, KeepLargestRegionAction(frame), ...
            'Keep Largest Region');
        ImagemGUI.addMenuItem(binaryMenu, FillImageHolesAction(frame), ...
            'Fill Holes');

        ImagemGUI.addMenuItem(binaryMenu, ...
            ApplyImageFunctionAction(frame, 'distanceMap'), ...
            'Distance Map');

        ImagemGUI.addMenuItem(binaryMenu, ImageSkeletonAction(frame), ...
            'Skeleton');
        ImagemGUI.addMenuItem(binaryMenu, LabelBinaryImageAction(frame), ...
            'Connected Components Labeling');
        
        ImagemGUI.addMenuItem(binaryMenu, ImageBooleanOpAction(frame), ...
            'Image Arithmetic...', true);
        ImagemGUI.addMenuItem(binaryMenu, ImageOverlayAction(frame), ...
            'Image Overlay');
        
        % Interactive tools
        
        toolsMenu = ImagemGUI.addMenu(hf, 'Tools');
        
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
        
        analyzeMenu = ImagemGUI.addMenu(hf, 'Analyze');
        
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
        helpMenu = ImagemGUI.addMenu(hf, 'Help');
        
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

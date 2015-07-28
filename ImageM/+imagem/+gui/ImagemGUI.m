classdef ImagemGUI < handle
%IMAGEMGUI GUI manager for the ImageM application
%
%   output = ImagemGUI(input)
%
%   Example
%   ImagemGUI
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-03-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

%% Properties
properties
    % application
    app;
    
end 

%% Constructor
methods
    function this = ImagemGUI(appli, varargin)
        % IMAGEM constructor
        %
        % IM = ImageM(APP)
        % where APP is an instance of ImagemApp
        %
        
        this.app = appli;
        
    end % constructor 

end % construction function


%% General methods
methods
    function [doc, viewer] = addImageDocument(this, image, newName, refTag)
        % Create a new document from image, add it to app, and display img
        
        if isempty(image)
            % in case of empty image, create an "empty view"
            doc = [];
            viewer = imagem.gui.PlanarImageViewer(this, doc);
            return;
        end
        
        if nargin < 3 || isempty(newName)
            % find a 'free' name for image
            newName = createDocumentName(this.app, image.name);
        end
        image.name = newName;
        
        % creates new instance of ImageDoc
        doc = imagem.app.ImagemDoc(image);
        
        % setup document tag
        if nargin < 4
            tag = createImageTag(this.app, image);
        else
            tag = createImageTag(this.app, image, refTag);
        end
        doc.tag = tag;
        
        % display settings
        if ~isempty(image)
            if isLabelImage(image)
                doc.lut = 'jet';
            end
        end
        
        % add ImageDoc to the application
        addDocument(this.app, doc);
        
        % creates a display for the new image
        viewer = imagem.gui.PlanarImageViewer(this, doc);
        addView(doc, viewer);
    end
    
    function addToHistory(this, string)
        % Add the specified string to gui history
        
        warning('ImageM:ImagemGUI:deprecated', ...
            'deprecated, should add to app history directly');
        addToHistory(this.app, string);
        fprintf(string);
    end
    
    function exit(this)
        % EXIT Close all viewers
        
        docList = getDocuments(this.app);
        for d = 1:length(docList)
            doc = docList{d};
%             disp(['closing doc: ' doc.image.name]);
            
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
    function createFigureMenu(this, hf, viewer) %#ok<INUSL>
        
        import imagem.gui.ImagemGUI;
        import imagem.gui.actions.*;
        import imagem.gui.tools.*;
                
        % File Menu Definition
        
        fileMenu = ImagemGUI.addMenu(hf, 'Files');
        
        item = ImagemGUI.addMenuItem(fileMenu, CreateImageAction(viewer), 'New...');
        set(item, 'Accelerator', 'N');
        
        item = ImagemGUI.addMenuItem(fileMenu, ...
            OpenImageAction(viewer), 'Open...');
        set(item, 'Accelerator', 'O');


        demoMenu = ImagemGUI.addMenu(fileMenu, 'Open Demo');
        
        action = OpenDemoImageAction(viewer, 'openDemoCameraman', 'cameraman.tif');
        ImagemGUI.addMenuItem(demoMenu, action, 'Cameraman (grayscale)');
        
        action = OpenDemoImageAction(viewer, 'openDemoRice', 'rice.png');
        ImagemGUI.addMenuItem(demoMenu, action, 'Rice (grayscale)');
        
        action = OpenDemoImageAction(viewer, 'openDemoCoins', 'coins.png');
        ImagemGUI.addMenuItem(demoMenu, action, 'Coins (grayscale)');
        
        action = OpenDemoImageAction(viewer, 'openDemoPeppers', 'peppers.png');
        ImagemGUI.addMenuItem(demoMenu, action, 'Peppers (RGB)');
        
        action = OpenDemoImageAction(viewer, 'openDemoCircles', 'circles.png');
        ImagemGUI.addMenuItem(demoMenu, action, 'Circles (binary)');
        
        action = OpenDemoImageAction(viewer, 'openDemoText', 'text.png');
        ImagemGUI.addMenuItem(demoMenu, action, 'Text (binary)');
        
        ImagemGUI.addMenuItem(fileMenu, ImportImageFromWorkspaceAction(viewer), 'Import From Workspace...');
        
        
        item = ImagemGUI.addMenuItem(fileMenu, ...
            SaveImageAction(viewer), 'Save As...', true);
        set(item, 'Accelerator', 'S');

        ImagemGUI.addMenuItem(fileMenu, ExportImageToWorkspaceAction(viewer), 'Export To Workspace...');
        
        ImagemGUI.addMenuItem(fileMenu, ...
            SaveSelectionAction(viewer), 'Save Selection...', true);

        item = ImagemGUI.addMenuItem(fileMenu, ...
            CloseImageAction(viewer), 'Close', true);
        set(item, 'Accelerator', 'W');

        item = ImagemGUI.addMenuItem(fileMenu, ExitAction(viewer), 'Quit');
        set(item, 'Accelerator', 'Q');
        
        
        % Image Menu Definition
        
        imageMenu = ImagemGUI.addMenu(hf, 'Image');
        
        
        ImagemGUI.addMenuItem(imageMenu, FlipImageAction(viewer, 1),  'Horizontal Flip');
        ImagemGUI.addMenuItem(imageMenu, FlipImageAction(viewer, 2),  'Vertical Flip');
        ImagemGUI.addMenuItem(imageMenu, RotateImage90Action(viewer, 1),  'Rotate Right');
        ImagemGUI.addMenuItem(imageMenu, RotateImage90Action(viewer, -1),  'Rotate Left');

        ImagemGUI.addMenuItem(imageMenu, SplitImageRGBAction(viewer),       'Split RGB', true);
        ImagemGUI.addMenuItem(imageMenu, SplitImageChannelsAction(viewer),  'Split Channels');
        item = ImagemGUI.addMenuItem(imageMenu, ...
            InvertImageAction(viewer), 'Invert Image');
        set(item, 'Accelerator', 'I');
        
        ImagemGUI.addMenuItem(imageMenu, RenameImageAction(viewer),         'Rename', true);
        item = ImagemGUI.addMenuItem(imageMenu, DuplicateImageAction(viewer),      'Duplicate');
        set(item, 'Accelerator', 'D');
        ImagemGUI.addMenuItem(imageMenu, CropImageSelectionAction(viewer), 	'Crop Selection');
        
        
        settingsMenu = ImagemGUI.addMenu(imageMenu, 'Settings', 'Separator', 'on');
        ImagemGUI.addMenuItem(settingsMenu, ...
            SetDefaultConnectivityAction(viewer), 'Set Connectivity');
        ImagemGUI.addMenuItem(settingsMenu, ...
            SetBrushSizeAction(viewer), 'Set Brush Size');
        
        
        % View Menu Definition
        
        viewMenu = ImagemGUI.addMenu(hf, 'View');
        
        lutMenu = ImagemGUI.addMenu(viewMenu, 'LUT');
        ImagemGUI.addMenuItem(lutMenu, ChangeImageLutAction(viewer, 'gray'), 'Gray');
        ImagemGUI.addMenuItem(lutMenu, ChangeImageLutAction(viewer, 'inverted'), 'Inverted');
        ImagemGUI.addMenuItem(lutMenu, ChangeImageLutAction(viewer, 'blue-gray-red'), 'Blue-Gray-Red');
        
        ImagemGUI.addMenuItem(lutMenu , ChangeImageLutAction(viewer, 'jet'), 'Jet', true);
        ImagemGUI.addMenuItem(lutMenu , ChangeImageLutAction(viewer, 'hsv'), 'HSV');
        ImagemGUI.addMenuItem(lutMenu , ChangeImageLutAction(viewer, 'colorcube'), 'Color Cube');
        ImagemGUI.addMenuItem(lutMenu , ChangeImageLutAction(viewer, 'prism'), 'Prism');
        
        matlabLutMenu = ImagemGUI.addMenu(lutMenu, 'Matlab''s');
        ImagemGUI.addMenuItem(matlabLutMenu, ChangeImageLutAction(viewer, 'hot'), 'Hot');
        ImagemGUI.addMenuItem(matlabLutMenu, ChangeImageLutAction(viewer, 'cool'), 'Cool');
        ImagemGUI.addMenuItem(matlabLutMenu, ChangeImageLutAction(viewer, 'spring'), 'Spring');
        ImagemGUI.addMenuItem(matlabLutMenu, ChangeImageLutAction(viewer, 'summer'), 'Summer');
        ImagemGUI.addMenuItem(matlabLutMenu, ChangeImageLutAction(viewer, 'winter'), 'Winter');
        ImagemGUI.addMenuItem(matlabLutMenu, ChangeImageLutAction(viewer, 'autumn'), 'Autumn');
        ImagemGUI.addMenuItem(matlabLutMenu, ChangeImageLutAction(viewer, 'copper'), 'Copper');
        ImagemGUI.addMenuItem(matlabLutMenu, ChangeImageLutAction(viewer, 'bone'), 'Bone');
        ImagemGUI.addMenuItem(matlabLutMenu, ChangeImageLutAction(viewer, 'pink'), 'Pink');
        ImagemGUI.addMenuItem(matlabLutMenu, ChangeImageLutAction(viewer, 'lines'), 'Lines');
        
        colorLutMenu = ImagemGUI.addMenu(lutMenu, 'Simple Colors');
        ImagemGUI.addMenuItem(colorLutMenu, ChangeImageLutAction(viewer, 'blue'), 'Blue');
        ImagemGUI.addMenuItem(colorLutMenu, ChangeImageLutAction(viewer, 'red'), 'Red');
        ImagemGUI.addMenuItem(colorLutMenu, ChangeImageLutAction(viewer, 'green'), 'Green');
        ImagemGUI.addMenuItem(colorLutMenu, ChangeImageLutAction(viewer, 'cyan'), 'Cyan');
        ImagemGUI.addMenuItem(colorLutMenu, ChangeImageLutAction(viewer, 'yellow'), 'Yellow');
        ImagemGUI.addMenuItem(colorLutMenu, ChangeImageLutAction(viewer, 'magenta'), 'Magenta');

        
        ImagemGUI.addMenuItem(viewMenu, ...
            ZoomInAction(viewer), 'Zoom In', true);
        ImagemGUI.addMenuItem(viewMenu, ...
            ZoomOutAction(viewer), 'Zoom Out');
        ImagemGUI.addMenuItem(viewMenu, ...
            ZoomOneAction(viewer), 'Zoom 1:1');

        ImagemGUI.addMenuItem(viewMenu, ZoomBestAction(viewer), 'Zoom Best');
        
        zoomsMenu = ImagemGUI.addMenu(viewMenu, 'Others');
        ImagemGUI.addMenuItem(zoomsMenu, ZoomChangeAction(viewer, 8), 'Zoom 8:1');
        ImagemGUI.addMenuItem(zoomsMenu, ZoomChangeAction(viewer, 4), 'Zoom 4:1');
        ImagemGUI.addMenuItem(zoomsMenu, ZoomChangeAction(viewer, 2), 'Zoom 2:1');
        ImagemGUI.addMenuItem(zoomsMenu, ZoomChangeAction(viewer, 1), 'Zoom 1:1');
        ImagemGUI.addMenuItem(zoomsMenu, ZoomChangeAction(viewer, 1/2), 'Zoom 1:2');
        ImagemGUI.addMenuItem(zoomsMenu, ZoomChangeAction(viewer, 1/4), 'Zoom 1:4');
        ImagemGUI.addMenuItem(zoomsMenu, ZoomChangeAction(viewer, 1/8), 'Zoom 1:8');

        zoomModesMenu = ImagemGUI.addMenu(viewMenu, 'Zoom Mode');
        adjustZoomAction = ZoomSetModeAction(viewer, 'adjust');
        mi1 = ImagemGUI.addMenuItem(zoomModesMenu, adjustZoomAction, 'Adjust');
        set(mi1, 'Checked', 'on');
        setMenuItem(adjustZoomAction, mi1);
        
        fixedZoomAction = ZoomSetModeAction(viewer, 'fixed');
        mi2 = ImagemGUI.addMenuItem(zoomModesMenu, fixedZoomAction, 'Fixed');
        setMenuItem(fixedZoomAction, mi2);

        actionGroup = [adjustZoomAction fixedZoomAction];
        for iAction = 1:2
            action = actionGroup(iAction);
            setActionGroup(action, actionGroup);
        end
%         createCheckedMenuGroup([mi1 mi2], mi1);
        
        ImagemGUI.addMenuItem(viewMenu, ...
            PrintImageDocListAction(viewer), 'Print Image List', true);
        
        
        % Process Menu Definition
        
        processMenu = ImagemGUI.addMenu(hf, 'Process');
        
        ImagemGUI.addMenuItem(processMenu, ImageAdjustDynamicAction(viewer),    'Adjust Dynamic');
        ImagemGUI.addMenuItem(processMenu, ImageLabelToRgbAction(viewer),       'Label To RGB...');

        ImagemGUI.addMenuItem(processMenu, ImageMeanFilter3x3Action(viewer),    'Mean', true);
        ImagemGUI.addMenuItem(processMenu, ImageMedianFilterAction(viewer),     'Median');
                
        morphoMenu = ImagemGUI.addMenu(processMenu, 'Morphology');
        ImagemGUI.addMenuItem(morphoMenu, ImageErosionAction(viewer),     'Erosion');
        ImagemGUI.addMenuItem(morphoMenu, ImageDilationAction(viewer),    'Dilation');
        ImagemGUI.addMenuItem(morphoMenu, ImageOpeningAction(viewer),     'Opening');
        ImagemGUI.addMenuItem(morphoMenu, ImageClosingAction(viewer),     'Closing');    
        ImagemGUI.addMenuItem(morphoMenu, ImageMorphologicalFilterAction(viewer), ...
            'Morphological Filter', true);    
        
        item = ImagemGUI.addMenuItem(processMenu, ImageThresholdAction(viewer),  ...
            'Threshold...', true);
        set(item, 'Accelerator', 'T');
        ImagemGUI.addMenuItem(processMenu, ImageAutoThresholdOtsuAction(viewer),  'Threshold (Otsu)');
        item = ImagemGUI.addMenuItem(processMenu, ImageGradientAction(viewer),   'Gradient', true);
        set(item, 'Accelerator', 'G');
        ImagemGUI.addMenuItem(processMenu, ImageMorphoGradientAction(viewer), ...
            'Morphological Gradient');
        ImagemGUI.addMenuItem(processMenu, ImageGradientVectorAction(viewer),   'Gradient Vector');
        ImagemGUI.addMenuItem(processMenu, ImageNormAction(viewer),       'Norm');

        minimaMenu = ImagemGUI.addMenu(processMenu, 'Minima / Maxima', 'Separator', 'on');
        ImagemGUI.addMenuItem(minimaMenu, ImageRegionalMinimaAction(viewer), 'Regional Minima');
        ImagemGUI.addMenuItem(minimaMenu, ImageRegionalMaximaAction(viewer), 'Regional Maxima');
        ImagemGUI.addMenuItem(minimaMenu, ImageExtendedMinimaAction(viewer), 'Extended Minima...');
        ImagemGUI.addMenuItem(minimaMenu, ImageExtendedMaximaAction(viewer), 'Extended Maxima...');
        ImagemGUI.addMenuItem(minimaMenu, ImageImposeMinimaAction(viewer),   'Impose Minima...');
        
        ImagemGUI.addMenuItem(processMenu, ImageWatershedAction(viewer),      'Watershed...');
        ImagemGUI.addMenuItem(processMenu, ImageExtendedMinWatershedAction(viewer), ...
            'Extended Min Watershed...');
        
        ImagemGUI.addMenuItem(processMenu, ImageArithmeticAction(viewer), ...
            'Image Arithmetic...', true);
        ImagemGUI.addMenuItem(processMenu, ImageMathematicAction(viewer), ...
            'Image Mathematic...');
        
        binaryMenu = ImagemGUI.addMenu(processMenu, 'Binary / Labels', 'Separator', 'on');
        ImagemGUI.addMenuItem(binaryMenu, KillImageBordersAction(viewer), ...
            'Kill Borders');
        ImagemGUI.addMenuItem(binaryMenu, ImageAreaOpeningAction(viewer), ...
            'Area Opening');
        ImagemGUI.addMenuItem(binaryMenu, KeepLargestRegionAction(viewer), ...
            'Keep Largest Region');
        ImagemGUI.addMenuItem(binaryMenu, FillImageHolesAction(viewer), ...
            'Fill Holes');

        ImagemGUI.addMenuItem(binaryMenu, ...
            ApplyImageFunctionAction(viewer, 'distanceMap'), ...
            'Distance Map');

        ImagemGUI.addMenuItem(binaryMenu, ImageSkeletonAction(viewer), ...
            'Skeleton');
        ImagemGUI.addMenuItem(binaryMenu, LabelBinaryImageAction(viewer), ...
            'Connected Components Labeling');
        
        ImagemGUI.addMenuItem(binaryMenu, ImageBooleanOpAction(viewer), ...
            'Image Arithmetic...', true);
        ImagemGUI.addMenuItem(binaryMenu, ImageOverlayAction(viewer), ...
            'Image Overlay');
        
        % Interactive tools
        
        toolsMenu = ImagemGUI.addMenu(hf, 'Tools');
        
        tool = PrintCurrentPointTool(viewer);
        ImagemGUI.addMenuItem(toolsMenu, SelectToolAction(viewer, tool), ...
            'Print Current Point', true);
        
        
        ImagemGUI.addMenuItem(toolsMenu, ...
            SelectToolAction(viewer, SelectRectangleTool(viewer)), ...
            'Select Rectangle', true);

        ImagemGUI.addMenuItem(toolsMenu, ...
            SelectToolAction(viewer, SelectPolylineTool(viewer)), ...
            'Select Polyline');

        ImagemGUI.addMenuItem(toolsMenu, ...
            SelectToolAction(viewer, SelectPointsTool(viewer)), ...
            'Select Points');

        ImagemGUI.addMenuItem(toolsMenu, ...
            SelectToolAction(viewer, SelectLineSegmentTool(viewer)), ...
            'Select Line Segment');


        ImagemGUI.addMenuItem(toolsMenu, ...
            SelectToolAction(viewer, SetPixelToWhiteTool(viewer)), ...
            'Set Pixel to White', true);
        
        ImagemGUI.addMenuItem(toolsMenu, ...
            SelectToolAction(viewer, BrushTool(viewer)), ...
            'Brush');
        
        
        % Analyze Menu Definition
        
        analyzeMenu = ImagemGUI.addMenu(hf, 'Analyze');
        
        ImagemGUI.addMenuItem(analyzeMenu, ...
            SetImageScaleAction(viewer), 'Set Image Scale');

        ImagemGUI.addMenuItem(analyzeMenu, ...
            AnalyzeImageParticlesAction(viewer), 'Analyze Particles');
        item = ImagemGUI.addMenuItem(analyzeMenu, ...
            ShowImageHistogramAction(viewer), 'Histogram');
        set(item, 'Accelerator', 'H');

        item = ImagemGUI.addMenuItem(analyzeMenu, ...
            ImageSelectionLineProfileAction(viewer), ...
            'Plot Line Profile');
        set(item, 'Accelerator', 'K');
        
        
        % Help menu definition
        helpMenu = ImagemGUI.addMenu(hf, 'Help');
        
        ImagemGUI.addMenuItem(helpMenu, ...
            GenericAction(viewer, 'printHistory', ...
            @(src, evt) viewer.gui.app.printHistory), ...
            'Print History');
        
        
        % check which menu items are selected or not
        ImagemGUI.updateMenuEnable(fileMenu);
        ImagemGUI.updateMenuEnable(imageMenu);
        ImagemGUI.updateMenuEnable(viewMenu);
        ImagemGUI.updateMenuEnable(processMenu);
        ImagemGUI.updateMenuEnable(toolsMenu);
        ImagemGUI.updateMenuEnable(analyzeMenu);
        
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
            inds = [data.inds ind];
            
        else
            error(['Can not manage parent of type ' parentType]);
        end
        
        menu = uimenu(parent, 'Label', label, varargin{:});
        data = struct('inds', inds);
        set(menu, 'userdata', data);
        
    end
    
    function item = addMenuItem(menu, action, label, varargin)
        
        % Compute menu position as a set of recursive index positions
        children = get(menu, 'children');
        children = children(strcmp(get(children, 'type'), 'uimenu'));
        ind = length(children) + 1;
        data = get(menu, 'userdata');
        inds = [data.inds ind];
        
        % create user data associated with this menu
        data = struct('action', action, 'inds', inds);
        
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
            data = get(menu, 'userdata');
            if ~isempty(data) && isstruct(data) && isfield(data, 'action') && ~isempty(data.action)
                enable = isActivable(data.action);
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
    function [h, ht] = addInputTextLine(this, parent, label, text, cb)
        
        hLine = uiextras.HBox('Parent', parent, ...
            'Spacing', 5, 'Padding', 5);
        
        % Label of the widget
        ht = uicontrol('Style', 'Text', ...
            'Parent', hLine, ...
            'String', label, ...
            'FontWeight', 'Normal', ...
            'FontSize', 10, ...
            'HorizontalAlignment', 'Right');
        
        % creates the new control
        bgColor = getWidgetBackgroundColor(this);
        h = uicontrol(...
            'Style', 'Edit', ...
            'Parent', hLine, ...
            'String', text, ...
            'BackgroundColor', bgColor);
        if nargin > 4
            set(h, 'Callback', cb);
        end
        
        % setup size in horizontal direction
        set(hLine, 'Sizes', [-5 -5]);
    end
    
    function [h, ht] = addComboBoxLine(this, parent, label, choices, cb)
        
        hLine = uiextras.HBox('Parent', parent, ...
            'Spacing', 5, 'Padding', 5);
        
        % Label of the widget
        ht = uicontrol('Style', 'Text', ...
            'Parent', hLine, ...
            'String', label, ...
            'FontWeight', 'Normal', ...
            'FontSize', 10, ...
            'HorizontalAlignment', 'Right');
        
        % creates the new control
        bgColor = getWidgetBackgroundColor(this);
        h = uicontrol('Style', 'PopupMenu', ...
            'Parent', hLine, ...
            'String', choices, ...
            'BackgroundColor', bgColor, ...
            'Value', 1);
        if nargin > 4
            set(h, 'Callback', cb);
        end
        
        % setup size in horizontal direction
        set(hLine, 'Sizes', [-5 -5]);
    end
    
    function h = addCheckBox(this, parent, label, state, cb) %#ok<INUSL>
        
        hLine = uiextras.HBox('Parent', parent, ...
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
    function bgColor = getWidgetBackgroundColor(this) %#ok<MANU>
        % compute background color of most widgets
        if ispc
            bgColor = 'White';
        else
            bgColor = get(0, 'defaultUicontrolBackgroundColor');
        end
    end
end

end % classdef

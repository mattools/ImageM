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
    function addImageDocument(this, image)
        % Create a new document from image, add it to app, and display img
        
        if isempty(image)
            % in case of empty image, create an "empty view"
            imagem.gui.PlanarImageViewer(this, []);
            return;
        end
        
        % find a 'free' name for image
        newName = createDocumentName(this.app, image.name);
        image.name = newName;
        
        % creates new instance of ImageDoc
        doc = imagem.app.ImagemDoc(image);
        if ~isempty(image)
            if isLabelImage(image)
                doc.lut = 'jet';
            end
        end
        
        % add ImageDoc to the application
        addDocument(this.app, doc);
        
        % creates a display for the new image
        view = imagem.gui.PlanarImageViewer(this, doc);
        addView(doc, view);
        
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
                %removeView(doc, view);
                close(view);
            end
        
        end
    end
    
end % general methods

%% GUI Creation methods
methods
    function createFigureMenu(this, hf, viewer) %#ok<MANU>
        
        import imagem.gui.ImagemGUI;
        import imagem.gui.actions.*;
        import imagem.gui.tools.*;
                
        % File Menu Definition
        
        fileMenu = uimenu(hf, 'Label', 'Files');
        
        ImagemGUI.addMenuItem(fileMenu, CreateImageAction(viewer), 'New...');
        item = ImagemGUI.addMenuItem(fileMenu, ...
            OpenImageAction(viewer), 'Open...');
        set(item, 'Accelerator', 'O');


        demoMenu = uimenu(fileMenu, 'Label', 'Open Demo');
        
        action = OpenDemoImageAction(viewer, 'openDemoCameraman', 'cameraman.tif');
        ImagemGUI.addMenuItem(demoMenu, action, 'Cameraman (grayscale)');
        
        action = OpenDemoImageAction(viewer, 'openDemoRice', 'rice.png');
        ImagemGUI.addMenuItem(demoMenu, action, 'Rice (grayscale)');
        
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
        
        imageMenu = uimenu(hf, 'Label', 'Image');
        
        
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
        
        
        settingsMenu = uimenu(imageMenu, 'Label', 'Settings', 'Separator', 'on');
        ImagemGUI.addMenuItem(settingsMenu, ...
            SetDefaultConnectivityAction(viewer), 'Set Connectivity');
        ImagemGUI.addMenuItem(settingsMenu, ...
            SetBrushSizeAction(viewer), 'Set Brush Size');
        
        
        % View Menu Definition
        
        viewMenu = uimenu(hf, 'Label', 'View');
        lutMenu = uimenu(viewMenu, 'Label', 'LUT');
        ImagemGUI.addMenuItem(lutMenu, ChangeImageLutAction(viewer, 'gray'), 'Gray');
        ImagemGUI.addMenuItem(lutMenu, ChangeImageLutAction(viewer, 'inverted'), 'Inverted');
        ImagemGUI.addMenuItem(lutMenu, ChangeImageLutAction(viewer, 'blue-gray-red'), 'Blue-Gray-Red');
        
        ImagemGUI.addMenuItem(lutMenu , ChangeImageLutAction(viewer, 'jet'), 'Jet', true);
        ImagemGUI.addMenuItem(lutMenu , ChangeImageLutAction(viewer, 'hsv'), 'HSV');
        ImagemGUI.addMenuItem(lutMenu , ChangeImageLutAction(viewer, 'colorcube'), 'Color Cube');
        ImagemGUI.addMenuItem(lutMenu , ChangeImageLutAction(viewer, 'prism'), 'Prism');
        
        matlabLutMenu = uimenu(lutMenu, 'Label', 'Matlab''s');
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
        
        colorLutMenu = uimenu(lutMenu, 'Label', 'Simple Colors');
        ImagemGUI.addMenuItem(colorLutMenu, ChangeImageLutAction(viewer, 'blue'), 'Blue');
        ImagemGUI.addMenuItem(colorLutMenu, ChangeImageLutAction(viewer, 'red'), 'Red');
        ImagemGUI.addMenuItem(colorLutMenu, ChangeImageLutAction(viewer, 'green'), 'Green');
        ImagemGUI.addMenuItem(colorLutMenu, ChangeImageLutAction(viewer, 'cyan'), 'Cyan');
        ImagemGUI.addMenuItem(colorLutMenu, ChangeImageLutAction(viewer, 'yellow'), 'Yellow');
        ImagemGUI.addMenuItem(colorLutMenu, ChangeImageLutAction(viewer, 'magenta'), 'Magenta');

        
        ImagemGUI.addMenuItem(viewMenu, ZoomInAction(viewer), 'Zoom In', true);
        ImagemGUI.addMenuItem(viewMenu, ZoomOutAction(viewer), 'Zoom Out');
        ImagemGUI.addMenuItem(viewMenu, ZoomOneAction(viewer), 'Zoom 1:1');
        ImagemGUI.addMenuItem(viewMenu, ZoomBestAction(viewer), 'Zoom Best');
        
        
        ImagemGUI.addMenuItem(viewMenu, ...
            PrintImageDocListAction(viewer), 'Print Image List', true);
        
        
        % Process Menu Definition
        
        processMenu = uimenu(hf, 'Label', 'Process');
        
        ImagemGUI.addMenuItem(processMenu, ImageAdjustDynamicAction(viewer),  'Adjust Dynamic');
        ImagemGUI.addMenuItem(processMenu, ImageMeanFilter3x3Action(viewer),  'Mean', true);
        ImagemGUI.addMenuItem(processMenu, ImageMedianFilter3x3Action(viewer),  'Median');
                
        morphoMenu = uimenu(processMenu, 'Label', 'Morphology');
        ImagemGUI.addMenuItem(morphoMenu, ImageErosionAction(viewer),     'Erosion');
        ImagemGUI.addMenuItem(morphoMenu, ImageDilationAction(viewer),    'Dilation');
        ImagemGUI.addMenuItem(morphoMenu, ImageOpeningAction(viewer),     'Opening');
        ImagemGUI.addMenuItem(morphoMenu, ImageClosingAction(viewer),     'Closing');    
        
        ImagemGUI.addMenuItem(processMenu, ImageThresholdAction(viewer),  'Threshold...', true);
        ImagemGUI.addMenuItem(processMenu, ImageAutoThresholdOtsuAction(viewer),  'Threshold (Otsu)');
        ImagemGUI.addMenuItem(processMenu, ImageGradientAction(viewer),   'Gradient', true);
        ImagemGUI.addMenuItem(processMenu, ImageMorphoGradientAction(viewer), ...
            'Morphological Gradient');
        ImagemGUI.addMenuItem(processMenu, ImageGradientVectorAction(viewer),   'Gradient Vector');
        ImagemGUI.addMenuItem(processMenu, ImageNormAction(viewer),       'Norm');

        minimaMenu = uimenu(processMenu, 'Label', 'Minima / Maxima', 'Separator', 'on');
        ImagemGUI.addMenuItem(minimaMenu, ImageRegionalMinimaAction(viewer), 'Regional Minima');
        ImagemGUI.addMenuItem(minimaMenu, ImageRegionalMaximaAction(viewer), 'Regional Maxima');
        ImagemGUI.addMenuItem(minimaMenu, ImageExtendedMinimaAction(viewer), 'Extended Minima...');
        ImagemGUI.addMenuItem(minimaMenu, ImageExtendedMaximaAction(viewer), 'Extended Maxima...');
        ImagemGUI.addMenuItem(minimaMenu, ImageImposeMinimaAction(viewer),   'Impose Minima...');
        
        ImagemGUI.addMenuItem(processMenu, ImageWatershedAction(viewer),      'Watershed...');
        ImagemGUI.addMenuItem(processMenu, ImageExtendedMinWatershedAction(viewer), ...
            'Extended Min Watershed...');
        
        
        binaryMenu = uimenu(processMenu, 'Label', 'Binary / Labels', 'Separator', 'on');
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
        
        ImagemGUI.addMenuItem(binaryMenu, ImageOverlayAction(viewer), ...
            'Image Overlay', true);
        
        % Interactive tools
        
        toolsMenu = uimenu(hf, 'Label', 'Tools');
        
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
        
        analyzeMenu = uimenu(hf, 'Label', 'Analyze');
        
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
        
        % check which menu items are selected or not
        ImagemGUI.updateMenuEnable(fileMenu);
        ImagemGUI.updateMenuEnable(imageMenu);
        ImagemGUI.updateMenuEnable(viewMenu);
        ImagemGUI.updateMenuEnable(processMenu);
        ImagemGUI.updateMenuEnable(toolsMenu);
        ImagemGUI.updateMenuEnable(analyzeMenu);
        

    end
end

methods (Static)
    function item = addMenuItem(menu, action, label, varargin)
        
        % creates new item
        item = uimenu(menu, 'Label', label, ...
            'UserData', action, ...
            'Callback', @action.actionPerformed);
        
        % eventually add separator above item
        if ~isempty(varargin)
            var = varargin{1};
            if islogical(var)
                set(item, 'Separator', 'On');
            end
        end
    end
    
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
            % menu is active if at east one subitem is active
            for i = 1:length(children)
                en = imagem.gui.ImagemGUI.updateMenuEnable(children(i));
                enable = enable || en;
            end
            
        else
            % process final menu item
            action = get(menu, 'userdata');
            if ~isempty(action)
                enable = isActivable(action);
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
    function [h ht] = addInputTextLine(this, parent, label, text, cb)
        
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
    
    function [h ht] = addComboBoxLine(this, parent, label, choices, cb)
        
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

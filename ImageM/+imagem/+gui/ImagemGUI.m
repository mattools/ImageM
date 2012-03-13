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
        
        if ~isempty(image)
            % find a 'free' name for image
            newName = createDocumentName(this.app, image.name);
            image.name = newName;
        end
        
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
        ImagemGUI.addMenuItem(fileMenu, OpenImageAction(viewer), 'Open...');

        demoMenu = uimenu(fileMenu, 'Label', 'Open Demo');
        
        action = OpenDemoImageAction(viewer, 'openDemoCameraman', 'cameraman.tif');
        ImagemGUI.addMenuItem(demoMenu, action, 'Cameraman');
        
        action = OpenDemoImageAction(viewer, 'openDemoRice', 'rice.png');
        ImagemGUI.addMenuItem(demoMenu, action, 'Rice');
        
        action = OpenDemoImageAction(viewer, 'openDemoPeppers', 'peppers.png');
        ImagemGUI.addMenuItem(demoMenu, action, 'Peppers');
        
        action = OpenDemoImageAction(viewer, 'openDemoCircles', 'circles.png');
        ImagemGUI.addMenuItem(demoMenu, action, 'Circles');
        
        ImagemGUI.addMenuItem(fileMenu, ImportImageFromWorkspaceAction(viewer), 'Import From Workspace...');
        
        
        ImagemGUI.addMenuItem(fileMenu, SaveImageAction(viewer), 'Save As...', true);
        ImagemGUI.addMenuItem(fileMenu, ExportImageToWorkspaceAction(viewer), 'Export To Workspace...');
        
        ImagemGUI.addMenuItem(fileMenu, CloseImageAction(viewer), 'Close', true);
        ImagemGUI.addMenuItem(fileMenu, ExitAction(viewer), 'Quit');
        
        
        % Image Menu Definition
        
        imageMenu = uimenu(hf, 'Label', 'Image');
        
        lutMenu = uimenu(imageMenu, 'Label', 'LUT');
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
        
        ImagemGUI.addMenuItem(imageMenu, SplitImageRGBAction(viewer),     'Split RGB');
        ImagemGUI.addMenuItem(imageMenu, ImageOverlayAction(viewer),      'Image Overlay');
        ImagemGUI.addMenuItem(imageMenu, InvertImageAction(viewer),       'Invert Image');
        ImagemGUI.addMenuItem(imageMenu, RenameImageAction(viewer),       'Rename', true);
        ImagemGUI.addMenuItem(imageMenu, DuplicateImageAction(viewer),    'Duplicate');
        ImagemGUI.addMenuItem(imageMenu, CropImageSelectionAction(viewer),    'Crop Selection');
        ImagemGUI.addMenuItem(imageMenu, ...
            SetDefaultConnectivityAction(viewer), 'Set Connectivity', true);
        
        % View Menu Definition
        
        viewMenu = uimenu(hf, 'Label', 'View');
        ImagemGUI.addMenuItem(viewMenu, ZoomInAction(viewer), 'Zoom In');
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
        
        ImagemGUI.addMenuItem(processMenu, ...
            ApplyImageFunctionAction(viewer, 'distanceMap'), ...
            'Distance Map');

        ImagemGUI.addMenuItem(processMenu, ImageSkeletonAction(viewer), ...
            'Skeleton');
        ImagemGUI.addMenuItem(processMenu, LabelBinaryImageAction(viewer), ...
            'Connected Components Labeling');
        
        
        % Interactive tools
        
        toolsMenu = uimenu(hf, 'Label', 'Tools');
        
        tool = PrintCurrentPointTool(viewer);
        ImagemGUI.addMenuItem(toolsMenu, SelectToolAction(viewer, tool), ...
            'Print Current Point', true);
        
        tool = SelectRectangleTool(viewer);
        ImagemGUI.addMenuItem(toolsMenu, SelectToolAction(viewer, tool), ...
            'Select Rectangle');

        ImagemGUI.addMenuItem(toolsMenu, ...
            SelectToolAction(viewer, SetPixelToWhiteTool(viewer)), ...
            'Set Pixel to White');
        
        ImagemGUI.addMenuItem(toolsMenu, ...
            SelectToolAction(viewer, BrushTool(viewer)), ...
            'Brush');
        
        
        % Analyze Menu Definition
        
        analyzeMenu = uimenu(hf, 'Label', 'Analyze');
        
        ImagemGUI.addMenuItem(analyzeMenu, ShowImageHistogramAction(viewer), 'Histogram');
        
        ImagemGUI.addMenuItem(analyzeMenu, ...
            SelectToolAction(viewer, LineProfileTool(viewer)), ...
            'Plot Line Profile');
        
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
    function bgColor = getWidgetBackgroundColor(this) %#ok<MANU>
        % compute background color of most widgets
        if ispc
            bgColor = 'White';
        else
            bgColor = get(0,'defaultUicontrolBackgroundColor');
        end
    end
end

end % classdef

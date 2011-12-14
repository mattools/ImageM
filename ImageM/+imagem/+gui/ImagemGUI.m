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
        
        % creates new instance of ImageDoc
        doc = imagem.app.ImagemDoc(image);
        
        % add ImageDoc to the application
        addDocument(this.app, doc);
        
        % creates a display for the new image
        view = imagem.gui.PlanarImageViewer(this, doc);
        addView(doc, view);
        
    end
    
    function exit(this)
        % EXIT Close all viewers
        
%         disp('calling ImagemGUI.exit() method');
           
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
    function createFigureMenu(this, hf, viewer) %#ok<MANU>
        
        import imagem.gui.actions.*;
        import imagem.gui.tools.*;
       
        % File Menu Definition
        
        fileMenu = uimenu(hf, 'Label', 'Files');
        
        action = SayHelloAction(viewer);
        uimenu(fileMenu, 'Label', 'New...', ...
            'Callback', @action.actionPerformed);
        
        action = OpenImageAction(viewer);
        uimenu(fileMenu, 'Label', 'Open...', ...
            'Callback', @action.actionPerformed);
        
        action = SayHelloAction(viewer);
        uimenu(fileMenu, 'Label', 'Say Hello!', ...
            'Callback', @action.actionPerformed);
        
        demoMenu = uimenu(fileMenu, 'Label', 'Open Demo');
        
        action = OpenDemoImageAction(viewer, 'openDemoCameraman', 'cameraman.tif');
        uimenu(demoMenu, 'Label', 'Cameraman', ...
            'Callback', @action.actionPerformed);
        
        action = OpenDemoImageAction(viewer, 'openDemoRice', 'rice.png');
        uimenu(demoMenu, 'Label', 'Rice', ...
            'Callback', @action.actionPerformed);
        
        action = OpenDemoImageAction(viewer, 'openDemoPeppers', 'peppers.png');
        uimenu(demoMenu, 'Label', 'Peppers', ...
            'Callback', @action.actionPerformed);
        
        action = OpenDemoImageAction(viewer, 'openDemoCircles', 'circles.png');
        uimenu(demoMenu, 'Label', 'Circles', ...
            'Callback', @action.actionPerformed);
        
        addMenuItem(fileMenu, CloseImageAction(viewer), 'Close', true);
        addMenuItem(fileMenu, ExitAction(viewer), 'Quit');
        
        
        % Image Menu Definition
        
        imageMenu = uimenu(hf, 'Label', 'Image');
        
        lutMenu = uimenu(imageMenu, 'Label', 'LUT');
        addMenuItem(lutMenu, ChangeImageLutAction(viewer, 'gray'), 'Gray');
        addMenuItem(lutMenu, ChangeImageLutAction(viewer, 'inverted'), 'Inverted');
        addMenuItem(lutMenu, ChangeImageLutAction(viewer, 'blue-gray-red'), 'Blue-Gray-Red');
        
        addMenuItem(lutMenu , ChangeImageLutAction(viewer, 'jet'), 'Jet', true);
        addMenuItem(lutMenu , ChangeImageLutAction(viewer, 'hsv'), 'HSV');
        addMenuItem(lutMenu , ChangeImageLutAction(viewer, 'colorcube'), 'Color Cube');
        addMenuItem(lutMenu , ChangeImageLutAction(viewer, 'prism'), 'Prism');
        
        matlabLutMenu = uimenu(lutMenu, 'Label', 'Matlab''s');
        addMenuItem(matlabLutMenu, ChangeImageLutAction(viewer, 'hot'), 'Hot');
        addMenuItem(matlabLutMenu, ChangeImageLutAction(viewer, 'cool'), 'Cool');
        addMenuItem(matlabLutMenu, ChangeImageLutAction(viewer, 'spring'), 'Spring');
        addMenuItem(matlabLutMenu, ChangeImageLutAction(viewer, 'summer'), 'Summer');
        addMenuItem(matlabLutMenu, ChangeImageLutAction(viewer, 'winter'), 'Winter');
        addMenuItem(matlabLutMenu, ChangeImageLutAction(viewer, 'autumn'), 'Autumn');
        addMenuItem(matlabLutMenu, ChangeImageLutAction(viewer, 'copper'), 'Copper');
        addMenuItem(matlabLutMenu, ChangeImageLutAction(viewer, 'bone'), 'Bone');
        addMenuItem(matlabLutMenu, ChangeImageLutAction(viewer, 'pink'), 'Pink');
        addMenuItem(matlabLutMenu, ChangeImageLutAction(viewer, 'lines'), 'Lines');
        
        colorLutMenu = uimenu(lutMenu, 'Label', 'Simple Colors');
        addMenuItem(colorLutMenu, ChangeImageLutAction(viewer, 'blue'), 'Blue');
        addMenuItem(colorLutMenu, ChangeImageLutAction(viewer, 'red'), 'Red');
        addMenuItem(colorLutMenu, ChangeImageLutAction(viewer, 'green'), 'Green');
        addMenuItem(colorLutMenu, ChangeImageLutAction(viewer, 'cyan'), 'Cyan');
        addMenuItem(colorLutMenu, ChangeImageLutAction(viewer, 'yellow'), 'Yellow');
        addMenuItem(colorLutMenu, ChangeImageLutAction(viewer, 'magenta'), 'Magenta');
        
        addMenuItem(imageMenu, SplitImageRGBAction(viewer),   'Split RGB');
        addMenuItem(imageMenu, InvertImageAction(viewer),     'Invert Image');
        
        % View Menu Definition
        
        viewMenu = uimenu(hf, 'Label', 'View');
        addMenuItem(viewMenu, ZoomInAction(viewer), 'Zoom In');
        addMenuItem(viewMenu, ZoomOutAction(viewer), 'Zoom Out');
        addMenuItem(viewMenu, ZoomOneAction(viewer), 'Zoom 1:1');
        addMenuItem(viewMenu, ZoomBestAction(viewer), 'Zoom Best');
        
        
        addMenuItem(viewMenu, ...
            PrintImageDocListAction(viewer), 'Print Image List', true);
        
        
        % Process Menu Definition
        
        processMenu = uimenu(hf, 'Label', 'Process');
        
        addMenuItem(processMenu, ImageMeanFilter3x3Action(viewer),  'Mean');
        addMenuItem(processMenu, ImageMedianFilter3x3Action(viewer),  'Median');
        
        addMenuItem(processMenu, ImageThresholdAction(viewer),  'Threshold...', true);
        addMenuItem(processMenu, ImageGradientAction(viewer),   'Gradient');
        addMenuItem(processMenu, ImageNormAction(viewer),       'Norm');
        
        morphoMenu = uimenu(processMenu, 'Label', 'Morphology');
        addMenuItem(morphoMenu, ImageErosionAction(viewer),     'Erosion');
        addMenuItem(morphoMenu, ImageDilationAction(viewer),    'Dilation');
        addMenuItem(morphoMenu, ImageOpeningAction(viewer),     'Opening');
        addMenuItem(morphoMenu, ImageClosingAction(viewer),     'Closing');
        
        
        addMenuItem(processMenu, ...
            ApplyImageFunctionAction(viewer, 'distanceMap'), ...
            'Distance Map');
        
        tool = PrintCurrentPointTool(viewer);
        addMenuItem(processMenu, SelectToolAction(viewer, tool), ...
            'Print Current Point', true);
        
        addMenuItem(processMenu, ...
            SelectToolAction(viewer, SetPixelToWhiteTool(viewer)), ...
            'Set Pixel to White');
        
        addMenuItem(processMenu, ...
            SelectToolAction(viewer, BrushTool(viewer)), ...
            'Brush');
        
        % Analyze Menu Definition
        
        analyzeMenu = uimenu(hf, 'Label', 'Analyze');
        
        addMenuItem(analyzeMenu, showImageHistogramAction(viewer), 'Histogram');
        
        addMenuItem(analyzeMenu, ...
            SelectToolAction(viewer, LineProfileTool(viewer)), ...
            'Plot Line Profile');
        
        % check which menu items are selected or not
        updateMenuEnable(this, fileMenu);
        updateMenuEnable(this, imageMenu);
        updateMenuEnable(this, viewMenu);
        updateMenuEnable(this, processMenu);
        updateMenuEnable(this, analyzeMenu);
        
        
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
    end
    
    function updateMenuEnable(this, menu)
        
        % default is enabled
        set(menu, 'Enable', 'on');
        
        % first, process recursion on children
        children = get(menu, 'children');
        for i = 1:length(children)
            updateMenuEnable(this, children(i));
        end
        
        action = get(menu, 'userdata');
        if isempty(action)
            return;
        end
        
        if ~isActivable(action)
            set(menu, 'Enable', 'off');
        end
    end
end

end % classdef

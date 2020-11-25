classdef FrameMenuBuilder < handle
% Utilkity class that builds the menu bar of an ImageM frame.
%
%   Class FrameMenuBuilder
%
%   Example
%   FrameMenuBuilder
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-11-19,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    Gui;
    
    Frame;
end % end properties


%% Constructor
methods
    function obj = FrameMenuBuilder(gui, frame)
        % Constructor for FrameMenuBuilder class.
        obj.Gui = gui;
        obj.Frame = frame;
    end

end % end constructors


%% Methods
methods
    function buildMenu(obj, hf)
        % Build figure menu for the specified Figure handle.
        
        % Dispatch process depending on frame type
        if isa(obj.Frame, 'imagem.gui.ImageViewer')
            buildImageFrameMenu(obj, hf);
        elseif isa(obj.Frame, 'imagem.gui.TableFrame')
            buildTableFrameMenu(obj, hf);
        else
            
        end
    end
    
    
end % end methods

%% Private methods
methods
    function buildImageFrameMenu(obj, hf)
        
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
        import imagem.actions.table.*;
        import imagem.gui.tools.*;
        import imagem.tools.*;
                
        % File Menu Definition
        
        fileMenu = addMenu(obj, hf, 'Files');
        
        addMenuItem(obj, fileMenu, CreateImage(),            'New Image...', 'Accelerator', 'N');
        addMenuItem(obj, fileMenu, OpenImage(),              'Open Image...', 'Accelerator', 'O');
        addMenuItem(obj, fileMenu, OpenTable(),              'Open Table...', 'Accelerator', 'O');

        demoMenu = addMenu(obj, fileMenu, 'Open Demo');
        addMenuItem(obj, demoMenu, OpenDemoImage('cameraman.tif'), 	'Cameraman (grayscale)');
        addMenuItem(obj, demoMenu, OpenDemoImage('rice.png'),    'Rice (grayscale)');
        addMenuItem(obj, demoMenu, OpenDemoImage('coins.png'),   'Coins (grayscale)');
        addMenuItem(obj, demoMenu, OpenDemoImage('peppers.png'), 'Peppers (RGB)');
        addMenuItem(obj, demoMenu, OpenDemoImage('mri.tif'),     'MRI Head (3D)');
        addMenuItem(obj, demoMenu, OpenDemoImage('xylophone.mp4'),     'Xylophone (movie)');
        addMenuItem(obj, demoMenu, OpenDemoImage('circles.png'), 'Circles (binary)');
        addMenuItem(obj, demoMenu, OpenDemoImage('text.png'),    'Text (binary)');
        addMenuItem(obj, demoMenu, OpenDemoTable('fisherIris.txt'),    'Fisher Iris (Table)', 'Separator', 'on');

        addMenuItem(obj, fileMenu, ImportImageFromWorkspace(),   'Import From Workspace...');
        
        addMenuItem(obj, fileMenu, SaveImage(),              'Save As...', ...
            'Separator', 'on', 'Accelerator', 'S');
        addMenuItem(obj, fileMenu, ExportImageToWorkspace(), 'Export To Workspace...');
        addMenuItem(obj, fileMenu, SaveSelection(),          'Save Selection...', 'Separator', 'on');

        item = addMenuItem(obj, fileMenu, CloseFrame(),      'Close', 'Separator', 'on');
        set(item, 'Accelerator', 'W');

        item = addMenuItem(obj, fileMenu, Exit(), 'Quit');
        set(item, 'Accelerator', 'Q');
        
        
        % Image Menu Definition
        
        imageMenu = addMenu(obj, hf, 'Image');
        
        addMenuItem(obj, imageMenu, PrintImageInfo(),       'Print info');
        calibMenu = addMenu(obj, imageMenu, 'Calibration');
        addMenuItem(obj, calibMenu, EditSpatialCalibration(),       'Edit Spatial Calibration...');
        addMenuItem(obj, calibMenu, ClearSpatialCalibration(),      'Clear Spatial Calibration');
        channelTypeMenu = addMenu(obj, calibMenu, 'Channel Display');
        addMenuItem(obj, channelTypeMenu, SetChannelDisplayType('Curve'),   'Curve');
        addMenuItem(obj, channelTypeMenu, SetChannelDisplayType('Bar'),     'Bar');
        addMenuItem(obj, channelTypeMenu, SetChannelDisplayType('Stem'),    'Stem');
        
        
        
        convertTypeMenu = addMenu(obj, imageMenu,  'Set Image Type');
        addMenuItem(obj, convertTypeMenu, ImageConvertType('binary'),    'Binary');
        addMenuItem(obj, convertTypeMenu, ImageConvertType('grayscale'), 'Grayscale');
        addMenuItem(obj, convertTypeMenu, ImageConvertType('intensity'), 'Intensity');
        addMenuItem(obj, convertTypeMenu, ImageConvertType('label'),     'Label');

        colorMenu = addMenu(obj, imageMenu, 'Color', 'Separator', 'on');
        addMenuItem(obj, colorMenu, SplitImageRGB(),        'Split RGB');
        addMenuItem(obj, colorMenu, SplitImageChannels(),   'Split Channels');
        addMenuItem(obj, colorMenu, MergeImageChannels(),   'Merge Channels...');
        addMenuItem(obj, colorMenu, ReorderChannels(),      'Re-order Channels...', true);
        addMenuItem(obj, colorMenu, EditChannelNames(),     'Edit Channels...');
        
        convertMenu = addMenu(obj, imageMenu, 'Convert');
        addMenuItem(obj, convertMenu, ConvertImage3DToVectorImage(),    '3D Image to Vector Image');
        addMenuItem(obj, convertMenu, ConvertVectorImageToImage3D(),    'Vector Image to 3D Image');
        addMenuItem(obj, convertMenu, ConvertVectorImageToRGB(),        'Vector Image to RGB');
        addMenuItem(obj, convertMenu, UnfoldVectorImage(),              'Unfold Vector Image to Table', 'Separator', 'on');
        addMenuItem(obj, convertMenu, UnfoldVectorImageWithMask(),      'Unfold Vector Image Within Mask to Table...');
        addMenuItem(obj, imageMenu, ReshapeImage(),         'Reshape...');
        addMenuItem(obj, imageMenu, PermuteDimensions(),    'Permute Dimensions...');
        
        addMenuItem(obj, imageMenu, FlipImage(1),           'Horizontal Flip', 'Separator', 'on');
        addMenuItem(obj, imageMenu, FlipImage(2),           'Vertical Flip');
        addMenuItem(obj, imageMenu, RotateImage90(1),       'Rotate Right');
        addMenuItem(obj, imageMenu, RotateImage90(-1),      'Rotate Left');

        addMenuItem(obj, imageMenu, InvertImage(),          'Invert Image', 'Accelerator', 'I', 'Separator', 'on');
        
        addMenuItem(obj, imageMenu, RenameImage(),          'Rename', 'Separator', 'on');
        addMenuItem(obj, imageMenu, DuplicateImage(),       'Duplicate', 'Accelerator', 'D');
        addMenuItem(obj, imageMenu, ExtractSlice(),         'Extract Slice');
        addMenuItem(obj, imageMenu, ExtractFrame(),         'Extract Time Frame');
        addMenuItem(obj, imageMenu, CropImageSelection(),   'Crop Selection');
        
        
        settingsMenu = addMenu(obj, imageMenu, 'Settings', 'Separator', 'on');
        addMenuItem(obj, settingsMenu, SetBrushSize(),           'Set Brush Size');
        addMenuItem(obj, settingsMenu, SetBrushValue(),          'Set Brush Value');
        addMenuItem(obj, settingsMenu, SetDefaultConnectivity(), 'Set Connectivity', 'Separator', 'on');
        
        
        % View Menu Definition
        
        viewMenu = addMenu(obj, hf, 'View');

        addMenuItem(obj, viewMenu, ImageSetDisplayRange(),  'Set Display Range...');

        lutMenu = addMenu(obj, viewMenu, 'Color Maps');
        addMenuItem(obj, lutMenu, SetImageColorMap('gray'),           'Gray');
        addMenuItem(obj, lutMenu, SetImageColorMap('inverted'),       'Inverted');
        addMenuItem(obj, lutMenu, SetImageColorMap('blue-gray-red'),  'Blue-Gray-Red');
        
        addMenuItem(obj, lutMenu, SetImageColorMap('parula'),         'Parula', 'Separator', 'on');
        addMenuItem(obj, lutMenu, SetImageColorMap('hsv'),            'HSV');
        addMenuItem(obj, lutMenu, SetImageColorMap('colorcube'),      'Color Cube');
        addMenuItem(obj, lutMenu, SetImageColorMap('prism'),          'Prism');
        addMenuItem(obj, lutMenu, SetImageColorMap('jet'),            'Jet');
        
        matlabLutMenu = addMenu(obj, lutMenu, 'Matlab''s');
        addMenuItem(obj, matlabLutMenu, SetImageColorMap('hot'),      'Hot');
        addMenuItem(obj, matlabLutMenu, SetImageColorMap('cool'),     'Cool');
        addMenuItem(obj, matlabLutMenu, SetImageColorMap('spring'),   'Spring');
        addMenuItem(obj, matlabLutMenu, SetImageColorMap('summer'),   'Summer');
        addMenuItem(obj, matlabLutMenu, SetImageColorMap('winter'),   'Winter');
        addMenuItem(obj, matlabLutMenu, SetImageColorMap('autumn'),   'Autumn');
        addMenuItem(obj, matlabLutMenu, SetImageColorMap('copper'),   'Copper');
        addMenuItem(obj, matlabLutMenu, SetImageColorMap('bone'),     'Bone');
        addMenuItem(obj, matlabLutMenu, SetImageColorMap('pink'),     'Pink');
        addMenuItem(obj, matlabLutMenu, SetImageColorMap('lines'),    'Lines');
        
        colorLutMenu = addMenu(obj, lutMenu, 'Simple Colors');
        addMenuItem(obj, colorLutMenu, SetImageColorMap('blue'),      'Blue');
        addMenuItem(obj, colorLutMenu, SetImageColorMap('red'),       'Red');
        addMenuItem(obj, colorLutMenu, SetImageColorMap('green'),     'Green');
        addMenuItem(obj, colorLutMenu, SetImageColorMap('cyan'),      'Cyan');
        addMenuItem(obj, colorLutMenu, SetImageColorMap('yellow'),    'Yellow');
        addMenuItem(obj, colorLutMenu, SetImageColorMap('magenta'),   'Magenta');
        
        addMenuItem(obj, viewMenu, SetBackgroundColor(),  'Set Background Color...');

        
        addMenuItem(obj, viewMenu, ZoomIn(),         'Zoom In', true);
        addMenuItem(obj, viewMenu, ZoomOut(),        'Zoom Out');
        addMenuItem(obj, viewMenu, ZoomOne(),        'Zoom 1:1');
        addMenuItem(obj, viewMenu, ZoomBestFit(),    'Zoom Best');
        
        zoomsMenu = addMenu(obj, viewMenu, 'Others');
        addMenuItem(obj, zoomsMenu, SetCurrentZoomLevel(8),     'Zoom 8:1');
        addMenuItem(obj, zoomsMenu, SetCurrentZoomLevel(4),     'Zoom 4:1');
        addMenuItem(obj, zoomsMenu, SetCurrentZoomLevel(2),     'Zoom 2:1');
        addMenuItem(obj, zoomsMenu, SetCurrentZoomLevel(1),     'Zoom 1:1');
        addMenuItem(obj, zoomsMenu, SetCurrentZoomLevel(1/2),   'Zoom 1:2');
        addMenuItem(obj, zoomsMenu, SetCurrentZoomLevel(1/4),   'Zoom 1:4');
        addMenuItem(obj, zoomsMenu, SetCurrentZoomLevel(1/8),   'Zoom 1:8');

        zoomModesMenu = addMenu(obj, viewMenu, 'Zoom Mode');
        adjustZoomAction = SetZoomMode('adjust');
        mi1 = addMenuItem(obj, zoomModesMenu, adjustZoomAction, 'Adjust', 'Checked', 'on');
        setMenuItem(adjustZoomAction, mi1);
        
        fixedZoomAction = SetZoomMode('fixed');
        mi2 = addMenuItem(obj, zoomModesMenu, fixedZoomAction,  'Fixed');
        setMenuItem(fixedZoomAction, mi2);

        actionGroup = [adjustZoomAction fixedZoomAction];
        for iAction = 1:2
            action = actionGroup(iAction);
            setActionGroup(action, actionGroup);
        end
        
        addMenuItem(obj, viewMenu, ShowImage3DOrthoSlices(),    'Show 3D OrthoSlices...', ...
            'Separator', 'on');
        addMenuItem(obj, viewMenu, Image3DIsosurface(),         'Show 3D Isosurface...');
        
        addMenuItem(obj, viewMenu, PrintImageDocList(),         'Print Image List', 'Separator', 'on');
        
        
        % Process Menu Definition
        
        processMenu = addMenu(obj, hf, 'Process');
        
        addMenuItem(obj, processMenu, AdjustImageDynamic(),     'Adjust Dynamic');
        addMenuItem(obj, processMenu, ImageLabelToRgb(),        'Label To RGB...');
        addMenuItem(obj, processMenu, ImageReplaceValue(),      'Replace Value(s)...');

%         filtersMenu = addMenu(obj, processMenu, 'Filters', 'Separator', 'on');

        addMenuItem(obj, processMenu, ImageBoxMeanFilter(), 'Box Mean Filter...', 'Separator', 'on');
        addMenuItem(obj, processMenu, ImageMedianFilter(),  'Median Filter...');
        addMenuItem(obj, processMenu, ImageGaussianFilter(), 'Gaussian Filter...');
        addMenuItem(obj, processMenu, ImageMorphologicalFilter(), 'Morphological Filter...');    
        
        addMenuItem(obj, processMenu, ImageGradient(),      'Gradient', ...
            'Separator', 'on', 'Accelerator', 'G');
        addMenuItem(obj, processMenu, ImageGradientVector(), 'Gradient Vector');
        addMenuItem(obj, processMenu, VectorImageNorm(),    'Norm');

        minimaMenu = addMenu(obj, processMenu, 'Connected Regions Operators', 'Separator', 'on');
        addMenuItem(obj, minimaMenu, ImageMorphologicalReconstruction(), 'Morphological Reconstruction...');    
        addMenuItem(obj, minimaMenu, ImageRegionalMinima(), 'Regional Minima', 'Separator', 'on');
        addMenuItem(obj, minimaMenu, ImageRegionalMaxima(), 'Regional Maxima');
        addMenuItem(obj, minimaMenu, ImageExtendedMinima(), 'Extended Minima...');
        addMenuItem(obj, minimaMenu, ImageExtendedMaxima(), 'Extended Maxima...');
        addMenuItem(obj, minimaMenu, ImageImposeMinima(),   'Impose Minima...');
        
        addMenuItem(obj, processMenu, ImageThreshold(),     'Manual Threshold...', ...
            'Separator', 'on', 'Accelerator', 'T');
        addMenuItem(obj, processMenu, ImageAutoThresholdOtsu(), 'Auto Threshold (Otsu)');
        addMenuItem(obj, processMenu, ImageMaxEntropyThreshold(), 'Auto Threshold (Max Entropy)');
        addMenuItem(obj, processMenu, ImageWatershed(),      'Watershed...');
        addMenuItem(obj, processMenu, ImageExtendedMinWatershed(), 'Extended Min Watershed...');
        
        addMenuItem(obj, processMenu, ImageArithmetic(),    'Image Arithmetic...', true);
        addMenuItem(obj, processMenu, ImageValuesTransform(), 'Image Maths 1...');
        addMenuItem(obj, processMenu, ImageMathematic(),    'Image Maths 2...');
        
        binaryMenu = addMenu(obj, processMenu, 'Binary / Labels', 'Separator', 'on');
        addMenuItem(obj, binaryMenu, KillImageBorders(),    'Kill Borders');
        addMenuItem(obj, binaryMenu, ImageAreaOpening(),    'Area Opening');
        addMenuItem(obj, binaryMenu, KeepLargestRegion(),   'Keep Largest Region');
        addMenuItem(obj, binaryMenu, FillImageHoles(),      'Fill Holes');

        addMenuItem(obj, binaryMenu, ApplyImageFunction('distanceMap'), 'Distance Map');
        addMenuItem(obj, binaryMenu, GeodesicDistanceMap(), 'Geodesic Distance Map');
        addMenuItem(obj, binaryMenu, ImageSkeleton(),       'Skeleton');
        addMenuItem(obj, binaryMenu, ConnectedComponentsLabeling(),  'Connected Components Labeling');
        
        addMenuItem(obj, binaryMenu, ImageBooleanOp(),      'Boolean Operation...', true);
        addMenuItem(obj, binaryMenu, BinaryImageOverlay(),  'Image Overlay...');
        addMenuItem(obj, binaryMenu, CreateLabelValuesMap(), 'Create Label Values Map...');
        
        % Interactive tools
        
        toolsMenu = addMenu(obj, hf, 'Tools');
        
        addMenuItem(obj, toolsMenu, SelectTool(@PrintCurrentPointPosition), 'Print Current Point');
        addMenuItem(obj, toolsMenu, SelectTool(@ScrollImagePosition),        'Scroll Image');
        
        addMenuItem(obj, toolsMenu, SelectTool(@SelectRectangle),  'Select Rectangle', true);
        addMenuItem(obj, toolsMenu, SelectTool(@SelectPoints),     'Select Points');
        addMenuItem(obj, toolsMenu, SelectTool(@SelectPolyline),   'Select Polyline');
        addMenuItem(obj, toolsMenu, SelectTool(@SelectPolygon),    'Select Polygon');
        addMenuItem(obj, toolsMenu, SelectTool(@SelectLineSegment),'Select Line Segment');

        addMenuItem(obj, toolsMenu, SelectTool(@SetPixelToWhite), ...
            'Set Pixel to White', true);
        
        addMenuItem(obj, toolsMenu, SelectTool(@Brush),            'Brush');
        addMenuItem(obj, toolsMenu, SelectTool(@FloodFillTool),    'Flood Fill');
        addMenuItem(obj, toolsMenu, SelectTool(@PickValueOrColor), 'Pick Current Value/Color');
        addMenuItem(obj, toolsMenu, PlotLabelMapCurvesFromTable(), 'Plot Curves From Labels...', true);
        action = SelectTool(@PlotImage3DZProfile);
        addMenuItem(obj, toolsMenu, action,  'Plot Image3D Z-Profile');
        action = SelectTool(@PlotVectorImageChannels);
        addMenuItem(obj, toolsMenu, action,  'Plot Vector Image Channels');
        
        
        % Analyze Menu Definition
        
        analyzeMenu = addMenu(obj, hf, 'Analyze');
        
        addMenuItem(obj, analyzeMenu, SetImageScale(),      'Set Image Scale');
        addMenuItem(obj, analyzeMenu, MeasureWithinSelection(), 'Measure Within Selection', ...
            'Accelerator', 'M');
        addMenuItem(obj, analyzeMenu, ShowImageHistogram(), 'Histogram', ...
            'Accelerator', 'H');
        addMenuItem(obj, analyzeMenu, VectorImageJointHistogram(), 'Joint Histogram...');

        addMenuItem(obj, analyzeMenu, PlotImageLineProfile(), 'Plot Line Profile', ...
            'Accelerator', 'K', 'Separator', 'on');
        addMenuItem(obj, analyzeMenu, AnalyzeImageRegions(), 'Analyze Regions', 'Separator', 'on');
        
        
        % Help menu definition
        helpMenu = addMenu(obj, hf, 'Help');
        
        addMenuItem(obj, helpMenu, ...
            imagem.actions.GenericAction(...
            @(frm) printHistory(frm.Gui.App)), ...
            'Print History');
    end
    
    function buildTableFrameMenu(obj, hf)
        
        import imagem.gui.ImagemGUI;
        import imagem.gui.actions.*;
        import imagem.actions.*;
        import imagem.actions.file.*;
        import imagem.actions.edit.*;
        import imagem.actions.image.*;
        import imagem.actions.table.*;
        import imagem.actions.table.file.*;
        import imagem.actions.table.edit.*;
        import imagem.actions.table.plot.*;
        import imagem.actions.table.pca.*;
        import imagem.actions.view.*;
        import imagem.actions.process.*;
        import imagem.actions.process.binary.*;
        import imagem.actions.analyze.*;
        import imagem.gui.tools.*;
        import imagem.tools.*;
        
        % File Menu Definition
        
        fileMenu = addMenu(obj, hf, 'Files');

        addMenuItem(obj, fileMenu, OpenTable(),              'Open Table...', 'Accelerator', 'O');
        addMenuItem(obj, fileMenu, SaveTable(),              'Save As...', ...
            'Separator', 'on', 'Accelerator', 'S');

        item = addMenuItem(obj, fileMenu, CloseFrame(),      'Close', 'Separator', 'on');
        set(item, 'Accelerator', 'W');

        item = addMenuItem(obj, fileMenu, Exit(), 'Quit');
        set(item, 'Accelerator', 'Q');
        
        
        % Edit menu
        editMenu = addMenu(obj, hf, 'Edit');
        addMenuItem(obj, editMenu, RenameTable(), 'Rename...');
        addMenuItem(obj, editMenu, Transpose(), 'Transpose');
        addMenuItem(obj, editMenu, Concatenate(), 'Concatenate...');
        addMenuItem(obj, editMenu, SelectTableRows(), 'Select Rows...', 'Separator', 'On');
        addMenuItem(obj, editMenu, SelectTableColumns(), 'Select Columns...');
        addMenuItem(obj, editMenu, FoldTableToImage(), 'Fold Table To Image...', 'Separator', 'On');
        
        % Plot menu
        plotMenu = addMenu(obj, hf, 'Plot');
        addMenuItem(obj, plotMenu, ScatterPlot(), 'Scatter Plot...');
        addMenuItem(obj, plotMenu, ScatterGroups(), 'Scatter Groups...');
        addMenuItem(obj, plotMenu, BoxPlot(), 'Box Plot...', 'Separator', 'on');
        addMenuItem(obj, plotMenu, GroupBoxPlot(), 'Box Plot by Group...');
        addMenuItem(obj, plotMenu, PlotColumns(), 'Plot Columns...', 'Separator', 'on');
        addMenuItem(obj, plotMenu, PlotRows(), 'Plot Rows');
        addMenuItem(obj, plotMenu, ChoosePreferredPlotTypes(), 'Choose Preferred Plot Type...', 'Separator', 'on');
        
        % Process menu
        processMenu = addMenu(obj, hf, 'Process');
        addMenuItem(obj, processMenu, Pca(), 'PCA...');
        addMenuItem(obj, processMenu, TableKMeans(), 'K-Means...', 'Separator', 'On');
        

        % Help menu definition
        helpMenu = addMenu(obj, hf, 'Help');
        
        addMenuItem(obj, helpMenu, ...
            imagem.actions.GenericAction(...
            @(frm) printHistory(frm.Gui.App)), ...
            'Print History');
    end
    
    function menu = addMenu(obj, parent, label, varargin) %#ok<INUSL>
        % Add a new menu to the given figure or menu.
        % Computes the new level of the menu and adds it to item userdata.
        
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
    
    function item = addMenuItem(obj, menu, action, label, varargin)
        % Add a new menu item given as an "Action" instance.
        
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
            'Callback', @(src, evt) action.run(obj.Frame));
        
        % eventually add separator above item
        if separatorFlag
            set(item, 'Separator', 'On');
        end
        
        if isActivable(action, obj.Frame)
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

end % end classdef


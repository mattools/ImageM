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
        
        % File Menu Definition
        
        fileMenu = addMenu(obj, hf, 'Files');
        
        addMenuItem(obj, fileMenu, imagem.actions.file.CreateImage(),               'New Image...', 'Accelerator', 'N');
        addMenuItem(obj, fileMenu, imagem.actions.file.OpenImage(),                 'Open Image...', 'Accelerator', 'O');
        importMenu = addMenu(obj, fileMenu, 'Import');
        addMenuItem(obj, importMenu, imagem.actions.file.ImportImageFromBinaryFile(),   'Import from binary file...');
        addMenuItem(obj, importMenu, imagem.actions.file.ImportImageSeries(),           'Import Image Series...');
        addMenuItem(obj, importMenu, imagem.actions.file.ImportImageFromWorkspace(),    'Import From Workspace...');

        demoMenu = addMenu(obj, fileMenu, 'Open Demo', 'Separator', 'on');
        addMenuItem(obj, demoMenu, imagem.actions.file.OpenDemoImage('cameraman.tif'), 	'Cameraman (grayscale)');
        addMenuItem(obj, demoMenu, imagem.actions.file.OpenDemoImage('rice.png'),       'Rice (grayscale)');
        addMenuItem(obj, demoMenu, imagem.actions.file.OpenDemoImage('coins.png'),      'Coins (grayscale)');
        addMenuItem(obj, demoMenu, imagem.actions.file.OpenDemoImage('peppers.png'),    'Peppers (RGB)');
        addMenuItem(obj, demoMenu, imagem.actions.file.OpenDemoImage('mri.tif'),        'MRI Head (3D)');
        addMenuItem(obj, demoMenu, imagem.actions.file.OpenDemoImage('xylophone.mp4'),  'Xylophone (movie)');
        addMenuItem(obj, demoMenu, imagem.actions.file.OpenDemoImage('circles.png'),    'Circles (binary)');
        addMenuItem(obj, demoMenu, imagem.actions.file.OpenDemoImage('text.png'),       'Text (binary)');
        addMenuItem(obj, demoMenu, imagem.actions.table.OpenDemoTable('fisherIris.txt'), 'Fisher Iris (Table)', 'Separator', 'on');
        addMenuItem(obj, fileMenu, imagem.actions.table.OpenTable(),              'Open Table...');

        
        addMenuItem(obj, fileMenu, imagem.actions.file.SaveImage(),              'Save As...', ...
            'Separator', 'on', 'Accelerator', 'S');
        addMenuItem(obj, fileMenu, imagem.actions.file.ExportImageToWorkspace(), 'Export To Workspace...');

        item = addMenuItem(obj, fileMenu, imagem.actions.file.CloseFrame(),      'Close', 'Separator', 'on');
        set(item, 'Accelerator', 'W');

        item = addMenuItem(obj, fileMenu, imagem.actions.file.Exit(), 'Quit');
        set(item, 'Accelerator', 'Q');
        

        % Edit Menu Definition
        % (Management of selection and global settings)
        
        editMenu = addMenu(obj, hf, 'Edit');
        
        addMenuItem(obj, editMenu, imagem.actions.edit.SaveSelection(),         'Save Selection...');
        addMenuItem(obj, editMenu, imagem.actions.edit.CropImageSelection(),    'Crop Selection');
        
        addMenuItem(obj, editMenu, imagem.actions.edit.PrintImageDocList(),     'Print Image List', 'Separator', 'on');
        
        settingsMenu = addMenu(obj, editMenu, 'Settings', 'Separator', 'on');
        addMenuItem(obj, settingsMenu, imagem.actions.image.SetBrushSize(),           'Set Brush Size');
        addMenuItem(obj, settingsMenu, imagem.actions.image.SetBrushValue(),          'Set Brush Value');
        addMenuItem(obj, settingsMenu, imagem.actions.image.SetDefaultConnectivity(), 'Set Connectivity', 'Separator', 'on');
        

        % Image Menu Definition
        
        imageMenu = addMenu(obj, hf, 'Image');
        
        addMenuItem(obj, imageMenu, imagem.actions.image.PrintImageInfo(),       'Print info');
        addMenuItem(obj, imageMenu, imagem.actions.image.RenameImage(),          'Rename');
        addMenuItem(obj, imageMenu, imagem.actions.image.DuplicateImage(),       'Duplicate', 'Accelerator', 'D');
        
        calibMenu = addMenu(obj, imageMenu, 'Calibration', 'Separator', 'on');
        addMenuItem(obj, calibMenu, imagem.actions.image.EditSpatialCalibration(),   'Edit Spatial Calibration...');
        addMenuItem(obj, calibMenu, imagem.actions.image.ClearSpatialCalibration(),  'Clear Spatial Calibration');
        channelTypeMenu = addMenu(obj, calibMenu, 'Channel Display', 'Separator', 'on');
        addMenuItem(obj, channelTypeMenu, imagem.actions.image.SetChannelDisplayType('Curve'),   'Curve');
        addMenuItem(obj, channelTypeMenu, imagem.actions.image.SetChannelDisplayType('Bar'),     'Bar');
        addMenuItem(obj, channelTypeMenu, imagem.actions.image.SetChannelDisplayType('Stem'),    'Stem');
        addMenuItem(obj, calibMenu, imagem.actions.image.EditChannelNames(),         'Edit Channels Names...');
        
        convertTypeMenu = addMenu(obj, imageMenu,  'Set Image Type');
        addMenuItem(obj, convertTypeMenu, imagem.actions.image.ImageConvertType('binary'),    'Binary');
        addMenuItem(obj, convertTypeMenu, imagem.actions.image.ImageConvertType('grayscale'), 'Grayscale');
        addMenuItem(obj, convertTypeMenu, imagem.actions.image.ImageConvertType('intensity'), 'Intensity');
        addMenuItem(obj, convertTypeMenu, imagem.actions.image.ImageConvertType('label'),     'Label');
                
        convertMenu = addMenu(obj, imageMenu,  'Convert Data Type');
        addMenuItem(obj, convertMenu, imagem.actions.image.ConvertDataType('uint8'),        'UInt8 (Grayscale)');
        addMenuItem(obj, convertMenu, imagem.actions.image.ConvertDataType('uint16'),       'UInt16 (Grayscale)');
        addMenuItem(obj, convertMenu, imagem.actions.image.ConvertDataType('single'),       'Single (Intensity)');
        

        convertMenu = addMenu(obj, imageMenu, 'Convert', 'Separator', 'on');
        addMenuItem(obj, convertMenu, imagem.actions.image.ConvertRGBImageToGrayscale(),    'RGB to Grayscale');
        addMenuItem(obj, convertMenu, imagem.actions.image.ConvertImage3DToVectorImage(),   '3D Image to Vector Image');
        addMenuItem(obj, convertMenu, imagem.actions.image.ConvertVectorImageToImage3D(),   'Vector Image to 3D Image');
        addMenuItem(obj, convertMenu, imagem.actions.image.ConvertVectorImageToRGB(),       'Vector Image to RGB');
        addMenuItem(obj, convertMenu, imagem.actions.image.ConvertScalarImageToRGB(),       'Intensity Image to RGB', 'Separator', 'on');
        addMenuItem(obj, convertMenu, imagem.actions.image.UnfoldVectorImage(),             'Unfold Vector Image to Table', 'Separator', 'on');
        addMenuItem(obj, convertMenu, imagem.actions.image.UnfoldVectorImageWithMask(),     'Unfold Vector Image Within Mask to Table...');
        
        colorMenu = addMenu(obj, imageMenu, 'Color and channels');
        addMenuItem(obj, colorMenu, imagem.actions.image.SplitImageRGB(),        'Split RGB');
        addMenuItem(obj, colorMenu, imagem.actions.image.SplitImageChannels(),   'Split Channels');
        addMenuItem(obj, colorMenu, imagem.actions.image.MergeImageChannels(),   'Merge Channels...');
        addMenuItem(obj, colorMenu, imagem.actions.image.ReorderChannels(),      'Re-order Channels...', true);
        
        
        transformMenu = addMenu(obj, imageMenu, 'Transfom');
        addMenuItem(obj, transformMenu, imagem.actions.image.ReshapeImage(),         'Reshape...');
        addMenuItem(obj, transformMenu, imagem.actions.image.PermuteDimensions(),    'Permute Dimensions...');
        
        addMenuItem(obj, transformMenu, imagem.actions.image.FlipImage(1),           'Horizontal Flip', 'Separator', 'on');
        addMenuItem(obj, transformMenu, imagem.actions.image.FlipImage(2),           'Vertical Flip');
        addMenuItem(obj, transformMenu, imagem.actions.image.RotateImage90(1),       'Rotate Right');
        addMenuItem(obj, transformMenu, imagem.actions.image.RotateImage90(-1),      'Rotate Left');
        addMenuItem(obj, transformMenu, imagem.actions.process.ImageOrthogonalProjection(),    'Orthogonal Projection', 'Separator', 'on');

        addMenuItem(obj, imageMenu, imagem.actions.image.ExtractSlice(),         'Extract Slice');
        addMenuItem(obj, imageMenu, imagem.actions.image.ExtractFrame(),         'Extract Time Frame');

        addMenuItem(obj, imageMenu, imagem.actions.image.InvertImage(),          'Invert Image', 'Accelerator', 'I');

        overlayMenu = addMenu(obj, imageMenu, 'Overlay', 'Separator', 'on');
        addMenuItem(obj, overlayMenu, imagem.actions.image.ClearImageOverlay(),   'Clear Overlays');
        
        
        % View Menu Definition
        
        viewMenu = addMenu(obj, hf, 'View');

        addMenuItem(obj, viewMenu, imagem.actions.view.ImageSetDisplayRange(),  'Set Display Range...');

        lutMenu = addMenu(obj, viewMenu, 'Color Maps');
        addMenuItem(obj, lutMenu, imagem.actions.view.SetImageColorMap('gray'),           'Gray');
        addMenuItem(obj, lutMenu, imagem.actions.view.SetImageColorMap('inverted'),       'Inverted');
        addMenuItem(obj, lutMenu, imagem.actions.view.SetImageColorMap('blue-gray-red'),  'Blue-Gray-Red');
        
        addMenuItem(obj, lutMenu, imagem.actions.view.SetImageColorMap('parula'),         'Parula', 'Separator', 'on');
        addMenuItem(obj, lutMenu, imagem.actions.view.SetImageColorMap('hsv'),            'HSV');
        addMenuItem(obj, lutMenu, imagem.actions.view.SetImageColorMap('colorcube'),      'Color Cube');
        addMenuItem(obj, lutMenu, imagem.actions.view.SetImageColorMap('prism'),          'Prism');
        addMenuItem(obj, lutMenu, imagem.actions.view.SetImageColorMap('jet'),            'Jet');
        addMenuItem(obj, lutMenu, imagem.actions.view.SetImageColorMap('blue-white-red'), 'Blue-White-Red');
        
        matlabLutMenu = addMenu(obj, lutMenu, 'Matlab''s');
        addMenuItem(obj, matlabLutMenu, imagem.actions.view.SetImageColorMap('hot'),      'Hot');
        addMenuItem(obj, matlabLutMenu, imagem.actions.view.SetImageColorMap('cool'),     'Cool');
        addMenuItem(obj, matlabLutMenu, imagem.actions.view.SetImageColorMap('spring'),   'Spring');
        addMenuItem(obj, matlabLutMenu, imagem.actions.view.SetImageColorMap('summer'),   'Summer');
        addMenuItem(obj, matlabLutMenu, imagem.actions.view.SetImageColorMap('winter'),   'Winter');
        addMenuItem(obj, matlabLutMenu, imagem.actions.view.SetImageColorMap('autumn'),   'Autumn');
        addMenuItem(obj, matlabLutMenu, imagem.actions.view.SetImageColorMap('copper'),   'Copper');
        addMenuItem(obj, matlabLutMenu, imagem.actions.view.SetImageColorMap('bone'),     'Bone');
        addMenuItem(obj, matlabLutMenu, imagem.actions.view.SetImageColorMap('pink'),     'Pink');
        addMenuItem(obj, matlabLutMenu, imagem.actions.view.SetImageColorMap('lines'),    'Lines');
        
        colorLutMenu = addMenu(obj, lutMenu, 'Simple Colors');
        addMenuItem(obj, colorLutMenu, imagem.actions.view.SetImageColorMap('blue'),      'Blue');
        addMenuItem(obj, colorLutMenu, imagem.actions.view.SetImageColorMap('red'),       'Red');
        addMenuItem(obj, colorLutMenu, imagem.actions.view.SetImageColorMap('green'),     'Green');
        addMenuItem(obj, colorLutMenu, imagem.actions.view.SetImageColorMap('cyan'),      'Cyan');
        addMenuItem(obj, colorLutMenu, imagem.actions.view.SetImageColorMap('yellow'),    'Yellow');
        addMenuItem(obj, colorLutMenu, imagem.actions.view.SetImageColorMap('magenta'),   'Magenta');
        
        addMenuItem(obj, viewMenu, imagem.actions.view.SetBackgroundColor(),  'Set Background Color...');

        
        addMenuItem(obj, viewMenu, imagem.actions.view.ZoomIn(),         'Zoom In', true);
        addMenuItem(obj, viewMenu, imagem.actions.view.ZoomOut(),        'Zoom Out');
        addMenuItem(obj, viewMenu, imagem.actions.view.ZoomOne(),        'Zoom 1:1');
        addMenuItem(obj, viewMenu, imagem.actions.view.ZoomBestFit(),    'Zoom Best');
        
        zoomsMenu = addMenu(obj, viewMenu, 'Others');
        addMenuItem(obj, zoomsMenu, imagem.actions.view.SetCurrentZoomLevel(8),     'Zoom 8:1');
        addMenuItem(obj, zoomsMenu, imagem.actions.view.SetCurrentZoomLevel(4),     'Zoom 4:1');
        addMenuItem(obj, zoomsMenu, imagem.actions.view.SetCurrentZoomLevel(2),     'Zoom 2:1');
        addMenuItem(obj, zoomsMenu, imagem.actions.view.SetCurrentZoomLevel(1),     'Zoom 1:1');
        addMenuItem(obj, zoomsMenu, imagem.actions.view.SetCurrentZoomLevel(1/2),   'Zoom 1:2');
        addMenuItem(obj, zoomsMenu, imagem.actions.view.SetCurrentZoomLevel(1/4),   'Zoom 1:4');
        addMenuItem(obj, zoomsMenu, imagem.actions.view.SetCurrentZoomLevel(1/8),   'Zoom 1:8');

        zoomModesMenu = addMenu(obj, viewMenu, 'Zoom Mode');
        adjustZoomAction = imagem.actions.view.SetZoomMode('adjust');
        mi1 = addMenuItem(obj, zoomModesMenu, adjustZoomAction, 'Adjust', 'Checked', 'on');
        setMenuItem(adjustZoomAction, mi1);
        
        fixedZoomAction = imagem.actions.view.SetZoomMode('fixed');
        mi2 = addMenuItem(obj, zoomModesMenu, fixedZoomAction,  'Fixed');
        setMenuItem(fixedZoomAction, mi2);
        
        % also create a group to toggle only one zoom mode option
        actionGroup = [adjustZoomAction fixedZoomAction];
        for iAction = 1:2
            action = actionGroup(iAction);
            setActionGroup(action, actionGroup);
        end
        
        addMenuItem(obj, viewMenu, imagem.actions.view.ShowImage3DOrthoSlices(),    'Show 3D OrthoSlices...', ...
            'Separator', 'on');
        addMenuItem(obj, viewMenu, imagem.actions.view.Image3DIsosurface(),         'Show 3D Isosurface...');
                
        
        % Process Menu Definition
        
        processMenu = addMenu(obj, hf, 'Process');
        
        addMenuItem(obj, processMenu, imagem.actions.process.AdjustImageDynamic(),  'Adjust Dynamic');
        addMenuItem(obj, processMenu, imagem.actions.process.ImageReplaceValue(),   'Replace Value(s)...');

%         filtersMenu = addMenu(obj, processMenu, 'Filters', 'Separator', 'on');

        addMenuItem(obj, processMenu, imagem.actions.process.ImageBoxMeanFilter(),  'Box Mean Filter...', 'Separator', 'on');
        addMenuItem(obj, processMenu, imagem.actions.process.ImageMedianFilter(),   'Median Filter...');
        addMenuItem(obj, processMenu, imagem.actions.process.ImageGaussianFilter(), 'Gaussian Filter...');
        addMenuItem(obj, processMenu, imagem.actions.process.ImageMorphologicalFilter(), 'Morphological Filter...');    
        
        addMenuItem(obj, processMenu, imagem.actions.process.ImageGradient(),       'Gradient', ...
            'Separator', 'on', 'Accelerator', 'G');
        addMenuItem(obj, processMenu, imagem.actions.process.ImageGradientVector(), 'Gradient Vector');
        addMenuItem(obj, processMenu, imagem.actions.process.VectorImageNorm(),     'Norm');
        
        % several operators based on connectivity (and reconstruction)
        connectOpMenu = addMenu(obj, processMenu, 'Connectivity-based Operators', 'Separator', 'on');
        addMenuItem(obj, connectOpMenu, imagem.actions.process.ImageMorphologicalReconstruction(), 'Morphological Reconstruction...');    
        addMenuItem(obj, connectOpMenu, imagem.actions.process.KillImageBorders(),    'Kill Borders', 'Separator', 'On');
        addMenuItem(obj, connectOpMenu, imagem.actions.process.FillImageHoles(),      'Fill Holes');
        addMenuItem(obj, connectOpMenu, imagem.actions.process.ImageRegionalMinima(), 'Regional Minima', 'Separator', 'on');
        addMenuItem(obj, connectOpMenu, imagem.actions.process.ImageRegionalMaxima(), 'Regional Maxima');
        addMenuItem(obj, connectOpMenu, imagem.actions.process.ImageExtendedMinima(), 'Extended Minima...');
        addMenuItem(obj, connectOpMenu, imagem.actions.process.ImageExtendedMaxima(), 'Extended Maxima...');
        addMenuItem(obj, connectOpMenu, imagem.actions.process.ImageImposeMinima(),   'Impose Minima...');
        
        % Threshold sub-menu
        addMenuItem(obj, processMenu, imagem.actions.process.ImageThreshold(),      'Manual Threshold...', ...
            'Separator', 'on', 'Accelerator', 'T');
        addMenuItem(obj, processMenu, imagem.actions.process.ImageAutoThresholdOtsu(), 'Auto Threshold (Otsu)');
        addMenuItem(obj, processMenu, imagem.actions.process.ImageMaxEntropyThreshold(),   'Auto Threshold (Max Entropy)');
        addMenuItem(obj, processMenu, imagem.actions.process.ImageKMeansSegmentation(),    'K-Means Segmentation');
        addMenuItem(obj, processMenu, imagem.actions.process.ImageWatershed(),      'Watershed...');
        addMenuItem(obj, processMenu, imagem.actions.process.ImageExtendedMinWatershed(),  'Extended Min Watershed...');
        
        addMenuItem(obj, processMenu, imagem.actions.process.ImageValuesTransform(), 'Image Values Transform...', true);
        addMenuItem(obj, processMenu, imagem.actions.process.ImageMathematic(),     'Image Maths (Image+Value)...');
        addMenuItem(obj, processMenu, imagem.actions.process.ImageArithmetic(),     'Image Maths (Image+Image)...');
        
        binaryMenu = addMenu(obj, processMenu, 'Binary / Label Images', 'Separator', 'On');
        addMenuItem(obj, binaryMenu, imagem.actions.process.binary.ConnectedComponentsLabeling(),  'Connected Components Labeling');
        addMenuItem(obj, binaryMenu, imagem.actions.process.binary.ImageAreaOpening(),    'Area Opening');
        addMenuItem(obj, binaryMenu, imagem.actions.process.binary.KeepLargestRegion(),   'Keep Largest Region');

        addMenuItem(obj, binaryMenu, imagem.actions.process.ApplyImageFunction('distanceMap'), 'Distance Map');
        addMenuItem(obj, binaryMenu, imagem.actions.process.binary.GeodesicDistanceMap(), 'Geodesic Distance Map');
        addMenuItem(obj, binaryMenu, imagem.actions.process.binary.ImageSkeleton(),       'Skeleton');
        
        addMenuItem(obj, binaryMenu, imagem.actions.process.binary.ImageBooleanOp(),      'Boolean Operation...', true);
        addMenuItem(obj, binaryMenu, imagem.actions.process.binary.BinaryImageOverlay(),  'Image Overlay...');
        addMenuItem(obj, binaryMenu, imagem.actions.process.ImageLabelToRgb(),      'Label To RGB...');
        addMenuItem(obj, binaryMenu, imagem.actions.process.CreateLabelValuesMap(), 'Create Label Values Map...');
        
        
        % Interactive tools
        
        toolsMenu = addMenu(obj, hf, 'Tools');
        
        addMenuItem(obj, toolsMenu, imagem.actions.SelectTool(@imagem.tools.PrintCurrentPointPosition), 'Print Current Point');
        addMenuItem(obj, toolsMenu, imagem.actions.SelectTool(@imagem.tools.ScrollImagePosition),        'Scroll Image');
        
        addMenuItem(obj, toolsMenu, imagem.actions.SelectTool(@imagem.tools.SelectRectangle),  'Select Rectangle', true);
        addMenuItem(obj, toolsMenu, imagem.actions.SelectTool(@imagem.tools.SelectPoints),     'Select Points');
        addMenuItem(obj, toolsMenu, imagem.actions.SelectTool(@imagem.tools.SelectPolyline),   'Select Polyline');
        addMenuItem(obj, toolsMenu, imagem.actions.SelectTool(@imagem.tools.SelectPolygon),    'Select Polygon');
        addMenuItem(obj, toolsMenu, imagem.actions.SelectTool(@imagem.tools.SelectLineSegment),'Select Line Segment');

        addMenuItem(obj, toolsMenu, imagem.actions.SelectTool(@imagem.tools.SetPixelToWhite), ...
            'Set Pixel to White', true);
        
        addMenuItem(obj, toolsMenu, imagem.actions.SelectTool(@imagem.tools.Brush),            'Brush');
        addMenuItem(obj, toolsMenu, imagem.actions.SelectTool(@imagem.tools.FloodFillTool),    'Flood Fill');
        addMenuItem(obj, toolsMenu, imagem.actions.SelectTool(@imagem.tools.PickValueOrColor), 'Pick Current Value/Color');
        addMenuItem(obj, toolsMenu, imagem.actions.view.PlotLabelMapCurvesFromTable(), 'Plot Curves From Labels...', true);
        action = imagem.actions.SelectTool(@imagem.tools.PlotImage3DZProfile);
        addMenuItem(obj, toolsMenu, action,  'Plot Image3D Z-Profile');
        action = imagem.actions.SelectTool(@imagem.tools.PlotVectorImageChannels);
        addMenuItem(obj, toolsMenu, action,  'Plot Vector Image Channels');
        
        
        % Analyze Menu Definition
        
        analyzeMenu = addMenu(obj, hf, 'Analyze');
        
        addMenuItem(obj, analyzeMenu, imagem.actions.analyze.SetImageScale(),      'Set Image Scale');
        addMenuItem(obj, analyzeMenu, imagem.actions.SelectTool(@imagem.tools.InteractivePointMeasure), 'Measure Points');
        addMenuItem(obj, analyzeMenu, imagem.actions.analyze.MeasureWithinSelection(), 'Measure Within Selection', ...
            'Accelerator', 'M');
        addMenuItem(obj, analyzeMenu, imagem.actions.analyze.ShowImageHistogram(), 'Histogram', ...
            'Accelerator', 'H');
        addMenuItem(obj, analyzeMenu, imagem.actions.analyze.VectorImageJointHistogram(), 'Joint Histogram...');

        addMenuItem(obj, analyzeMenu, imagem.actions.analyze.PlotImageLineProfile(), 'Plot Line Profile', ...
            'Accelerator', 'K', 'Separator', 'on');
        addMenuItem(obj, analyzeMenu, imagem.actions.analyze.AnalyzeImageRegions(), 'Analyze Regions...', 'Separator', 'on');
        addMenuItem(obj, analyzeMenu, imagem.actions.analyze.AverageValueByRegion(), 'Average Value by Region...');
        
        
        % Help menu definition
        helpMenu = addMenu(obj, hf, 'Help');
        
        addMenuItem(obj, helpMenu, ...
            imagem.actions.GenericAction(...
            @(frm) printHistory(frm.Gui.App)), ...
            'Print History');
    end
    
    function buildTableFrameMenu(obj, hf)
        
        % File Menu Definition
        
        fileMenu = addMenu(obj, hf, 'Files');

        addMenuItem(obj, fileMenu, imagem.actions.table.OpenTable(),              'Open Table...', 'Accelerator', 'O');
        addMenuItem(obj, fileMenu, imagem.actions.table.file.SaveTable(),         'Save As...', ...
            'Separator', 'on', 'Accelerator', 'S');

        item = addMenuItem(obj, fileMenu, imagem.actions.file.CloseFrame(),      'Close', 'Separator', 'on');
        set(item, 'Accelerator', 'W');

        item = addMenuItem(obj, fileMenu, imagem.actions.file.Exit(), 'Quit');
        set(item, 'Accelerator', 'Q');
        
        
        % Edit menu
        editMenu = addMenu(obj, hf, 'Edit');
        addMenuItem(obj, editMenu, imagem.actions.table.edit.RenameTable(), 'Rename...');
        addMenuItem(obj, editMenu, imagem.actions.table.edit.Transpose(), 'Transpose');
        addMenuItem(obj, editMenu, imagem.actions.table.edit.Concatenate(), 'Concatenate...');
        addMenuItem(obj, editMenu, imagem.actions.table.edit.SelectTableRows(), 'Select Rows...', 'Separator', 'On');
        addMenuItem(obj, editMenu, imagem.actions.table.edit.SelectTableColumns(), 'Select Columns...');
        addMenuItem(obj, editMenu, imagem.actions.table.edit.FilterFromColumnValues(), 'Filter From Column Values...');
        addMenuItem(obj, editMenu, imagem.actions.table.FoldTableToImage(), 'Fold Table To Image...', 'Separator', 'On');
        
        % Plot menu
        plotMenu = addMenu(obj, hf, 'Plot');
        addMenuItem(obj, plotMenu, imagem.actions.table.plot.PlotColumnHistogram(), 'Histogram...');
        addMenuItem(obj, plotMenu, imagem.actions.table.plot.BoxPlot(), 'Box Plot...', 'Separator', 'on');
        addMenuItem(obj, plotMenu, imagem.actions.table.plot.GroupBoxPlot(), 'Box Plot by Group...');
        addMenuItem(obj, plotMenu, imagem.actions.table.plot.ViolinPlot(), 'Violin Plot...');
        addMenuItem(obj, plotMenu, imagem.actions.table.plot.ScatterPlot(), 'Scatter Plot...', 'Separator', 'On');
        addMenuItem(obj, plotMenu, imagem.actions.table.plot.ScatterGroups(), 'Scatter Groups...');
        addMenuItem(obj, plotMenu, imagem.actions.table.plot.PairPlot(), 'Pair Plot...');
        addMenuItem(obj, plotMenu, imagem.actions.table.plot.PlotCorrelationCircles(), 'Correlation Circles...');
        addMenuItem(obj, plotMenu, imagem.actions.table.plot.PlotColumns(), 'Plot Columns...', 'Separator', 'on');
        addMenuItem(obj, plotMenu, imagem.actions.table.plot.PlotRows(), 'Plot Rows');
        addMenuItem(obj, plotMenu, imagem.actions.table.edit.ChoosePreferredPlotTypes(), 'Choose Preferred Plot Type...', 'Separator', 'on');
        
        % Process menu
        processMenu = addMenu(obj, hf, 'Process');
        addMenuItem(obj, processMenu, imagem.actions.table.process.Pca(), 'Principal Components Analysis (PCA)...');
        addMenuItem(obj, processMenu, imagem.actions.table.process.Nmf(), 'Non-Negative Matrix Factorization (NMF)...');
        addMenuItem(obj, processMenu, imagem.actions.table.process.TableKMeans(), 'K-Means...', 'Separator', 'On');
        

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

%% Toolbar creation
methods
    function buildToolbar(obj, hf)
        toolbar = uitoolbar(hf);
        
        % select rectangle
        [img, map] = imread(fullfile(matlabroot,...
            'toolbox', 'matlab', 'icons', 'tool_rectangle.gif'));
        cdata = ind2rgb(img, map);
        pt = uipushtool(toolbar, ...
            'CData', cdata, ...
            'Tooltip', 'Select Rectangle');
        action = imagem.actions.SelectTool(@imagem.tools.SelectRectangle);
        pt.ClickedCallback = @(src, evt) action.run(obj.Frame);
        
        % select line
        img = imread(fullfile('+imagem', '+gui', '+icons', 'points.png'));
        pt = uipushtool(toolbar, ...
            'CData', img, ...
            'Tooltip', 'Select Points');
        action = imagem.actions.SelectTool(@imagem.tools.SelectPoints);
        pt.ClickedCallback = @(src, evt) action.run(obj.Frame);
        
        % select line segment
        img = imread(fullfile('+imagem', '+gui', '+icons', 'lineSegment.png'));
        pt = uipushtool(toolbar, ...
            'CData', img, ...
            'Tooltip', 'Select Line Segment');
        action = imagem.actions.SelectTool(@imagem.tools.SelectLineSegment);
        pt.ClickedCallback = @(src, evt) action.run(obj.Frame);
        
        % select polyline
        img = imread(fullfile('+imagem', '+gui', '+icons', 'polyline.png'));
        pt = uipushtool(toolbar, ...
            'CData', img, ...
            'Tooltip', 'Select PolyLine');
        action = imagem.actions.SelectTool(@imagem.tools.SelectPolyline);
        pt.ClickedCallback = @(src, evt) action.run(obj.Frame);
        
        % select polygon
        img = imread(fullfile('+imagem', '+gui', '+icons', 'polygon.png'));
        pt = uipushtool(toolbar, ...
            'CData', img, ...
            'Tooltip', 'Select Polygon');
        action = imagem.actions.SelectTool(@imagem.tools.SelectPolygon);
        pt.ClickedCallback = @(src, evt) action.run(obj.Frame);
        
        % select brush
        [img, map] = imread(fullfile(matlabroot,...
            'toolbox', 'matlab', 'icons', 'paintbrush.gif'));
        cdata = ind2rgb(img, map);
        pt = uipushtool(toolbar, ...
            'CData', cdata, ...
            'Tooltip', 'Select Brush tool');
        action = imagem.actions.SelectTool(@imagem.tools.Brush);
        pt.ClickedCallback = @(src, evt) action.run(obj.Frame);

        % select flood-fill
        [img, map] = imread(fullfile(matlabroot,...
            'toolbox', 'matlab', 'icons', 'tool_facecolor.gif'));
        cdata = ind2rgb(img, map);
        pt = uipushtool(toolbar, ...
            'CData', cdata, ...
            'Tooltip', 'Flood-Fill');
        action = imagem.actions.SelectTool(@imagem.tools.FloodFillTool);
        pt.ClickedCallback = @(src, evt) action.run(obj.Frame);
    end
end

end % end classdef


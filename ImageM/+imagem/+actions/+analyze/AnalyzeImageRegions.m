classdef AnalyzeImageRegions < imagem.actions.LabelImageAction
% Compute geometrical descriptors of particles.
%
%   output = AnalyzeImageRegions(input)
%
%   Example
%   ImageAnalyzeParticlesAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-11-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    % liste of handles to widgets
    Handles;
    
    Viewer;
    
%     % the name of the image to draw overlay
%     overlayImageName = '';
%     
%     % the type of overlay to display
%     overlayType = 'Ellipses';
    
    % the list of available overlay types
    OverlayTypeValues = {'None', 'Ellipses', 'Boxes'};
end


methods
    function obj = AnalyzeImageRegions()
    end
end

methods
    function run(obj, frame)
        disp('analyze regions');
        
        % setup display
        obj.Viewer = frame;
        
        % choose dialog accoding to image dimension
        nd = ndims(currentImage(obj.Viewer));
        if nd == 2
            createFigure2d(obj);
        elseif nd == 3
            createFigure3d(obj);
        else
            error('Can process only dimensions 2 and 3');
        end
    end
    
    function tab = computeFeatures2d(obj)
        % compute the selected features on the current image and return table 
        
        % get current image
        img = currentImage(obj.Viewer);
        
        % identify features to compute
        areaFlag        = get(obj.Handles.AreaCheckBox, 'Value');
        perimeterFlag   = get(obj.Handles.PerimeterCheckBox, 'Value');
        eulerFlag       = get(obj.Handles.EulerCheckBox, 'Value');
        shapeFactorFlag = get(obj.Handles.ShapeFactorCheckBox, 'Value');
        
        centroidFlag    = get(obj.Handles.CentroidCheckBox, 'Value');
        ellipseFlag     = get(obj.Handles.EquivEllipseCheckBox, 'Value');
        ellipseElongFlag    = get(obj.Handles.EllipseElongationCheckBox, 'Value');
        
        feretDiameterFlag   = get(obj.Handles.FeretDiameterCheckBox, 'Value');
        orientedBoxFlag = get(obj.Handles.OrientedBoxCheckBox, 'Value');
        boxElongFlag    = get(obj.Handles.BoxElongationCheckBox, 'Value');
        
        geodDiamFlag    = get(obj.Handles.GeodesicDiameterCheckBox, 'Value');
        maxInnerRadiusFlag    = get(obj.Handles.MaxInnerRadiusCheckBox, 'Value');
        geodElongFlag   = get(obj.Handles.GeodesicElongationCheckBox, 'Value');
        tortuosityFlag  = get(obj.Handles.TortuosityCheckBox, 'Value');
        
        % retrieve image data
        imgData = img.Data';
        spacing = img.Spacing;
        origin  = img.Origin;
        
        % initialize empty table
        labels = imFindLabels(imgData);
        tab = Table(labels, {'Label'});
        
        % process global size features
        if areaFlag || shapeFactorFlag
            areaList = imArea(imgData, labels, spacing);
            tab = [tab Table(areaList, {'Area'})];
        end
        if perimeterFlag || shapeFactorFlag
            perimeterList = imPerimeter(imgData, labels, spacing);
            tab = [tab Table(perimeterList, {'Perimeter'})];
        end
        if eulerFlag
            tab = [tab Table(imEuler2d(imgData), {'EulerNumber'})];
        end
        if shapeFactorFlag
            shapeFactor = 4 * pi * areaList ./ perimeterList .^2;
            tab = [tab Table(shapeFactor, {'ShapeFactor'})];
        end

        % process moment-based features
        if centroidFlag || ellipseFlag || ellipseElongFlag
            elli = imEquivalentEllipse(imgData, spacing, origin, labels);
            
            if centroidFlag || ellipseFlag
                tab = [tab Table(elli(:,1:2), {'CentroidX', 'CentroidY'})];
            end
            if ellipseFlag
                tab = [tab Table(elli(:,3:4), {'EllipseRadius1', 'EllipseRadius2'})];
                tab = [tab Table(elli(:,5), {'EllipseOrientation'})];
            end
            if ellipseElongFlag
                elong = elli(:,3) ./ elli(:,4);
                tab = [tab Table(elong, {'EllipseElongation'})];
            end
        end
        
        % process feret diameter and oriented box features
        if feretDiameterFlag || tortuosityFlag
            feretDiams = imMaxFeretDiameter(imgData) * spacing(1);
            tab = [tab Table(feretDiams, {'FeretDiameter'})];
        end
        
        if orientedBoxFlag || boxElongFlag
            boxes = imOrientedBox(imgData, 'Spacing', spacing, 'Origin', origin);
            colNames = {'BoxCenterX', 'BoxCenterY', 'BoxLength', 'BoxWidth', 'BoxOrientation'};
            tab = [tab Table(boxes, colNames)];
            
            if boxElongFlag
                elong = boxes(:,3) ./ boxes(:,4);
                tab = [tab Table(elong, {'BoxElongation'})];
            end
        end
        
        % process geodesic diamter based features
        if geodDiamFlag || geodElongFlag || tortuosityFlag
            geodDiams = imGeodesicDiameter(imgData);
            geodDiams = geodDiams * spacing(1);
            tab = [tab Table(geodDiams, {'GeodesicDiameter'})];
        end
        
        if tortuosityFlag
            tortuosities = geodDiams ./ feretDiams;
            tab = [tab Table(tortuosities, {'Tortuosity'})];
        end
        
        if maxInnerRadiusFlag || geodElongFlag
            discs = imInscribedCircle(imgData);
            if maxInnerRadiusFlag
                colNames = {'InnerDiscCenterX', 'InnerDiscCenterY', 'InnerDiscRadius'};
                tab = [tab Table(discs, colNames)];
            end
            if geodElongFlag
                geodElong = geodDiams ./ discs(:, 3);
                tab = [tab Table(geodElong, {'GeodesicElongation'})];
            end
        end
        
        tab.Name = [img.Name '-features'];
    end

    function tab = computeFeatures3d(obj)
        % Compute the selected 3D features on the current image and return Table.
        
        % get current image
        img = currentImage(obj.Viewer);
        
        % identify features to compute
        volumeFlag          = get(obj.Handles.VolumeCheckBox, 'Value');
        surfaceAreaFlag     = get(obj.Handles.SurfaceAreaCheckBox, 'Value');
        meanBreadthFlag     = get(obj.Handles.MeanBreadthCheckBox, 'Value');
        eulerFlag           = get(obj.Handles.EulerNumberCheckBox, 'Value');
        sphericityFlag      = get(obj.Handles.SphericityCheckBox, 'Value');
        
        centroidFlag        = get(obj.Handles.CentroidCheckBox, 'Value');
        ellipsoidFlag       = get(obj.Handles.EllipsoidCheckBox, 'Value');
        ellipsoidShapeFlag  = get(obj.Handles.EllipsoidShapeCheckBox, 'Value');
        
        boundingBoxFlag     = get(obj.Handles.BoundingBoxCheckBox, 'Value');
%         convexVolumeFlag    = get(obj.Handles.ConvexVolumeCheckBox, 'Value');
        convexityFlag       = get(obj.Handles.ConvexityCheckBox, 'Value');
        
        
        % retrieve image data
        imgData = permute(img.Data, [2 1 3]);
        spacing = img.Spacing;
        origin  = img.Origin;
        
        % initialize empty table
        labels = imFindLabels(imgData);
        tab = Table(labels, {'Label'});
        
        % process global size features
        if volumeFlag || sphericityFlag
            volList = imVolume(imgData, labels, spacing);
            tab = [tab Table(volList, {'Volume'})];
        end
        if surfaceAreaFlag || sphericityFlag
            surfList = imSurfaceArea(imgData, labels, spacing);
            tab = [tab Table(surfList, {'SurfaceArea'})];
        end
        if meanBreadthFlag
            mbList = imMeanBreadth(imgData, labels, spacing);
            tab = [tab Table(mbList, {'MeanBreadth'})];
        end
        if eulerFlag
            tab = [tab Table(imEuler3d(imgData), {'EulerNumber'})];
        end
        if sphericityFlag
            shapeFactor = 36 * pi * volList.^2 ./ surfList .^3;
            tab = [tab Table(shapeFactor, {'Sphericity'})];
        end

        if boundingBoxFlag
            boxes = imBoundingBox(imgData, spacing, origin, labels);
            colNames = {'XMin', 'XMax', 'YMin', 'YMax', 'ZMin', 'ZMax'};
            tab = [tab Table(boxes, colNames)];
        end
        
        % process moment-based features
        if centroidFlag || ellipsoidFlag || ellipsoidShapeFlag
            elli = imEquivalentEllipsoid(imgData, spacing, origin, labels);
            
            if centroidFlag || ellipsoidFlag
                tab = [tab Table(elli(:,1:3), {'CentroidX', 'CentroidY', 'CentroidZ'})];
            end
            if ellipsoidFlag
                tab = [tab Table(elli(:,4:6), {'SemiAxis1', 'SemiAxis2', 'SemiAxis3'})];
                tab = [tab Table(elli(:,7:9), {'Phi', 'Theta', 'Psi'})];
            end
            if ellipsoidShapeFlag
                elongs = [elli(:,4) ./ elli(:,6), elli(:,4) ./ elli(:,5), elli(:,5) ./ elli(:,6)] ;
                tab = [tab Table(elongs, {'R1/R3', 'R1/R2', 'R2/R3'})];
            end
        end
        
        if convexityFlag
            convexityList = imConvexity(imgData, labels);
            tab = [tab Table(convexityList, {'Convexity'})];
        end
        
        tab.Name = [img.Name '-features'];
    end
end

methods
   
    function hf = createFigure2d(obj)
        % creates the figure for 2D images.
        
        hf = figure(...
            'Name', 'Analyze Regions 2D', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', ...
            'Toolbar', 'none', ...
            'CloseRequestFcn', @obj.closeFigure);
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = [250 300];
        set(hf, 'Position', pos);
        
        obj.Handles.Figure = hf;
        gui = obj.Viewer.Gui;
        
        % the list of images for choosing the overlay
        imageNames = getImageNames(gui.App);
        
        
        % vertical layout, containing main panel and buttons panel
        vb  = uix.VBox('Parent', hf, 'Spacing', 5, 'Padding', 5);
        
        mainPanel = uix.VBox('Parent', vb);
        
        featuresPanel = uix.Grid('Parent', mainPanel);
        
        
        % First column
        
        % global morphometry
        obj.Handles.AreaCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Area', ...
            'Value', 1);
        obj.Handles.PerimeterCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Perimeter', ...
            'Value', 1);
        obj.Handles.EulerCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Euler Number', ...
            'Value', 0);
        obj.Handles.ShapeFactorCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Shape Factor', ...
            'Value', 1);
        
        
        % geodesic parameters
        uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'Visible', 'Off');
        
        obj.Handles.GeodesicDiameterCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Geodesic Diameter');
        
        obj.Handles.MaxInnerRadiusCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Max. Inner Radius');
        
        obj.Handles.GeodesicElongationCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Geodesic Elongation');
        
        % some empty space
        uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'Visible', 'Off');
        
        
        % Second column
        
        % inertia-based  parameters
        obj.Handles.CentroidCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Centroid', ...
            'Value', 1);
        
        obj.Handles.EquivEllipseCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Equivalent Ellipse', ...
            'Value', 1);
        
        obj.Handles.EllipseElongationCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Ellipse Elongation', ...
            'Value', 1);
        
        
        % Feret diameters
        uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'Visible', 'Off');
        
        obj.Handles.FeretDiameterCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Feret Diameter', ...
            'Value', 1);
        
        obj.Handles.OrientedBoxCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Oriented Box', ...
            'Value', 1);
        
        obj.Handles.BoxElongationCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Box Elongation', ...
            'Value', 1);
        
        obj.Handles.TortuosityCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Tortuosity');
        
        
        % use same widths for all columns
        set(featuresPanel, 'Widths', [-1 -1]);
        set(featuresPanel, 'Heights', [20 20 20 20 20 20 20 20 20]);
        
        
        % add combo box for choosing region overlay options
        obj.Handles.OverlayTypePopup = addComboBoxLine(gui, mainPanel, ...
            'Overlay:', obj.OverlayTypeValues);
        set(obj.Handles.OverlayTypePopup, 'Value', 2);
        
        % add combo box for choosing the image to overlay
        obj.Handles.OverlayImagePopup = addComboBoxLine(gui, mainPanel, ...
            'Image to overlay:', imageNames);
        
        % setup image to overlay with current image index
        name = obj.Viewer.Doc.Image.Name;
        index = find(strcmp(name, imageNames), 1, 'last');
        set(obj.Handles.OverlayImagePopup, 'Value', index);
        
        % setup layout for all widgets but control panel
        set(mainPanel, 'Heights', [-1 35 35] );
        
        % button for control panel
        buttonsPanel = uix.HButtonBox('Parent', vb, 'Padding', 5);
        uicontrol('Parent', buttonsPanel, ...
            'String', 'OK', ...
            'Callback', @obj.onButtonOK);
        uicontrol('Parent', buttonsPanel, ...
            'String', 'Cancel', ...
            'Callback', @obj.onButtonCancel);
        
        set(vb, 'Heights', [-1  40] );
    end
    
    function hf = createFigure3d(obj)
        % creates the figure for 3D images.
        
        hf = figure(...
            'Name', 'Analyze Regions 3D', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', ...
            'Toolbar', 'none', ...
            'CloseRequestFcn', @obj.closeFigure);
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = [250 300];
        set(hf, 'Position', pos);
        
        obj.Handles.Figure = hf;        
        
        % vertical layout, containing main panel and buttons panel
        vb  = uix.VBox('Parent', hf, 'Spacing', 5, 'Padding', 5);
        
        mainPanel = uix.VBox('Parent', vb);
        
        featuresPanel = uix.Grid('Parent', mainPanel);
        
        
        % First column
        
        % global morphometry
        obj.Handles.VolumeCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Volume', ...
            'Value', 1);
        obj.Handles.SurfaceAreaCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Surface Area', ...
            'Value', 1);
        obj.Handles.MeanBreadthCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Mean Breadth', ...
            'Value', 0);
        obj.Handles.EulerNumberCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Euler Number', ...
            'Value', 0);
        obj.Handles.SphericityCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Sphericity', ...
            'Value', 0);
        
        
        % Second column
        
        % inertia-based  parameters
        obj.Handles.BoundingBoxCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Bounding Box', ...
            'Value', 1);

        % moment-based  parameters
        obj.Handles.CentroidCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Centroid', ...
            'Value', 1);
        
        obj.Handles.EllipsoidCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Equivalent Ellipsoid', ...
            'Value', 1);
        
        obj.Handles.EllipsoidShapeCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Ellipsoid Shapes', ...
            'Value', 0);
        
        % convexity
        obj.Handles.ConvexityCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Convexity', ...
            'Value', 0);

        
        % use same widths for all columns
        set(featuresPanel, 'Widths', [-1 -1]);
        set(featuresPanel, 'Heights', [20 20 20 20 20]);
        

        % setup layout for all widgets but control panel
        set(mainPanel, 'Heights', -1 );
%         set(mainPanel, 'Heights', [-1 35 35] );
        
        % button for control panel
        buttonsPanel = uix.HButtonBox('Parent', vb, 'Padding', 5);
        uicontrol('Parent', buttonsPanel, ...
            'String', 'OK', ...
            'Callback', @obj.onButtonOK3d);
        uicontrol('Parent', buttonsPanel, ...
            'String', 'Cancel', ...
            'Callback', @obj.onButtonCancel);
        
        set(vb, 'Heights', [-1  40] );
    end
 end


%% Control buttons Callback
methods
    function onButtonOK(obj, varargin)
        
        % compute morphological features
        tab = computeFeatures2d(obj);
        
        % extract type of overlay
        overlayTypeIndex = get(obj.Handles.OverlayTypePopup, 'Value');
        overlayType = obj.OverlayTypeValues{overlayTypeIndex};
        
        
        % get document on which add annotations
        gui = obj.Viewer.Gui;
        imageName = get(obj.Handles.OverlayImagePopup, 'Value');
        docToOverlay = getDocument(gui.App, imageName);
        
        closeFigure(obj);
        
        % display data table in its own window
        createTableFrame(obj.Viewer.Gui, tab);
        
        img = currentImage(obj.Viewer);
        spacing = img.Spacing;
        origin = img.Origin;
        
        switch lower(overlayType)
            case 'none'
                
            case 'boxes'
                boxes = imBoundingBox(img.Data', spacing, origin);
                nLabels = size(boxes, 1);
                for i = 1:nLabels
                    shape = struct(...
                        'Type', 'Box', ...
                        'Data', boxes(i,:), ...
                        'Style', {{'color', 'g'}});
                    addShape(docToOverlay, shape);
                end
                
            case 'ellipses'
                elli = imEquivalentEllipse(img.Data', spacing, origin);
                nLabels = size(elli, 1);
                for i = 1:nLabels
                    shape = struct(...
                        'Type', 'Ellipse', ...
                        'Data', elli(i,:), ...
                        'Style', {{'color', 'g'}});
                    addShape(docToOverlay, shape);
                end
                
            otherwise
                error(['Unable to process overlay type: ' overlayType]);
        end
        
        % update all the views referenced by the document with overlay
        viewList = getViews(docToOverlay);
        for i = 1:length(viewList)
            updateDisplay(viewList{i});
        end
        
    end
    
    function onButtonOK3d(obj, varargin)
        
        % compute morphological features
        tab = computeFeatures3d(obj);
                
        closeFigure(obj);
        
        % display data table in its own window
        createTableFrame(obj.Viewer.Gui, tab);
    end
    
    function onButtonCancel(obj, varargin)
        closeFigure(obj);
    end
    
    function closeFigure(obj, varargin)
        % close the current fig
        if ishandle(obj.Handles.Figure)
            delete(obj.Handles.Figure);
        end
    end
 end

end

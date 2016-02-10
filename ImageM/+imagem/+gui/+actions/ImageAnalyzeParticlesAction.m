classdef ImageAnalyzeParticlesAction < imagem.gui.actions.LabelImageAction
%IMAGEANALYZEPARTICLESACTION Compute geometrical descriptors of particles
%
%   output = ImageAnalyzeParticlesAction(input)
%
%   Example
%   ImageAnalyzeParticlesAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2011-11-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    % liste of handles to widgets
    handles;
    
%     % the name of the image to draw overlay
%     overlayImageName = '';
%     
%     % the type of overlay to display
%     overlayType = 'Ellipses';
    
    % the list of available overlay types
    overlayTypeValues = {'None', 'Ellipses', 'Boxes'};
end


methods
    function this = ImageAnalyzeParticlesAction(viewer, varargin)
        % calls the parent constructor
        this = this@imagem.gui.actions.LabelImageAction(viewer, 'imageAnalyzeParticles');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('analyze particles');
        
        % setup display
        createFigure(this);
    end
    
    function tab = computeFeatures(this)
        % compute the selected features on the current image and return table 
        
        % get current image
        img = this.viewer.doc.image;
        
        % identify features to compute
        areaFlag        = get(this.handles.areaCheckBox, 'Value');
        perimeterFlag   = get(this.handles.perimeterCheckBox, 'Value');
        eulerFlag       = get(this.handles.eulerCheckBox, 'Value');
        shapeFactorFlag = get(this.handles.shapeFactorCheckBox, 'Value');
        
        centroidFlag    = get(this.handles.centroidCheckBox, 'Value');
        ellipseFlag     = get(this.handles.inertiaEllipseCheckBox, 'Value');
        ellipseElongFlag    = get(this.handles.ellipseElongationCheckBox, 'Value');
        
        feretDiameterFlag   = get(this.handles.feretDiameterCheckBox, 'Value');
        orientedBoxFlag = get(this.handles.orientedBoxCheckBox, 'Value');
        boxElongFlag    = get(this.handles.boxElongationCheckBox, 'Value');
        
        geodDiamFlag    = get(this.handles.geodesicDiameterCheckBox, 'Value');
        maxInnerRadiusFlag    = get(this.handles.maxInnerRadiusCheckBox, 'Value');
        geodElongFlag   = get(this.handles.geodesicElongationCheckBox, 'Value');
        tortuosityFlag  = get(this.handles.tortuosityCheckBox, 'Value');
        
        % TODO: use spatial resolution
        resol = [1 1];
        
        % initialize empty table
        nLabels = length(unique(img(:))) - 1;
        tab = Table(zeros(nLabels, 0));
        
        % process global size features
        if areaFlag || shapeFactorFlag
            areaList = imArea(img.data', resol);
            tab = [tab Table(areaList, {'Area'})];
        end
        if perimeterFlag || shapeFactorFlag
            perimeterList = imPerimeter(img.data', resol);
            tab = [tab Table(perimeterList, {'Perimeter'})];
        end
        if eulerFlag
            tab = [tab Table(imEuler2d(img.data'), {'EulerNumber'})];
        end
        if shapeFactorFlag
            shapeFactor = 4 * pi * areaList ./ perimeterList .^2;
            tab = [tab Table(shapeFactor, {'ShapeFactor'})];
        end

        % process inertia-based features
        if centroidFlag || ellipseFlag || ellipseElongationFlag
            elli = imInertiaEllipse(img.data', resol);
            
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
            feretDiams = imMaxFeretDiameter(img.data') * resol(1);
            tab = [tab Table(feretDiams, {'FeretDiameter'})];
        end
        
        if orientedBoxFlag || boxElongFlag
            boxes = imOrientedBox(img.data', 'spacing', resol);
            colNames = {'BoxCenterX', 'BoxCenterY', 'BoxLength', 'BoxWidth', 'BoxOrientation'};
            tab = [tab Table(boxes, colNames)];
            
            if boxElongFlag
                elong = boxes(:,3) ./ boxes(:,4);
                tab = [tab Table(elong, {'BoxElongation'})];
            end
        end
        
        % process geodesic diamter based features
        if geodDiamFlag || geodElongFlag || tortuosityFlag
            geodDiams = imGeodesicDiameter(img.data');
            tab = [tab Table(geodDiams, {'GeodesicDiameter'})];
        end
        
        if tortuosityFlag
            tortuosities = geodDiams ./ feretDiams;
            tab = [tab Table(tortuosities, {'Tortuosity'})];
        end
        
        if maxInnerRadiusFlag || geodElongFlag
            discs = imInscribedCircle(img.data');
            
            if maxInnerRadiusFlag
                colNames = {'InnerDiscCenterX', 'InnerDiscCenterY', 'InnerDiscRadius'};
                tab = [tab Table(discs, colNames)];
            end
            if geodElongFlag
                geodElong = geodDiams ./ discs(:, 3);
                tab = [tab Table(geodElong, {'GeodesicElongation'})];
            end
        end
        
        tab.name = [img.name '-features'];
%         % extract parameters
%         props = regionprops(img.data', {...
%             'Area', 'Perimeter', 'Centroid', ...
%             'MajorAxisLength', 'MinorAxisLength', 'Orientation'});
% 
%         % format to column vectors
%         areas = [props.Area]';
%         perim = [props.Perimeter]';
%         centro = reshape([props.Centroid], 2, length(props))';
%         major = [props.MajorAxisLength]';
%         minor = [props.MinorAxisLength]';
%         theta = -[props.Orientation]';
        
% %         % create data table
% %         data = [areas perim centro major minor theta];
% %         tab = Table(data, 'colNames', ...
% %             {'Area', 'Perimeter', 'CentroidX', 'CentroidY', ...
% %             'MajorAxisLength', 'MinorAxisLength', 'Orientation'});

        % display data table in its own window
        show(tab);
        
%         % display overlay of ellipses
%         ellis = [centro major/2 minor/2 theta];
%         shape = struct(...
%             'type', 'ellipse', ...
%             'data', ellis, ...
%             'style', {{'-b', 'LineWidth', 1}});
%         this.viewer.doc.shapes = {shape};
        
        updateDisplay(this.viewer);
        
    end
end

methods
    function hf = createFigure(this)
        % creates the figure
        
        hf = figure(...
            'Name', 'Analysis Particles', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', ...
            'Toolbar', 'none', ...
            'CloseRequestFcn', @this.closeFigure);
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = [250 300];
        set(hf, 'Position', pos);
        
        this.handles.figure = hf;
        gui = this.viewer.gui;

        % the list of images for choosing the overlay
        imageNames = getImageNames(gui.app);
        

        % vertical layout, containing main panel and buttons panel
        vb  = uix.VBox('Parent', hf, 'Spacing', 5, 'Padding', 5);
        
        mainPanel = uix.VBox('Parent', vb);

        featuresPanel = uix.Grid('Parent', mainPanel);

        
        % First column
        
        % global morphometry
        this.handles.areaCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Area', ...
            'Value', 1);
        this.handles.perimeterCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Perimeter', ...
            'Value', 1);
        this.handles.eulerCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Euler Number', ...
            'Value', 0);
        this.handles.shapeFactorCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Shape Factor', ...
            'Value', 1);
        
        
        % geodesic parameters
        uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'Visible', 'Off');
        
        this.handles.geodesicDiameterCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Geodesic Diameter');
        
        this.handles.maxInnerRadiusCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Max. Inner Radius');
        
        this.handles.geodesicElongationCheckBox = uicontrol(...
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
        this.handles.centroidCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Centroid', ...
            'Value', 1);
        
        this.handles.inertiaEllipseCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Inertia Ellipse', ...
            'Value', 1);
        
        
        this.handles.ellipseElongationCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Ellipse Elongation', ...
            'Value', 1);
  
        
        % Feret diameters
        uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'Visible', 'Off');
        
        this.handles.feretDiameterCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Feret Diameter', ...
            'Value', 1);
        
        this.handles.orientedBoxCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Oriented Box', ...
            'Value', 1);
          
        this.handles.boxElongationCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Box Elongation', ...
            'Value', 1);
        
         this.handles.tortuosityCheckBox = uicontrol(...
            'Style', 'Checkbox', ...
            'Parent', featuresPanel, ...
            'String', 'Tortuosity');
        

        % use same widths for all columns
        set(featuresPanel, 'Widths', [-1 -1]);
        set(featuresPanel, 'Heights', [20 20 20 20 20 20 20 20 20]);
        
        
        % add combo box for choosing region overlay options
        this.handles.overlayTypePopup = addComboBoxLine(gui, mainPanel, ...
            'Overlay:', this.overlayTypeValues);
        set(this.handles.overlayTypePopup, 'Value', 2);
        
        % add combo box for choosing the image to overlay 
        this.handles.overlayImagePopup = addComboBoxLine(gui, mainPanel, ...
            'Image to overlay:', imageNames);
        
        % setup image to overlay with current image index
        name = this.viewer.doc.image.name;
        index = find(strcmp(name, imageNames));
        set(this.handles.overlayImagePopup, 'Value', index);
        
        % setup layout for all widgets but control panel
        set(mainPanel, 'Heights', [-1 35 35] );
        
        % button for control panel
        buttonsPanel = uix.HButtonBox('Parent', vb, 'Padding', 5);
        uicontrol('Parent', buttonsPanel, ...
            'String', 'OK', ...
            'Callback', @this.onButtonOK);
        uicontrol('Parent', buttonsPanel, ...
            'String', 'Cancel', ...
            'Callback', @this.onButtonCancel);
        
        set(vb, 'Heights', [-1  40] );

        
    end
end


%% Control buttons Callback
methods
    function onButtonOK(this, varargin)
        
        % compute morphological features
        tab = computeFeatures(this);
        
%         % display overlay of ellipses
%         ellis = [centro major/2 minor/2 theta];
%         shape = struct(...
%             'type', 'ellipse', ...
%             'data', ellis, ...
%             'style', {{'-b', 'LineWidth', 1}});
%         this.viewer.doc.shapes = {shape};

        % extract type of overlay
        overlayTypeIndex = get(this.handles.overlayTypePopup, 'Value');
        overlayType = this.overlayTypeValues{overlayTypeIndex};
        
        
        % get document on which add annotations
        gui = this.viewer.gui;
        imageName = get(this.handles.overlayImagePopup, 'Value');
        docToOverlay = getDocument(gui.app, imageName);

        
        closeFigure(this);

        % display data table in its own window
        show(tab);
        
        doc = this.viewer.doc;
        nLabels = max(doc.image.data(:));
        switch lower(overlayType)
            case 'none'
                
            case 'boxes'
                boxes = imBoundingBox(doc.image.data');
                for i = 1:nLabels
                    shape = struct(...
                        'type', 'box', ...
                        'data', boxes(i,:), ...
                        'style', {{'color', 'g'}});
                    addShape(docToOverlay, shape);
                end
                
            case 'ellipses'
                elli = imInertiaEllipse(doc.image.data');
                for i = 1:nLabels
                    shape = struct(...
                        'type', 'ellipse', ...
                        'data', elli(i,:), ...
                        'style', {{'color', 'g'}});
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
    
    function onButtonCancel(this, varargin)
        closeFigure(this);
    end
    
    function closeFigure(this, varargin)
        % close the current fig
        if ishandle(this.handles.figure)
            delete(this.handles.figure);
        end
    end
 end

end

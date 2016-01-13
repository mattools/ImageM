classdef ImageAreaOpeningAction < imagem.gui.actions.ScalarImageAction
%IMAGEAREAOPENINGACTION Keep only particles larger than a given area
%
%   output = ImageAreaOpeningAction(input)
%
%   Example
%   ImageAreaOpeningAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2012-02-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    % liste of handles to widgets
    handles;
    
    % the number of individual particles in original image
    labelMax = 255;
    
    % image of labeled particles (either original image, or result of labeling)
    labelImage;
    
    % the list of precomputed areas
    particleAreas;
    
    % the selected value for minimum area
    minAreaValue = 10;

    % the connectivity of the regions
    conn = 4;
    
    % the list of available connectivity values (constant)
    connValues = [4, 8];
end

methods
    function this = ImageAreaOpeningAction(viewer)
        % calls the parent constructor
        this = this@imagem.gui.actions.ScalarImageAction(viewer, 'areaOpening');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;
        
        if ~isScalarImage(doc.image)
            warning('ImageM:WrongImageType', ...
                'Area opening can only be applied on label or binary images');
            return;
        end
        
        % update inner state of the tool
        updateLabelImage(this);
        updateParticleAreaList(this);
        
        % setup display
        createFigure(this);
        updateWidgets(this);
    end
    
    function hf = createFigure(this)
        
        % range of particle areas
        areas = this.particleAreas;
        minVal = 0;
        maxVal = double(max(areas));
        this.labelMax = maxVal;
        
        % compute slider steps
        valExtent = maxVal + 1;
                
        % set unit step equal to 1 grayscale unit
        sliderStep1 = 1 / valExtent;
        sliderStep2 = 10 / valExtent;
        
        % startup threshold value
        sliderValue = minVal + valExtent / 2;

        % background color of most widgets
        bgColor = getWidgetBackgroundColor(this.viewer.gui);
        
        
        % creates the figure
        hf = figure(...
            'Name', 'Image Area Opening', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', ...
            'Toolbar', 'none', ...
            'CloseRequestFcn', @this.closeFigure);
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = [250 200];
        set(hf, 'Position', pos);
        
        this.handles.figure = hf;
        
        % vertical layout
        vb  = uix.VBox('Parent', hf, 'Spacing', 5, 'Padding', 5);
        mainPanel = uix.VBox('Parent', vb);
        
        gui = this.viewer.gui;
        
        this.handles.minAreaText = addInputTextLine(gui, mainPanel, ...
            'Minimum area:', '10', ...
            @this.onMinAreaTextChanged);
        
        % one slider for changing value
        this.handles.valueSlider = uicontrol(...
            'Style', 'Slider', ...
            'Parent', mainPanel, ...
            'Min', minVal, 'Max', maxVal, ...
            'Value', sliderValue, ...
            'SliderStep', [sliderStep1 sliderStep2], ...
            'BackgroundColor', bgColor, ...
            'Callback', @this.onSliderValueChanged);
        
        % setup listener for slider continuous changes
        addlistener(this.handles.valueSlider, ...
            'ContinuousValueChange', @this.onSliderValueChanged);
        
        % add combo box for choosing region connectivity
        [this.handles.connectivityPopup, ht] = addComboBoxLine(gui, mainPanel, ...
            'Connectivity:', {'4', '8'}, ...
            @this.onConnectivityChanged);
        
        % disable choice of connectivity for label images
        if isLabelImage(this.viewer.doc.image)
            set(this.handles.connectivityPopup, 'Enable', 'off');
            set(ht, 'Enable', 'off');
        end
            
        set(mainPanel, 'Heights', [35 25 35]);
        
        % button for control panel
        buttonsPanel = uix.HButtonBox('Parent', vb, 'Padding', 5);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'OK', ...
            'Callback', @this.onButtonOK);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'Cancel', ...
            'Callback', @this.onButtonCancel);
        
        set(vb, 'Heights', [-1 40] );
    end
        
    function closeFigure(this, varargin)
        % clean up viewer figure
        this.viewer.doc.previewImage = [];
        updateDisplay(this.viewer);
        
        % close the current fig
        if ishandle(this.handles.figure)
            delete(this.handles.figure);
        end
    end
    
    function updateWidgets(this)
        
        % update widget values
        val = this.minAreaValue;
        set(this.handles.minAreaText, 'String', num2str(val))
        set(this.handles.valueSlider, 'Value', val);
        
        % update preview image of the document
        bin = computeResultImage(this);
        doc = this.viewer.doc;
        doc.previewImage = overlay(doc.image, bin);
        updateDisplay(this.viewer);
    end
    
end

%% Control buttons Callback
methods
    function onButtonOK(this, varargin)        
        % apply the threshold operation
        res = computeResultImage(this);
        newDoc = addImageDocument(this.viewer.gui, res);
            
        % add history
        strValue = num2str(this.minAreaValue);
        if isLabelImage(this.viewer.doc.image)
            string = sprintf('%s = areaOpening(%s, %s);\n', ...
                newDoc.tag, this.viewer.doc.tag, strValue);
        elseif isBinaryImage(this.viewer.doc.image)
            string = sprintf('%s = areaOpening(%s, %s, %d);\n', ...
                newDoc.tag, this.viewer.doc.tag, strValue, this.conn);
        end
        addToHistory(this.viewer.gui.app, string);
        
        closeFigure(this);
    end
    
    function onButtonCancel(this, varargin)
        closeFigure(this);
    end
end


%% Methods specific to the operator
methods
    function updateLabelImage(this)
        % ensure the image of labels is valid
        img = this.viewer.doc.image;
        if isLabelImage(img)
            this.labelImage = img;
        elseif isBinaryImage(img)
            this.labelImage = labeling(img, this.conn);
        else 
            error('ImageM:ImageAreaOpeningAction', 'Unknown image type');
        end
    end
    
    function updateParticleAreaList(this)
        % update the list of areas for each particle in the label image
        lbl = this.labelImage;
        this.particleAreas = imArea(lbl);
    end
    
    function res = computeResultImage(this)
        img = this.viewer.doc.image;
        if isLabelImage(img)
            res = areaOpening(img, this.minAreaValue);
        elseif isBinaryImage(img)
            res = areaOpening(img, this.minAreaValue, this.conn);
        else 
            error('ImageM:ImageAreaOpeningAction', 'Unknown image type');
        end
    end
end


%% GUI Items Callback
methods
    function onMinAreaTextChanged(this, varargin)
        text = get(this.handles.minAreaText, 'String');
        val = str2double(text);
        if ~isfinite(val)
            return;
        end
        
        % check value is within bounds
        if val < 0 || val > this.labelMax
            return;
        end
        
        this.minAreaValue = val;
        updateWidgets(this);
    end
    
    function onSliderValueChanged(this, varargin)
        val = get(this.handles.valueSlider, 'Value');
        this.minAreaValue = val;
        
        updateWidgets(this);
    end
    
    function onConnectivityChanged(this, varargin)
        index = get(this.handles.connectivityPopup, 'Value');
        this.conn = this.connValues(index);
        
        % update inner state of the tool
        updateLabelImage(this);
        updateParticleAreaList(this);
        
        maxVal = double(max(this.particleAreas));
        this.labelMax = maxVal;
        
        % compute slider steps
        valExtent = maxVal + 1;
        sliderStep1 = 1 / valExtent;
        sliderStep2 = 10 / valExtent;

        set(this.handles.valueSlider, 'Max', maxVal);
        set(this.handles.valueSlider, 'SliderStep', [sliderStep1 sliderStep2]); 
        
        this.minAreaValue = min(this.minAreaValue, maxVal);
        updateWidgets(this);
    end
end

end
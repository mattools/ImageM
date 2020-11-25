classdef ImageAreaOpening < imagem.actions.ScalarImageAction
% Keep only particles larger than a given area.
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
% e-mail: david.legland@inra.fr
% Created: 2012-02-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    % liste of handles to widgets
    Handles;
    
    Viewer;
    
    % the number of individual particles in original image
    LabelMax = 255;
    
    % image of labeled particles (either original image, or result of labeling)
    LabelImage;
    
    % the list of precomputed areas
    ParticleAreas;
    
    % the selected value for minimum area
    MinAreaValue = 10;

    % the connectivity of the regions
    Conn = 4;
    
    % the list of available connectivity values (constant)
    ConnValues = [4, 8];
end

methods
    function obj = ImageAreaOpening()
    end
end

methods
    function run(obj, frame) 
        
        % get handle to current doc
        obj.Viewer = frame;
        doc = currentDoc(frame);
        
        if ~isScalarImage(doc.Image)
            warning('ImageM:WrongImageType', ...
                'Area opening can only be applied on label or binary images');
            return;
        end
        
        % update inner state of the tool
        updateLabelImage(obj);
        updateParticleAreaList(obj);
        
        % setup display
        createFigure(obj);
        updateWidgets(obj);
    end
    
    function hf = createFigure(obj)
        
        % range of particle areas
        areas = obj.ParticleAreas;
        minVal = 0;
        maxVal = double(max(areas));
        obj.LabelMax = maxVal;
        
        % compute slider steps
        valExtent = maxVal + 1;
                
        % set unit step equal to 1 grayscale unit
        sliderStep1 = 1 / valExtent;
        sliderStep2 = 10 / valExtent;
        
        % startup threshold value
        sliderValue = minVal + valExtent / 2;

        % background color of most widgets
        bgColor = getWidgetBackgroundColor(obj.Viewer.Gui);
        
        
        % creates the figure
        hf = figure(...
            'Name', 'Image Area Opening', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', ...
            'Toolbar', 'none', ...
            'CloseRequestFcn', @obj.closeFigure);
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = [250 200];
        set(hf, 'Position', pos);
        
        obj.Handles.Figure = hf;
        
        % vertical layout
        vb  = uix.VBox('Parent', hf, 'Spacing', 5, 'Padding', 5);
        mainPanel = uix.VBox('Parent', vb);
        
        gui = obj.Viewer.Gui;
        
        obj.Handles.MinAreaText = addInputTextLine(gui, mainPanel, ...
            'Minimum area:', '10', ...
            @obj.onMinAreaTextChanged);
        
        % one slider for changing value
        obj.Handles.ValueSlider = uicontrol(...
            'Style', 'Slider', ...
            'Parent', mainPanel, ...
            'Min', minVal, 'Max', maxVal, ...
            'Value', sliderValue, ...
            'SliderStep', [sliderStep1 sliderStep2], ...
            'BackgroundColor', bgColor, ...
            'Callback', @obj.onSliderValueChanged);
        
        % setup listener for slider continuous changes
        addlistener(obj.Handles.ValueSlider, ...
            'ContinuousValueChange', @obj.onSliderValueChanged);
        
        % add combo box for choosing region connectivity
        [obj.Handles.ConnectivityPopup, ht] = addComboBoxLine(gui, mainPanel, ...
            'Connectivity:', {'4', '8'}, ...
            @obj.onConnectivityChanged);
        
        % disable choice of connectivity for label images
        if isLabelImage(obj.Viewer.Doc.Image)
            set(obj.Handles.ConnectivityPopup, 'Enable', 'off');
            set(ht, 'Enable', 'off');
        end
            
        set(mainPanel, 'Heights', [35 25 35]);
        
        % button for control panel
        buttonsPanel = uix.HButtonBox('Parent', vb, 'Padding', 5);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'OK', ...
            'Callback', @obj.onButtonOK);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'Cancel', ...
            'Callback', @obj.onButtonCancel);
        
        set(vb, 'Heights', [-1 40] );
    end
        
    function closeFigure(obj, varargin)
        % clean up viewer figure
        obj.Viewer.Doc.PreviewImage = [];
        updateDisplay(obj.Viewer);
        
        % close the current fig
        if ishandle(obj.Handles.Figure)
            delete(obj.Handles.Figure);
        end
    end
    
    function updateWidgets(obj)
        
        % update widget values
        val = obj.MinAreaValue;
        set(obj.Handles.MinAreaText, 'String', num2str(val))
        set(obj.Handles.ValueSlider, 'Value', val);
        
        % update preview image of the document
        bin = computeResultImage(obj);
        img = overlay(currentImage(obj.Viewer), bin);
        updatePreviewImage(obj.Viewer, img);
    end
    
end

%% Control buttons Callback
methods
    function onButtonOK(obj, varargin)        
        % apply the threshold operation
        res = computeResultImage(obj);
        doc = currentDoc(obj.Viewer);
        newDoc = addImageDocument(obj.Viewer, res);
            
        % add history
        strValue = num2str(obj.MinAreaValue);
        if isLabelImage(doc.Image)
            string = sprintf('%s = areaOpening(%s, %s);\n', ...
                newDoc.Tag, doc.Tag, strValue);
        elseif isBinaryImage(doc.Image)
            string = sprintf('%s = areaOpening(%s, %s, %d);\n', ...
                newDoc.Tag, doc.Tag, strValue, obj.Conn);
        end
        addToHistory(obj.Viewer, string);
        
        closeFigure(obj);
    end
    
    function onButtonCancel(obj, varargin)
        closeFigure(obj);
    end
end


%% Methods specific to the operator
methods
    function updateLabelImage(obj)
        % ensure the image of labels is valid
        img = currentImage(obj.Viewer);
        if isLabelImage(img)
            obj.LabelImage = img;
        elseif isBinaryImage(img)
            obj.LabelImage = componentLabeling(img, obj.Conn);
        else 
            error('ImageM:ImageAreaOpeningAction', 'Unknown image type');
        end
    end
    
    function updateParticleAreaList(obj)
        % update the list of areas for each particle in the label image
        lbl = obj.LabelImage;
        obj.ParticleAreas = imArea(lbl);
    end
    
    function res = computeResultImage(obj)
        img = currentImage(obj.Viewer);
        if isLabelImage(img)
            res = areaOpening(img, obj.MinAreaValue);
        elseif isBinaryImage(img)
            res = areaOpening(img, obj.MinAreaValue, obj.Conn);
        else 
            error('ImageM:ImageAreaOpeningAction', 'Unknown image type');
        end
    end
end


%% GUI Items Callback
methods
    function onMinAreaTextChanged(obj, varargin)
        text = get(obj.Handles.MinAreaText, 'String');
        val = str2double(text);
        if ~isfinite(val)
            return;
        end
        
        % check value is within bounds
        if val < 0 || val > obj.LabelMax
            return;
        end
        
        obj.MinAreaValue = val;
        updateWidgets(obj);
    end
    
    function onSliderValueChanged(obj, varargin)
        val = get(obj.Handles.ValueSlider, 'Value');
        obj.MinAreaValue = val;
        
        updateWidgets(obj);
    end
    
    function onConnectivityChanged(obj, varargin)
        index = get(obj.Handles.ConnectivityPopup, 'Value');
        obj.Conn = obj.ConnValues(index);
        
        % update inner state of the tool
        updateLabelImage(obj);
        updateParticleAreaList(obj);
        
        maxVal = double(max(obj.ParticleAreas));
        obj.LabelMax = maxVal;
        
        % compute slider steps
        valExtent = maxVal + 1;
        sliderStep1 = 1 / valExtent;
        sliderStep2 = 10 / valExtent;

        set(obj.Handles.ValueSlider, 'Max', maxVal);
        set(obj.Handles.ValueSlider, 'SliderStep', [sliderStep1 sliderStep2]); 
        
        obj.MinAreaValue = min(obj.MinAreaValue, maxVal);
        updateWidgets(obj);
    end
end

end
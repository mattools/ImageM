classdef ImageThresholdAction < imagem.gui.actions.ScalarImageAction
%IMAGETHRESHOLDACTION Apply a threshold operation to current image
%
%   output = ImageThresholdAction(input)
%
%   Example
%   ImageThresholdAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-11-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    value = 0;
    inverted = false;
    
    imageHistogram;
    xHistogram;
    
    handles;
end

methods
    function this = ImageThresholdAction(viewer)
        % calls the parent constructor
        this = this@imagem.gui.actions.ScalarImageAction(viewer, 'thresholdImage');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('apply Threshold to current image');
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;
        
        if ~isScalarImage(doc.image)
            warning('ImageM:WrongImageType', ...
                'Threshold can be applied only on scalar images');
            return;
        end
        
        createThresholdFigure(this);
        setThresholdValue(this, this.value);
        updateWidgets(this);
    end
    
    function hf = createThresholdFigure(this)
        
        % compute intensity bounds, based either on type or on image data
        img = this.viewer.doc.image;

        % compute initial image histogram
        [histo x] = histogram(img);
        this.imageHistogram = histo;
        this.xHistogram = x;
        
        % range of grayscale values
        minVal = double(x(1));
        maxVal = double(x(end));
        
        % compute slider steps
        valExtent = maxVal - minVal;
        if minVal == 0
            valExtent = valExtent + 1;
        end
        
        if isGrayscaleImage(img)
            % set unit step equal to 1 grayscale unit
            sliderStep1 = 1 / valExtent;
            sliderStep2 = 10 / valExtent;
        else
            % for intensity images, use relative step
            sliderStep1 = .01;
            sliderStep2 = .1;
        end
        
        % startup threshold value
        sliderValue = minVal + valExtent / 2;
        this.value = sliderValue;
        
        % action figure
        hf = figure(...
            'Name', 'Image Threshold', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', ...
            'Toolbar', 'none', ...
            'CloseRequestFcn', @this.closeFigure);
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = [200 250];
        set(hf, 'Position', pos);
        
        this.handles.figure = hf;
        
        
        % background color of most widgets
        bgColor = getWidgetBackgroundColor(this.viewer.gui);
        
        % vertical layout
        vb  = uiextras.VBox('Parent', hf, 'Spacing', 5, 'Padding', 5);

        % widget panel
        mainPanel = uiextras.VBox('Parent', vb);

        % one axis for displaying image histogram
        this.handles.histogramAxis = axes('Parent', mainPanel);
        
        % one panel for value text input
        line1 = uiextras.HBox('Parent', mainPanel, 'Padding', 5);
        uicontrol(...
            'Style', 'Text', ...
            'Parent', line1, ...
            'String', 'Threshold Value:');
        this.handles.valueEdit = uicontrol(...
            'Style', 'Edit', ...
            'Parent', line1, ...
            'String', '50', ...
            'BackgroundColor', bgColor, ...
            'Callback', @this.onTextValueChanged);
        set(line1, 'Sizes', [-1 -1]);
        
        % one slider for changing value
        this.handles.valueSlider = uicontrol(...
            'Style', 'Slider', ...
            'Parent', mainPanel, ...
            'Min', minVal, 'Max', maxVal, ...
            'Value', sliderValue, ...
            'SliderStep', [sliderStep1 sliderStep2], ...
            'BackgroundColor', bgColor, ...
            'Callback', @this.onSliderValueChanged);
        
        % setup listeners for slider continuous changes
        listener = handle.listener(this.handles.valueSlider, 'ActionEvent', ...
            @this.onSliderValueChanged);
        setappdata(this.handles.valueSlider, 'sliderListeners', listener);

        % one checkbox to decide the threshold side
        this.handles.sideCheckBox = uicontrol(...
            'Style', 'CheckBox', ...
            'Parent', mainPanel, ...
            'String', 'Threshold greater', ...
            'Value', 1, ...
            'Callback', @this.onSideChanged);
            
        set(mainPanel, 'Sizes', [-1 35 25 25]);
        
        % button for control panel
        buttonsPanel = uiextras.HButtonBox( 'Parent', vb, 'Padding', 5);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'OK', ...
            'Callback', @this.onButtonOK);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'Cancel', ...
            'Callback', @this.onButtonCancel);
        
        set(vb, 'Sizes', [-1 40] );
        
        % display full histogram and 
        bar(this.handles.histogramAxis, x, histo, 1, 'k', ...
            'LineStyle', 'none');
        hold on;
        this.handles.thresholdedHistogramBar = ...
            bar(this.handles.histogramAxis, x, histo, 1, 'r', ...
            'LineStyle', 'none');
        
        % setup histogram bounds
        w = x(2) - x(1);
        set(this.handles.histogramAxis, 'xlim', [minVal-w/2 maxVal+w/2]);
    end
    
    function bin = computeThresholdedImage(this)
        % Compute the result of threshold
        if this.inverted
            bin = this.viewer.doc.image < this.value;
        else
            bin = this.viewer.doc.image > this.value;
        end

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
    
    function setThresholdValue(this, newValue)
        values = this.xHistogram;
        if isGrayscaleImage(this.viewer.doc.image)
            newValue = round(newValue);
        end
        this.value = max(min(newValue, values(end)), values(1));
    end
    
    function updateWidgets(this)

        % update widget values
        set(this.handles.valueEdit, 'String', num2str(this.value))
        set(this.handles.valueSlider, 'Value', this.value);
        
        % Update histogram preview
        histo2 = this.imageHistogram;
        if this.inverted
            ind = find(this.xHistogram < this.value, 1, 'last');
            histo2(ind+1:end) = 0;
        else
            ind = find(this.xHistogram > this.value, 1, 'first');
            histo2(1:ind-1) = 0;
        end
        set(this.handles.thresholdedHistogramBar, 'YData', histo2);
        
        % update preview image of the document
        bin = computeThresholdedImage(this);
        doc = this.viewer.doc;
        doc.previewImage = overlay(doc.image, bin);
        updateDisplay(this.viewer);
    end
    
end

%% GUI Items Callback
methods
    function onButtonOK(this, varargin)        
        % apply the threshold operation
        bin = computeThresholdedImage(this);
        addImageDocument(this.viewer.gui, bin);
        closeFigure(this);
    end
    
    function onButtonCancel(this, varargin)
        closeFigure(this);
    end
    
    function onSliderValueChanged(this, varargin)
        val = get(this.handles.valueSlider, 'Value');
        
        setThresholdValue(this, val);
        updateWidgets(this);
    end
    
    function onTextValueChanged(this, varargin)
        val = str2double(get(this.handles.valueEdit, 'String'));
        if ~isfinite(val)
            return;
        end
        
        setThresholdValue(this, val);
        updateWidgets(this);
    end
    
    function onSideChanged(this, varargin)
        this.inverted = ~get(this.handles.sideCheckBox, 'Value');
        updateWidgets(this);
    end
end

end

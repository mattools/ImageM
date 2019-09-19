classdef ImageThreshold < imagem.actions.ScalarImageAction
% Apply a threshold operation to current image.
%
%   output = ImageThresholdAction(input)
%
%   Example
%   ImageThresholdAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-11-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    Value = 0;
    Inverted = false;
    
    ImageHistogram;
    XHistogram;
    
    Handles;
    Viewer;
end

methods
    function obj = ImageThreshold()
    end
end

methods
    function run(obj, frame) %#ok<INUSD>
        
        if ~isScalarImage(currentImage(frame))
            error('ImageM:WrongImageType', ...
                'Threshold can be applied only on a scalar image');
        end
        
        obj.Viewer = frame;
        
        createThresholdFigure(obj);
        setThresholdValue(obj, obj.Value);
        updateWidgets(obj);
    end
    
    function hf = createThresholdFigure(obj)
        
        % compute intensity bounds, based either on type or on image data
        img = currentImage(obj.Viewer);

        % compute initial image histogram
        [histo, x] = histogram(img);
        obj.ImageHistogram = histo;
        obj.XHistogram = x;
        
        % range of grayscale values
        minVal = double(x(1));
        maxVal = double(x(end));
        
        % compute slider steps
        valExtent = maxVal - minVal;
        
        if isGrayscaleImage(img)
            if minVal == 0
                valExtent = valExtent + 1;
            end
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
        obj.Value = sliderValue;
        
        
        % action figure
        hf = figure(...
            'Name', 'Image Threshold', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', ...
            'Toolbar', 'none', ...
            'CloseRequestFcn', @obj.closeFigure);
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = [200 250];
        set(hf, 'Position', pos);
        
        obj.Handles.Figure = hf;
        
        
        % background color of most widgets
        bgColor = getWidgetBackgroundColor(obj.Viewer.Gui);
        
        % vertical layout
        vb  = uix.VBox('Parent', hf, 'Spacing', 5, 'Padding', 5);

        % widget panel
        mainPanel = uix.VBox('Parent', vb);

        % one axis for displaying image histogram
        obj.Handles.HistogramAxis = axes('Parent', mainPanel);
        
        % one panel for value text input
        line1 = uix.HBox('Parent', mainPanel, 'Padding', 5);
        uicontrol(...
            'Style', 'Text', ...
            'Parent', line1, ...
            'String', 'Threshold Value:');
        obj.Handles.ValueEdit = uicontrol(...
            'Style', 'Edit', ...
            'Parent', line1, ...
            'String', '50', ...
            'BackgroundColor', bgColor, ...
            'Callback', @obj.onTextValueChanged);
        set(line1, 'Widths', [-1 -1]);
        
        % one slider for changing value
        obj.Handles.ValueSlider = uicontrol(...
            'Style', 'Slider', ...
            'Parent', mainPanel, ...
            'Min', minVal, 'Max', maxVal, ...
            'Value', sliderValue, ...
            'SliderStep', [sliderStep1 sliderStep2], ...
            'BackgroundColor', bgColor, ...
            'Callback', @obj.onSliderValueChanged);
        
        % setup listeners for slider continuous changes
        addlistener(obj.Handles.ValueSlider, ...
            'ContinuousValueChange', @obj.onSliderValueChanged);

        % one checkbox to decide the threshold side
        obj.Handles.SideCheckBox = uicontrol(...
            'Style', 'CheckBox', ...
            'Parent', mainPanel, ...
            'String', 'Bright Threshold', ...
            'Value', 1, ...
            'Callback', @obj.onSideChanged);
            
        set(mainPanel, 'Heights', [-1 35 25 25]);
        
        % button for control panel
        buttonsPanel = uix.HButtonBox( 'Parent', vb, 'Padding', 5);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'OK', ...
            'Callback', @obj.onButtonOK);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'Cancel', ...
            'Callback', @obj.onButtonCancel);
        
        set(vb, 'Heights', [-1 40] );
        
        % display full histogram and 
        bar(obj.Handles.HistogramAxis, x, histo, 1, 'k', ...
            'LineStyle', 'none');
        % hold on;
        set(obj.Handles.HistogramAxis, 'NextPlot', 'Add');
        set(obj.Handles.HistogramAxis, ...
            'YTickLabelMode', 'Manual', 'YTickLabel', '');
        obj.Handles.ThresholdedHistogramBar = ...
            bar(obj.Handles.HistogramAxis, x, histo, 1, 'r', ...
            'LineStyle', 'none');
        
        % setup histogram bounds
        w = x(2) - x(1);
        set(obj.Handles.HistogramAxis, 'xlim', [minVal-w/2 maxVal+w/2]);
    end
    
    function bin = computeThresholdedImage(obj)
        % Compute the result of threshold
        
        if obj.Inverted
            bin = currentImage(obj.Viewer) < obj.Value;
        else
            bin = currentImage(obj.Viewer) > obj.Value;
        end

    end
    function closeFigure(obj, varargin)
        % clean up viewer figure
        clearPreviewImage(obj.Viewer);
        
        % close the current fig
        if ishandle(obj.Handles.Figure)
            delete(obj.Handles.Figure);
        end
    end
    
    function setThresholdValue(obj, newValue)
        values = obj.XHistogram;
        if isGrayscaleImage(currentImage(obj.Viewer))
            newValue = round(newValue);
        end
        obj.Value = max(min(newValue, values(end)), values(1));
    end
    
    function updateWidgets(obj)

        % update widget values
        set(obj.Handles.ValueEdit, 'String', num2str(obj.Value))
        set(obj.Handles.ValueSlider, 'Value', obj.Value);
        
        % Update histogram preview
        histo2 = obj.ImageHistogram;
        if obj.Inverted
            ind = find(obj.XHistogram < obj.Value, 1, 'last');
            histo2(ind+1:end) = 0;
        else
            ind = find(obj.XHistogram > obj.Value, 1, 'first');
            histo2(1:ind-1) = 0;
        end
        set(obj.Handles.ThresholdedHistogramBar, 'YData', histo2);
        
        % update preview image of the document
        bin = computeThresholdedImage(obj);
        img = overlay(currentImage(obj.Viewer), bin);
        updatePreviewImage(obj.Viewer, img);
    end
    
end

%% GUI Items Callback
methods
    function onButtonOK(obj, varargin)        
        % apply the threshold operation
        bin = computeThresholdedImage(obj);
        newDoc = addImageDocument(obj.Viewer, bin);
        
        % compute all string patterns used for history
        doc = currentDoc(obj.Viewer);
        tag = doc.Tag;
        newTag = newDoc.Tag;
        if obj.Inverted
            op = '<';
        else
            op = '>';
        end
        val = num2str(obj.Value);
        
        % history
        string = sprintf('%s = %s %s %s;\n', newTag, tag, op, val);
        addToHistory(obj.Viewer, string);
        
        closeFigure(obj);
    end
    
    function onButtonCancel(obj, varargin)
        closeFigure(obj);
    end
    
    function onSliderValueChanged(obj, varargin)
        val = get(obj.Handles.ValueSlider, 'Value');
        
        setThresholdValue(obj, val);
        updateWidgets(obj);
    end
    
    function onTextValueChanged(obj, varargin)
        val = str2double(get(obj.Handles.ValueEdit, 'String'));
        if ~isfinite(val)
            return;
        end
        
        setThresholdValue(obj, val);
        updateWidgets(obj);
    end
    
    function onSideChanged(obj, varargin)
        obj.Inverted = ~get(obj.Handles.SideCheckBox, 'Value');
        updateWidgets(obj);
    end
end

end

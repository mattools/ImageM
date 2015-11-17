classdef ImageExtendedMaximaAction < imagem.gui.actions.ScalarImageAction
%IMAGEEXTENDEDMAXIMAACTION Extract extended maxima in a grayscale image
%
%   output = ImageExtendedMaximaAction(input)
%
%   Example
%   ImageExtendedMaximaAction
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
    % the value of dynamic, between 0 and image grayscale extent
    value = 0;
    
    inverted = false;
    handles;
    
    imageExtent;
    
    conn = 4;
    connValues = [4, 8];
end

methods
    function this = ImageExtendedMaximaAction(viewer)
        % calls the parent constructor
        this = this@imagem.gui.actions.ScalarImageAction(viewer, 'extendedMaxima');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        % apply extended maxima to current image
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;
        
        if ~isScalarImage(doc.image)
            warning('ImageM:WrongImageType', ...
                'Extended maxima can be applied only on scalar images');
            return;
        end
        
        createExtendedMaximaFigure(this);
        setMaximaValue(this, this.value);
        updateWidgets(this);
    end
    
    function hf = createExtendedMaximaFigure(this)
        
        % compute intensity bounds, based either on type or on image data
        img = this.viewer.doc.image;
        [minVal, maxVal] = grayscaleExtent(img);
        minVal = double(minVal);
        maxVal = double(maxVal);
        this.imageExtent = [minVal maxVal];

        % compute slider steps
        valExtent = maxVal - minVal;
        if minVal == 0
            valExtent = valExtent + 1;
        end
        sliderStep1 = 1 / valExtent;
        sliderStep2 = 10 / valExtent;
        
        % initial value of maxima dynamic
        dynValue = valExtent / 4;
        this.value = dynValue;
        
        % action figure
        hf = figure(...
            'Name', 'Extended Maxima', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', ...
            'Toolbar', 'none', ...
            'CloseRequestFcn', @this.closeFigure);
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = 200;
        set(hf, 'Position', pos);
        
        this.handles.figure = hf;
        
        % background color of most widgets
        bgColor = getWidgetBackgroundColor(this.viewer.gui);
                
        % vertical layout
        vb  = uiextras.VBox('Parent', hf, 'Spacing', 5, 'Padding', 5);
        
        % one panel for value text input
        mainPanel = uiextras.VBox('Parent', vb);
        line1 = uiextras.HBox('Parent', mainPanel, 'Padding', 5);
        uicontrol(...
            'Style', 'Text', ...
            'Parent', line1, ...
            'String', 'Dynamic Value:');
        this.handles.valueEdit = uicontrol(...
            'Style', 'Edit', ...
            'Parent', line1, ...
            'String', num2str(dynValue), ...
            'BackgroundColor', bgColor, ...
            'Callback', @this.onTextValueChanged, ...
            'KeyPressFcn', @this.onTextValueChanged);
        set(line1, 'Sizes', [-1 -1]);

        % one slider for changing value
        this.handles.valueSlider = uicontrol(...
            'Style', 'Slider', ...
            'Parent', mainPanel, ...
            'Min', 0, 'Max', valExtent, ...
            'Value', dynValue, ...
            'SliderStep', [sliderStep1 sliderStep2], ...
            'BackgroundColor', bgColor, ...
            'Callback', @this.onSliderValueChanged);
        set(mainPanel, 'Sizes', [35 25]);
        
        % setup listeners for slider continuous changes
%         listener = handle.listener(this.handles.valueSlider, 'ActionEvent', ...
%             @this.onSliderValueChanged);
%         setappdata(this.handles.valueSlider, 'sliderListeners', listener);
        addlistener(this.handles.valueSlider, ...
            'ContinuousValueChange', @this.onSliderValueChanged);
        
        % combo box for the connectivity
        gui = this.viewer.gui;
        this.handles.connectivityPopup = addComboBoxLine(gui, mainPanel, ...
            'Connectivity:', {'4', '8'}, ...
            @this.onConnectivityChanged);
           
        % button for control panel
        buttonsPanel = uiextras.HButtonBox( 'Parent', vb, 'Padding', 5);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'OK', ...
            'Callback', @this.onButtonOK);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'Cancel', ...
            'Callback', @this.onButtonCancel);
        
        set(vb, 'Sizes', [-1 40] );
    end
    
    function bin = computeMaximaImage(this)
        % Compute the result of threshold
        bin = extendedMaxima(this.viewer.doc.image, this.value, this.conn);
    end
    
    function closeFigure(this, varargin)
        % clean up viewer figure
        this.viewer.doc.previewImage = [];
        updateDisplay(this.viewer);
        
        % close the current fig
        delete(this.handles.figure);
    end
    
    function setMaximaValue(this, newValue)
        imgDyn = this.imageExtent(2) - this.imageExtent(1);
        this.value = max(min(round(newValue), imgDyn), 0);
    end
    
    function updateWidgets(this)
        
        set(this.handles.valueEdit, 'String', num2str(this.value))
        set(this.handles.valueSlider, 'Value', this.value);
        
        % update preview image of the document
        bin = computeMaximaImage(this);
        doc = this.viewer.doc;
        doc.previewImage = overlay(doc.image, bin);
        updateDisplay(this.viewer);
    end
    
end

%% GUI Items Callback
methods
    function onButtonOK(this, varargin)        
        doc = this.viewer.doc;
        doc.previewImage = [];
        updateDisplay(this.viewer);

        bin = computeMaximaImage(this);
        newDoc = addImageDocument(this.viewer.gui, bin, [], 'emax');
        
        % add history
        string = sprintf('%s = extendedMaxima(%s, %f, %d);\n', ...
            newDoc.tag, this.viewer.doc.tag, this.value, this.conn);
        addToHistory(this.viewer.gui.app, string);

        closeFigure(this);
    end
    
    function onButtonCancel(this, varargin)
        doc = this.viewer.doc;
        doc.previewImage = [];
        updateDisplay(this.viewer);
        
        closeFigure(this);
    end
    
    function onSliderValueChanged(this, varargin)
        val = get(this.handles.valueSlider, 'Value');
        
        setMaximaValue(this, val);
        updateWidgets(this);
    end
    
    function onTextValueChanged(this, varargin)
        val = str2double(get(this.handles.valueEdit, 'String'));
        if ~isfinite(val)
            return;
        end
        
        setMaximaValue(this, val);
        updateWidgets(this);
    end
    
    function onConnectivityChanged(this, varargin)
        index = get(this.handles.connectivityPopup, 'Value');
        this.conn = this.connValues(index);
        
        updateWidgets(this);
    end
end

end
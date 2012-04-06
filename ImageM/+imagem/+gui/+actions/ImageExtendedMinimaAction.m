classdef ImageExtendedMinimaAction < imagem.gui.actions.ScalarImageAction
%IMAGEEXTENDEDMINIMAACTION Extract extended minima in a grayscale image
%
%   output = ImageExtendedMinimaAction(input)
%
%   Example
%   ImageExtendedMinimaAction
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
    handles;
    
    conn = 4;
    connValues = [4, 8];
end

methods
    function this = ImageExtendedMinimaAction(parent)
        % calls the parent constructor
        this = this@imagem.gui.actions.ScalarImageAction(parent, 'extendedMinima');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('apply extended minima to current image');
        
        % get handle to parent figure, and current doc
        viewer = this.parent;
        doc = viewer.doc;
        
        if ~isScalarImage(doc.image)
            warning('ImageM:WrongImageType', ...
                'Extended minima can be applied only on scalar images');
            return;
        end
        
        createExtendedMinimaFigure(this);
        setMinimaValue(this, this.value);
        updateWidgets(this);
    end
    
    function hf = createExtendedMinimaFigure(this)
        
        % compute intensity bounds, based either on type or on image data
        img = this.parent.doc.image;
        if isinteger(img.data)
            type = class(img.data);
            minVal = double(intmin(type));
            maxVal = double(intmax(type));
        else
            minVal = double(min(img.data(:)));
            maxVal = double(max(img.data(:)));
        end

        % compute slider steps
        valExtent = maxVal - minVal;
        if minVal == 0
            valExtent = valExtent + 1;
        end
        sliderStep1 = 1 / valExtent;
        sliderStep2 = 10 / valExtent;
        
        % startup threshold value
        sliderValue = minVal + valExtent / 2;
        this.value = sliderValue;
        
        % action figure
        hf = figure(...
            'Name', 'Image Threshold', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', 'Toolbar', 'none');
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = 200;
        set(hf, 'Position', pos);
        
        this.handles.figure = hf;
        
        % background color of most widgets
        bgColor = getWidgetBackgroundColor(this.parent.gui);
        
        % vertical layout
        vb  = uiextras.VBox('Parent', hf, 'Spacing', 5, 'Padding', 5);
        
        % one panel for value text input
        mainPanel = uiextras.VBox('Parent', vb);
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
            'Callback', @this.onTextValueChanged, ...
            'KeyPressFcn', @this.onTextValueChanged);
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
        set(mainPanel, 'Sizes', [35 25]);
        
        % setup listeners for slider continuous changes
        listener = handle.listener(this.handles.valueSlider, 'ActionEvent', ...
            @this.onSliderValueChanged);
        setappdata(this.handles.valueSlider, 'sliderListeners', listener);

        % combo box for the connectivity
        gui = this.parent.gui;
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
    
    function bin = computeMinimaImage(this)
        % Compute the result of threshold
        bin = extendedMinima(this.parent.doc.image, this.value, this.conn);
    end
    
    function closeFigure(this)
        % clean up parent figure
        this.parent.doc.previewImage = [];
        updateDisplay(this.parent);
        
        % close the current fig
        close(this.handles.figure);
    end
    
    function setMinimaValue(this, newValue)
        this.value = max(min(round(newValue), 255), 1);
    end
    
    function updateWidgets(this)
        
        set(this.handles.valueEdit, 'String', num2str(this.value))
        set(this.handles.valueSlider, 'Value', this.value);
        
        % update preview image of the document
        bin = computeMinimaImage(this);
        doc = this.parent.doc;
        doc.previewImage = overlay(doc.image, bin);
        updateDisplay(this.parent);
    end
    
end

%% GUI Items Callback
methods
    function onButtonOK(this, varargin)        
        % apply the threshold operation
        bin = computeMinimaImage(this);
        addImageDocument(this.parent.gui, bin);
        closeFigure(this);
    end
    
    function onButtonCancel(this, varargin)
        closeFigure(this);
    end
    
    function onSliderValueChanged(this, varargin)
        val = get(this.handles.valueSlider, 'Value');
        
        setMinimaValue(this, val);
        updateWidgets(this);
    end
    
    function onTextValueChanged(this, varargin)
        val = str2double(get(this.handles.valueEdit, 'String'));
        if ~isfinite(val)
            return;
        end
        
        setMinimaValue(this, val);
        updateWidgets(this);
    end
    
    function onConnectivityChanged(this, varargin)
        index = get(this.handles.connectivityPopup, 'Value');
        this.conn = this.connValues(index);
        
        updateWidgets(this);
    end
end

end
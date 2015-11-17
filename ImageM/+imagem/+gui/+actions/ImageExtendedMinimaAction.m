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
% e-mail: david.legland@nantes.inra.fr
% Created: 2011-11-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    % the set of handles to dialog widgets, indexed by their name
    handles;

    % the value of dynamic, between 0 and image grayscale extent
    value = 0;
    
    % the min and max of values present in image.
    imageExtent;
    
    % the connectivity of the regions. Default value is 4.
    conn = 4;
    
    % the list of available connectivity values
    connValues = [4, 8];
end

methods
    function this = ImageExtendedMinimaAction(viewer)
        % calls the parent constructor
        this = this@imagem.gui.actions.ScalarImageAction(viewer, 'extendedMinima');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        % apply extended minima to current image
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
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
        img = this.viewer.doc.image;
        if isinteger(img.data)
            type = class(img.data);
            minVal = double(intmin(type));
            maxVal = double(intmax(type));
        else
            minVal = double(min(img.data(:)));
            maxVal = double(max(img.data(:)));
        end
        this.imageExtent = [minVal maxVal];

        % compute slider steps
        valExtent = maxVal - minVal;
        if minVal == 0
            valExtent = valExtent + 1;
        end
        sliderStep1 = 1 / valExtent;
        sliderStep2 = 10 / valExtent;
        
        % initial value of minima dynamic
        dynValue = valExtent / 4;
        this.value = dynValue;
        
        % action figure
        hf = figure(...
            'Name', 'Extended Minima', ...
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
        vb  = uix.VBox('Parent', hf, 'Spacing', 5, 'Padding', 5);
        
        % one panel for value text input
        mainPanel = uix.VBox('Parent', vb);
        line1 = uix.HBox('Parent', mainPanel, 'Padding', 5);
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
        set(line1, 'Widths', [-1 -1]);

        % one slider for changing value
        this.handles.valueSlider = uicontrol(...
            'Style', 'Slider', ...
            'Parent', mainPanel, ...
            'Min', 0, 'Max', valExtent, ...
            'Value', dynValue, ...
            'SliderStep', [sliderStep1 sliderStep2], ...
            'BackgroundColor', bgColor, ...
            'Callback', @this.onSliderValueChanged);
        set(mainPanel, 'Heights', [35 25]);
        
        % setup listeners for slider continuous changes
        addlistener(this.handles.valueSlider, ...
            'ContinuousValueChange', @this.onSliderValueChanged);

        % combo box for the connectivity
        gui = this.viewer.gui;
        this.handles.connectivityPopup = addComboBoxLine(gui, mainPanel, ...
            'Connectivity:', {'4', '8'}, ...
            @this.onConnectivityChanged);
        
        % button for control panel
        buttonsPanel = uix.HButtonBox( 'Parent', vb, 'Padding', 5);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'OK', ...
            'Callback', @this.onButtonOK);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'Cancel', ...
            'Callback', @this.onButtonCancel);
        
        set(vb, 'Heights', [-1 40] );
    end
    
    function bin = computeMinimaImage(this)
        % Compute the result of threshold
        bin = extendedMinima(this.viewer.doc.image, this.value, this.conn);
    end
    
    function closeFigure(this, varargin)
        % clean up viewer figure
        this.viewer.doc.previewImage = [];
        updateDisplay(this.viewer);
        
        % close the current figure
        if ~isempty(this.handles.figure);
            delete(this.handles.figure);
        end
    end
    
    function setMinimaValue(this, newValue)
        imgDyn = this.imageExtent(2) - this.imageExtent(1);
        this.value = max(min(round(newValue), imgDyn), 0);
    end
    
    function updateWidgets(this)
        
        set(this.handles.valueEdit, 'String', num2str(this.value))
        set(this.handles.valueSlider, 'Value', this.value);
        
        % update preview image of the document
        bin = computeMinimaImage(this);
        doc = this.viewer.doc;
        doc.previewImage = overlay(doc.image, bin);
        updateDisplay(this.viewer);
    end
    
end

%% GUI Items Callback
methods
    function onButtonOK(this, varargin)        
        % apply the threshold operation
        bin = computeMinimaImage(this);
        newDoc = addImageDocument(this.viewer.gui, bin, [], 'emin');
        
        % add history
        string = sprintf('%s = extendedMinima(%s, %f, %d);\n', ...
            newDoc.tag, this.viewer.doc.tag, this.value, this.conn);
        addToHistory(this.viewer.gui.app, string);

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
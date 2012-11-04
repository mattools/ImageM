classdef ImageExtendedMinWatershedAction < imagem.gui.actions.ScalarImageAction
%IMAGEIMPOSEDWATERSHEDACTION Apply imposed watershed to an intensity image
%
%   output = ImageWatershedAction(input)
%
%   Example
%   ImageWatershedAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-02-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    handles;
    
    imageExtent = [0 255];
    
    extendedMinimaValue = 10;
    conn = 4;
    
    connValues = [4, 8];
    
    computeWatershed = true;
    computeBasins = false;
end

methods
    function this = ImageExtendedMinWatershedAction(viewer)
        % calls the parent constructor
        this = this@imagem.gui.actions.ScalarImageAction(viewer, 'extendMinWatershed');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('apply imposed watershed to current image');
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;
        
        if ~isScalarImage(doc.image)
            warning('ImageM:WrongImageType', ...
                'Watershed can be applied only on scalar images');
            return;
        end
        
        createWatershedFigure(this);
        updateWidgets(this);
    end
    
    function hf = createWatershedFigure(this)
        
        % range of grayscale values
        img = this.viewer.doc.image;
        minVal = double(min(img));
        maxVal = double(max(img));
        this.imageExtent = [minVal maxVal];
        
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
        
        % startup dynamic value
        sliderValue = valExtent / 2;
        

        % background color of most widgets
        bgColor = getWidgetBackgroundColor(this.viewer.gui);
        
        
        % creates the figure
        hf = figure(...
            'Name', 'Image Watershed', ...
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
        vb  = uiextras.VBox('Parent', hf, 'Spacing', 5, 'Padding', 5);
        mainPanel = uiextras.VBox('Parent', vb);
        
        gui = this.viewer.gui;
        
        this.handles.extendedMinText = addInputTextLine(gui, mainPanel, ...
            'Basin Dynamic:', '10', ...
            @this.onExtendedMinTextChanged);
        
        % one slider for changing value
        this.handles.valueSlider = uicontrol(...
            'Style', 'Slider', ...
            'Parent', mainPanel, ...
            'Min', 1, 'Max', valExtent, ...
            'Value', sliderValue, ...
            'SliderStep', [sliderStep1 sliderStep2], ...
            'BackgroundColor', bgColor, ...
            'Callback', @this.onSliderValueChanged);
        
        % setup listeners for slider continuous changes
        listener = handle.listener(this.handles.valueSlider, 'ActionEvent', ...
            @this.onSliderValueChanged);
        setappdata(this.handles.valueSlider, 'sliderListeners', listener);

        
        this.handles.connectivityPopup = addComboBoxLine(gui, mainPanel, ...
            'Connectivity:', {'4', '8'}, ...
            @this.onConnectivityChanged);

        this.handles.resultTypePopup = addComboBoxLine(gui, mainPanel, ...
            'ResultType:', {'Watershed', 'Basins', 'Both'}, ...
            @this.onResultTypeChanged);
        
        set(mainPanel, 'Sizes', [35 25 35 35]);
        
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
        val = this.extendedMinimaValue;
        set(this.handles.extendedMinText, 'String', num2str(val))
        set(this.handles.valueSlider, 'Value', val);
        
        % update preview image of the document
        bin = computeWatershedImage(this) == 0;
        doc = this.viewer.doc;
        doc.previewImage = overlay(doc.image, bin);
        updateDisplay(this.viewer);
    end
    
end

%% Control buttons Callback
methods
    function onButtonOK(this, varargin)        
        % apply the threshold operation
        
        wat = computeWatershedImage(this);
        refDoc = this.viewer.doc;
        if this.computeWatershed
            newDoc = addImageDocument(this.viewer.gui, wat == 0);
        end
        if this.computeBasins
            newDoc = addImageDocument(this.viewer.gui, uint16(wat));
        end
        
        % add history
        string = sprintf('%s = watershed(%s, ''dynamic'', %f, ''conn'', %d));\n', ...
            newDoc.tag, refDoc.tag, this.extendedMinimaValue, this.conn);
        addToHistory(this.viewer.gui, string);
        
        closeFigure(this);
    end
    
    function onButtonCancel(this, varargin)
        closeFigure(this);
    end
end


%% GUI Items Callback
methods
    function onExtendedMinTextChanged(this, varargin)
        text = get(this.handles.extendedMinText, 'String');
        val = str2double(text);
        if ~isfinite(val)
            return;
        end
        
        % check value is within bounds
        extent = this.imageExtent;
        if val < extent(1) || val > extent(2)
            return;
        end
        
        this.extendedMinimaValue = val;
        updateWidgets(this);
    end
    
    function onSliderValueChanged(this, varargin)
        val = get(this.handles.valueSlider, 'Value');
        this.extendedMinimaValue = val;
        updateWidgets(this);
    end
    
    function onConnectivityChanged(this, varargin)
        index = get(this.handles.connectivityPopup, 'Value');
        this.conn = this.connValues(index);
        
        updateWidgets(this);
    end
    
    function onResultTypeChanged(this, varargin)
        type = get(this.handles.resultTypePopup, 'Value');
        switch type
            case 1
                this.computeWatershed = true;
                this.computeBasins = false;
            case 2
                this.computeWatershed = false;
                this.computeBasins = true;
            case 3
                this.computeWatershed = true;
                this.computeBasins = true;
        end
    end
    
    function wat = computeWatershedImage(this)
        wat = watershed(this.viewer.doc.image, ...
            'dynamic', this.extendedMinimaValue, ...
            'conn', this.conn);
    end
end

end
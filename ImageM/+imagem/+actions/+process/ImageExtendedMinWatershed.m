classdef ImageExtendedMinWatershed < imagem.actions.ScalarImageAction
% Apply watershed using extended minima as markers.
%
%   output = ImageWatershedAction(input)
%
%   Example
%   ImageWatershedAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-02-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    % the set of handles to dialog widgets, indexed by their name
    Handles;
    
    Viewer;
    
    % the min and max of values present in image. Default is [0 255]
    ImageExtent = [0 255];
    
    % the value of dynamic used to pre-filter images
    ExtendedMinimaValue = 10;
    
    % the connectivity of the regions
    Conn = 4;
    
    % the list of available connectivity values
    ConnValues = [4, 8];
    
    % boolean flag indicating is binary image of watershed should be created
    ComputeWatershed = true;
    
    % boolean flag indicating if label image of basins should be created
    ComputeBasins = false;
end

methods
    function obj = ImageExtendedMinWatershed()
    end
end

methods
    function run(obj, frame) %#ok<INUSD>
        disp('apply imposed watershed to current image');
        
        % get handle to viewer figure, and current doc
        obj.Viewer = frame;
        img = currentImage(frame);
        
        if ~isScalarImage(img)
            warning('ImageM:WrongImageType', ...
                'Watershed can be applied only on scalar images');
            return;
        end
        
        createWatershedFigure(obj);
        updateWidgets(obj);
    end
    
    function hf = createWatershedFigure(obj)
        
        % range of grayscale values
        img = currentImage(obj.Viewer);
        minVal = double(min(img));
        maxVal = double(max(img));
        obj.ImageExtent = [minVal maxVal];
        
        gui = obj.Viewer.Gui;
        
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
        sliderValue = valExtent / 4;
        
        % background color of most widgets
        bgColor = getWidgetBackgroundColor(gui);
        
        % creates the figure
        hf = figure(...
            'Name', 'Image Watershed', ...
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
        
        obj.Handles.ExtendedMinText = addInputTextLine(gui, mainPanel, ...
            'Basin Dynamic:', '10', ...
            @obj.onExtendedMinTextChanged);
        
        % one slider for changing value
        obj.Handles.ValueSlider = uicontrol(...
            'Style', 'Slider', ...
            'Parent', mainPanel, ...
            'Min', 1, 'Max', valExtent, ...
            'Value', sliderValue, ...
            'SliderStep', [sliderStep1 sliderStep2], ...
            'BackgroundColor', bgColor, ...
            'Callback', @obj.onSliderValueChanged);
        
        % setup listeners for slider continuous changes
        addlistener(obj.Handles.ValueSlider, ...
            'ContinuousValueChange', @obj.onSliderValueChanged);
       
        obj.Handles.ConnectivityPopup = addComboBoxLine(gui, mainPanel, ...
            'Connectivity:', {'4', '8'}, ...
            @obj.onConnectivityChanged);

        obj.Handles.ResultTypePopup = addComboBoxLine(gui, mainPanel, ...
            'ResultType:', {'Watershed', 'Basins', 'Both'}, ...
            @obj.onResultTypeChanged);
        
        set(mainPanel, 'Heights', [35 25 35 35]);
        
        % button for control panel
        buttonsPanel = uix.HButtonBox( 'Parent', vb, 'Padding', 5);
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
        val = obj.ExtendedMinimaValue;
        set(obj.Handles.ExtendedMinText, 'String', num2str(val))
        set(obj.Handles.ValueSlider, 'Value', val);
        
        % update preview image of the document
        bin = computeWatershedImage(obj) == 0;
        doc = currentDoc(obj.Viewer);
        updatePreviewImage(obj.Viewer, overlay(doc.Image, bin));
    end
    
end

%% Control buttons Callback
methods
    function onButtonOK(obj, varargin)        
        % apply the threshold operation
        
        wat = computeWatershedImage(obj);
        refDoc = currentDoc(obj.Viewer);
        if obj.ComputeWatershed
            newDoc = addImageDocument(obj.Viewer, wat == 0);
        end
        if obj.ComputeBasins
            basins = uint16(wat);
            basins.Type = 'label';
            newDoc = addImageDocument(obj.Viewer, basins);
        end
        
        % add history
        string = sprintf('%s = watershed(%s, ''dynamic'', %f, ''conn'', %d));\n', ...
            newDoc.Tag, refDoc.Tag, obj.ExtendedMinimaValue, obj.Conn);
        addToHistory(obj.Viewer, string);
        
        closeFigure(obj);
    end
    
    function onButtonCancel(obj, varargin)
        closeFigure(obj);
    end
end


%% GUI Items Callback
methods
    function onExtendedMinTextChanged(obj, varargin)
        text = get(obj.Handles.ExtendedMinText, 'String');
        val = str2double(text);
        if ~isfinite(val)
            return;
        end
        
        % check value is within bounds
        extent = obj.ImageExtent;
        if val < extent(1) || val > extent(2)
            return;
        end
        
        obj.ExtendedMinimaValue = val;
        updateWidgets(obj);
    end
    
    function onSliderValueChanged(obj, varargin)
        val = get(obj.Handles.ValueSlider, 'Value');
        obj.ExtendedMinimaValue = val;
        updateWidgets(obj);
    end
    
    function onConnectivityChanged(obj, varargin)
        index = get(obj.Handles.ConnectivityPopup, 'Value');
        obj.Conn = obj.ConnValues(index);
        
        updateWidgets(obj);
    end
    
    function onResultTypeChanged(obj, varargin)
        type = get(obj.Handles.ResultTypePopup, 'Value');
        switch type
            case 1
                obj.ComputeWatershed = true;
                obj.ComputeBasins = false;
            case 2
                obj.ComputeWatershed = false;
                obj.ComputeBasins = true;
            case 3
                obj.ComputeWatershed = true;
                obj.ComputeBasins = true;
        end
    end
    
    function wat = computeWatershedImage(obj)
        wat = watershed(currentImage(obj.Viewer), ...
            'dynamic', obj.ExtendedMinimaValue, ...
            'conn', obj.Conn);
    end
end

end
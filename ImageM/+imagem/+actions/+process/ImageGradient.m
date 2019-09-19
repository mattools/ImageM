classdef ImageGradient < imagem.actions.ScalarImageAction
% Compute gradient norm of current image.
%
%   output = ImageGradientAction(input)
%
%   Example
%   ImageGradientAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-11-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    Sigma = 3;
    Handles;
    Viewer;
end

methods
    function obj = ImageGradient()
    end
end

methods
    function run(obj, frame) %#ok<INUSD>
        
        obj.Viewer = frame;
        createGradientFigure(obj);
        updateWidgets(obj);
    end
    
    function hf = createGradientFigure(obj)
        % Creates a new dialog with all necessary widgets
         
        % startup sigma value
        sliderValue = 3;
        obj.Sigma = sliderValue;
        
        % action figure
        hf = figure(...
            'Name', 'Image Gradient', ...
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
        mainPanel = uix.VBox('Parent', vb, ...
            'Spacing', 5, 'Padding', 5, ...
            'Units', 'normalized', ...
            'Position', [0 0 1 1] );

        % one panel for value text input
        line1 = uix.HBox('Parent', mainPanel, ...
            'Spacing', 5, 'Padding', 5);
        uicontrol(...
            'Style', 'Text', ...
            'Parent', line1, ...
            'String', 'Sigma:');
        obj.Handles.SigmaEdit = uicontrol(...
            'Style', 'Edit', ...
            'Parent', line1, ...
            'String', num2str(obj.Sigma), ...
            'BackgroundColor', bgColor, ...
            'Callback', @obj.onTextValueChanged);
        set(line1, 'Widths', [-1 -1]);
        
        % one slider for changing value
        obj.Handles.SigmaSlider = uicontrol(...
            'Style', 'Slider', ...
            'Parent', mainPanel, ...
            'Min', 0, 'Max', 50, ...
            'Value', sliderValue, ...
            'SliderStep', [.002 .02], ...
            'BackgroundColor', bgColor, ...
            'Callback', @obj.onSliderValueChanged);
        
        % setup listeners for slider continuous changes
        addlistener(obj.Handles.SigmaSlider, ...
            'ContinuousValueChange', @obj.onSliderValueChanged);

        set(mainPanel, 'Heights', [35 25]);
        
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
    
    function grad = computeGradientImage(obj)
        % Compute the result of gradient
        img = currentImage(obj.Viewer);
        grad = norm(gradient(img, obj.Sigma));
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
        % update widget values depending on dialog inner state
        
        % update value widgets
        set(obj.Handles.SigmaEdit, 'String', num2str(obj.Sigma))
        set(obj.Handles.SigmaSlider, 'Value', obj.Sigma);
        
        % update preview image of the document
        grad = computeGradientImage(obj);
        doc = currentDoc(obj.Viewer);
        doc.PreviewImage = grad;
        updateDisplay(obj.Viewer);
    end
    
end

%% GUI Items Callback
methods
    function onButtonOK(obj, varargin)        
        % When OK button is clicked, operation is performed, new image is
        % created, history updated, and dialog closed
        
        % apply the gradient operation
        grad = computeGradientImage(obj);
        newDoc = addImageDocument(obj.Viewer, grad);
        
        % add history
        string = sprintf('%s = norm(gradient(%s));\n', newDoc.Tag, obj.Viewer.Doc.Tag);
        addToHistory(obj.Viewer, string);
        
        closeFigure(obj);
    end
    
    function onButtonCancel(obj, varargin)
        % When cancel button is clicked, figure is closed
        closeFigure(obj);
    end
    
    function onSliderValueChanged(obj, varargin)
        obj.Sigma = get(obj.Handles.SigmaSlider, 'Value');
        updateWidgets(obj);
    end
    
    function onTextValueChanged(obj, varargin)
        val = str2double(get(obj.Handles.SigmaEdit, 'String'));
        if ~isfinite(val)
            return;
        end
        
        obj.Sigma = val;
        updateWidgets(obj);
    end
end

end
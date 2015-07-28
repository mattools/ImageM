classdef ImageGradientAction < imagem.gui.actions.ScalarImageAction
%IMAGEGRADIENTACTION Compute gradient norm of current image
%
%   output = ImageGradientAction(input)
%
%   Example
%   ImageGradientAction
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
    sigma = 3;
    handles;
end

methods
    function this = ImageGradientAction(viewer, varargin)
        % calls the parent constructor
        this = this@imagem.gui.actions.ScalarImageAction(viewer, 'imageGradient');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        
        createGradientFigure(this);
        updateWidgets(this);
    end
    
    
    function hf = createGradientFigure(this)
        % Creates a new dialog with all necessary widgets
         
        % startup sigma value
        sliderValue = 3;
        this.sigma = sliderValue;
        
        % action figure
        hf = figure(...
            'Name', 'Image Gradient', ...
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
        this.handles.sigmaEdit = uicontrol(...
            'Style', 'Edit', ...
            'Parent', line1, ...
            'String', num2str(this.sigma), ...
            'BackgroundColor', bgColor, ...
            'Callback', @this.onTextValueChanged);
        set(line1, 'Widths', [-1 -1]);
        
        % one slider for changing value
        this.handles.sigmaSlider = uicontrol(...
            'Style', 'Slider', ...
            'Parent', mainPanel, ...
            'Min', 0, 'Max', 50, ...
            'Value', sliderValue, ...
            'SliderStep', [.01 .05], ...
            'BackgroundColor', bgColor, ...
            'Callback', @this.onSliderValueChanged);
        
        % setup listeners for slider continuous changes
        addlistener(this.handles.sigmaSlider, ...
                        'ContinuousValueChange', @this.onSliderValueChanged);
%         listener = handle.listener(this.handles.sigmaSlider, 'ActionEvent', ...
%             @this.onSliderValueChanged);
%         setappdata(this.handles.sigmaSlider, 'sliderListeners', listener);

        set(mainPanel, 'Heights', [35 25]);
        
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
    
    function grad = computeGradientImage(this)
        % Compute the result of gradient
        grad = norm(gradient(this.viewer.doc.image, this.sigma));
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
        % update widget values depending on dialog inner state
        
        % update value widgets
        set(this.handles.sigmaEdit, 'String', num2str(this.sigma))
        set(this.handles.sigmaSlider, 'Value', this.sigma);
        
        % update preview image of the document
        grad = computeGradientImage(this);
        doc = this.viewer.doc;
        doc.previewImage = grad;
        updateDisplay(this.viewer);
    end
    
end

%% GUI Items Callback
methods
    function onButtonOK(this, varargin)        
        % When OK button is clicked, operation is performed, new image is
        % created, history updated, and dialog closed
        
        % apply the gradient operation
        grad = computeGradientImage(this);
        newDoc = addImageDocument(this.viewer.gui, grad);
        
        % add history
        string = sprintf('%s = norm(gradient(%s));\n', newDoc.tag, this.viewer.doc.tag);
        addToHistory(this.viewer.gui.app, string);
        
        closeFigure(this);
    end
    
    function onButtonCancel(this, varargin)
        % When cancel button is clicked, figure is closed
        closeFigure(this);
    end
    
    function onSliderValueChanged(this, varargin)
        this.sigma = get(this.handles.sigmaSlider, 'Value');
        updateWidgets(this);
    end
    
    function onTextValueChanged(this, varargin)
        val = str2double(get(this.handles.sigmaEdit, 'String'));
        if ~isfinite(val)
            return;
        end
        
        this.sigma = val;
        updateWidgets(this);
    end
end

end
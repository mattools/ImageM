classdef SetImageScaleAction < imagem.gui.actions.CurrentImageAction
%SETIMAGESCALEACTION  One-line description here, please.
%
%   Class SetImageScaleAction
%
%   Example
%   SetImageScaleAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-04-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
    handles;
end % end properties


%% Constructor
methods
    function this = SetImageScaleAction(parent)
        % calls the parent constructor
        this = this@imagem.gui.actions.CurrentImageAction(parent, 'setImageScale');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('set image scale');
        
        createFigure(this);
        updateWidgets(this);
    end
    
    function hf = createFigure(this)
        % creates the figure
        hf = figure(...
            'Name', 'Set Image Scale', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', ...
            'Toolbar', 'none', ...
            'CloseRequestFcn', @this.closeFigure);
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = [250 230];
        set(hf, 'Position', pos);
        
        this.handles.figure = hf;
        
        % vertical layout
        vb  = uiextras.VBox('Parent', hf, 'Spacing', 5, 'Padding', 5);
        mainPanel = uiextras.VBox('Parent', vb);
        
        gui = this.parent.gui;
        this.handles.distancePixelsText = addInputTextLine(gui, mainPanel, ...
            'Distance in pixels:', '');
        this.handles.distanceUserUnitText = addInputTextLine(gui, mainPanel, ...
            'Known distance:', '');
        this.handles.pixelAspectRatioText = addInputTextLine(gui, mainPanel, ...
            'Pixel Aspect Ratio:', '');
        this.handles.unitText = addInputTextLine(gui, mainPanel, ...
            'Unit:', '');


        % calibrate from current selection
        shape = this.parent.selection;
        if ~isempty(shape) && strcmpi(shape.type, 'linesegment')
            len = edgeLength(shape.data);
            set(this.handles.distancePixelsText, 'String', num2str(len));
        end
        
        
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
        % clean up parent figure
        this.parent.doc.previewImage = [];
        updateDisplay(this.parent);
        
        % close the current fig
        if ishandle(this.handles.figure)
            delete(this.handles.figure);
        end
    end
    
    function updateWidgets(this)
        
%         % update preview image of the document
%         bin = computeWatershedImage(this) == 0;
%         doc = this.parent.doc;
%         doc.previewImage = overlay(doc.image, bin);
%         updateDisplay(this.parent);
    end

end % end methods

%% Control buttons Callback
methods
    function onButtonOK(this, varargin)
        
        textPixels = get(this.handles.distancePixelsText, 'String');
        distPx = str2double(textPixels);
        
        textDistance = get(this.handles.distanceUserUnitText, 'String');
        distCalib = str2double(textDistance);
        
        unit = get(this.handles.unitText, 'String');
        
        img = this.parent.doc.image;
        
        
        disp(distPx);
        disp(distCalib);
        disp(unit);
        
        
        resol = distCalib / distPx;
        img.origin      = [0 0];
        img.spacing     = [resol resol];
        img.unitName    = unit;
        img.calibrated  = true;
        
        closeFigure(this);
    end
    
    function onButtonCancel(this, varargin)
        closeFigure(this);
    end
end

end % end classdef


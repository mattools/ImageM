classdef SetImageScale < imagem.actions.CurrentImageAction
% Set image scale.
%
%   Class SetImageScaleAction
%
%   Example
%   SetImageScaleAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-04-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
    Handles;
    Viewer;
end % end properties


%% Constructor
methods
    function obj = SetImageScale()
    end

end % end constructors


%% Methods
methods
    function run(obj, frame)
        disp('set image scale');
        
        obj.Viewer = frame;
        createFigure(obj);
        updateWidgets(obj);
    end
    
    function hf = createFigure(obj)
        % creates the figure
        hf = figure(...
            'Name', 'Set Image Scale', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', ...
            'Toolbar', 'none', ...
            'CloseRequestFcn', @obj.closeFigure);
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = [300 180];
        set(hf, 'Position', pos);
        
        obj.Handles.Figure = hf;
        
        % vertical layout
        vb  = uix.VBox('Parent', hf, 'Spacing', 5, 'Padding', 5);
        mainPanel = uix.VBox('Parent', vb);
        
        gui = obj.Viewer.Gui;
        obj.Handles.DistancePixelsText = addInputTextLine(gui, mainPanel, ...
            'Distance in pixels:', '');
        obj.Handles.DistanceUserUnitText = addInputTextLine(gui, mainPanel, ...
            'Known distance:', '');
        obj.Handles.UnitText = addInputTextLine(gui, mainPanel, ...
            'Unit:', '');


        % calibrate from current selection
        shape = obj.Viewer.Selection;
        if ~isempty(shape) && strcmpi(shape.Type, 'linesegment')
            len = edgeLength(shape.Data);
            set(obj.Handles.DistancePixelsText, 'String', num2str(len));
        end
        
        
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
        clearPreviewImage(obj.Viewer);
        
        % close the current fig
        if ishandle(obj.Handles.Figure)
            delete(obj.Handles.Figure);
        end
    end
    
    function updateWidgets(obj) %#ok<MANU>
    end

end % end methods

%% Control buttons Callback
methods
    function onButtonOK(obj, varargin)
        
        textPixels = get(obj.Handles.DistancePixelsText, 'String');
        distPx = str2double(textPixels);
        
        textDistance = get(obj.Handles.DistanceUserUnitText, 'String');
        distCalib = str2double(textDistance);
        
        unit = get(obj.Handles.UnitText, 'String');
        
        img = currentImage(obj.Viewer);
        
        
        disp(distPx);
        disp(distCalib);
        disp(unit);
        
        if isnan(distPx)
            errordlg(['Could not interpret the string: ' textPixels],...
                'Input Interpretation Error', 'modal');
            return;
        end
        if isnan(distCalib)
            errordlg(['Could not interpret the string: ' textDistance],...
                'Input Interpretation Error', 'modal');
            return;
        end
        
        resol = distCalib / distPx;
        img.Origin      = [0 0];
        img.Spacing     = [resol resol];
        img.UnitName    = unit;
        img.Calibrated  = true;
        
        closeFigure(obj);
    end
    
    function onButtonCancel(obj, varargin)
        closeFigure(obj);
    end
end

end % end classdef


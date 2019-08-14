classdef SetDefaultConnectivityAction < imagem.gui.ImagemAction
% Changes default connectivity in App.
%
%   Class SetDefaultConnectivityAction
%
%   Example
%   SetDefaultConnectivityAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-15,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    Handles;
    
    Conn2d;
    Conn3d;
    
    Conn2dValues = [4 8];
    Conn3dValues = [6 26];
end % end properties


%% Constructor
methods
    function obj = SetDefaultConnectivityAction(viewer)
    % Constructor for SetDefaultConnectivityAction class
        obj = obj@imagem.gui.ImagemAction(viewer, 'setDefaultConnectivity');
        
        app = viewer.Gui.App;
        obj.Conn2d = getDefaultConnectivity(app, 2);
        obj.Conn3d = getDefaultConnectivity(app, 3);
    end

end % end constructors


methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        disp('set connectivity');

        f = figure(...
            'Name', 'Set Connectivity', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', 'Toolbar', 'none');
        obj.Handles.Figure = f;
        
        % compute background color of most widgets
        bgColor = getWidgetBackgroundColor(obj.Viewer.Gui);
        
        % vertical layout
        vb  = uix.VBox('Parent', f, 'Spacing', 5, 'Padding', 5);
        
        g = uix.Grid( 'Parent', vb, 'Spacing', 5 );
        uicontrol(...
            'Style', 'Text', ...
            'Parent', g, ...
            'String', 'Planar Images:', ...
            'HorizontalAlignment', 'right');
        uicontrol(...
            'Style', 'Text', ...
            'Parent', g, ...
            'String', '3D Images:', ...
            'HorizontalAlignment', 'right');
        obj.Handles.Conn2dPopup = uicontrol(...
            'Style', 'PopupMenu', ...
            'Parent', g, ...
            'String', {'4', '8'}, ...
            'Value', 1, ...
            'BackgroundColor', bgColor, ...
            'Callback', @obj.onConn2dChanged);
        obj.Handles.Conn3dPopup = uicontrol(...
            'Style', 'PopupMenu', ...
            'Parent', g, ...
            'String', {'6', '26'}, ...
            'Value', 1, ...
            'BackgroundColor', bgColor, ...
            'Callback', @obj.onConn3dChanged);
        set(g, 'Widths', [-1 -1], 'Heights', [-1 -1]);
        
        % select current state of popup menus
        switch obj.Conn2d
            case 4, set(obj.Handles.Conn2dPopup, 'value', 1);
            case 8, set(obj.Handles.Conn2dPopup, 'value', 2);
        end
        switch obj.Conn3d
            case 6, set(obj.Handles.Conn3dPopup, 'value', 1);
            case 26, set(obj.Handles.Conn3dPopup, 'value', 2);
        end
            
        % button for control panel
        buttonsPanel = uix.HButtonBox('Parent', vb, 'Padding', 5);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'OK', ...
            'Callback', @obj.onButtonOK);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'Cancel', ...
            'Callback', @obj.onButtonCancel);
        
        set(vb, 'Heights', [-1 40] );

        set(f, 'units', 'pixels');
        pos = get(f, 'position');
        set(f, 'position', [pos(1:2) 250 150]);

    end
    
end

%% GUI Items Callback
methods
    function onButtonOK(obj, varargin)        
        % apply the threshold operation
        app = obj.Viewer.Gui.App;
        setDefaultConnectivity(app, 2, obj.Conn2d);
        setDefaultConnectivity(app, 3, obj.Conn3d);
        close(obj.Handles.Figure);
    end
    
    function onButtonCancel(obj, varargin)
        close(obj.Handles.Figure);
    end
    
    function onConn2dChanged(obj, varargin)
        index = get(obj.Handles.Conn2dPopup, 'Value');
        obj.Conn2d = obj.Conn2dValues(index);
        
    end
    
    function onConn3dChanged(obj, varargin)
        index = get(obj.Handles.Conn3dPopup, 'Value');
        obj.Conn3d = obj.Conn3dValues(index);
        
    end
end

end % end classdef


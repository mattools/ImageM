classdef SetDefaultConnectivityAction < imagem.gui.ImagemAction
%CREATEIMAGEACTION  Changes defualt connectivity in App
%
%   Class SetDefaultConnectivityAction
%
%   Example
%   SetDefaultConnectivityAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-15,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    handles;
    
    conn2d;
    conn3d;
    
    conn2dValues = [4 8];
    conn3dValues = [6 26];
end % end properties


%% Constructor
methods
    function this = SetDefaultConnectivityAction(parent)
    % Constructor for SetDefaultConnectivityAction class
        this = this@imagem.gui.ImagemAction(parent, 'setDefaultConnectivity');
        
        app = parent.gui.app;
        this.conn2d = getDefaultConnectivity(app, 2);
        this.conn3d = getDefaultConnectivity(app, 3);
    end

end % end constructors


methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('set connectivity');

        f = figure(...
            'Name', 'Set Connectivity', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', 'Toolbar', 'none');
        this.handles.figure = f;
        
        % compute background color of most widgets
        bgColor = getWidgetBackgroundColor(this.parent.gui);
        
        % vertical layout
        vb  = uiextras.VBox('Parent', f, 'Spacing', 5, 'Padding', 5);
        
        g = uiextras.Grid( 'Parent', vb, 'Spacing', 5 );
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
        this.handles.conn2dPopup = uicontrol(...
            'Style', 'PopupMenu', ...
            'Parent', g, ...
            'String', {'4', '8'}, ...
            'Value', 1, ...
            'BackgroundColor', bgColor, ...
            'Callback', @this.onConn2dChanged);
        this.handles.conn3dPopup = uicontrol(...
            'Style', 'PopupMenu', ...
            'Parent', g, ...
            'String', {'6', '26'}, ...
            'Value', 1, ...
            'BackgroundColor', bgColor, ...
            'Callback', @this.onConn3dChanged);
        set(g, 'ColumnSizes', [-1 -1], 'RowSizes', [-1 -1]);
        
        % select current state of popup menus
        switch this.conn2d
            case 4, set(this.handles.conn2dPopup, 'value', 1);
            case 8, set(this.handles.conn2dPopup, 'value', 2);
        end
        switch this.conn3d
            case 6, set(this.handles.conn3dPopup, 'value', 1);
            case 26, set(this.handles.conn3dPopup, 'value', 2);
        end
            
        % button for control panel
        buttonsPanel = uiextras.HButtonBox('Parent', vb, 'Padding', 5);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'OK', ...
            'Callback', @this.onButtonOK);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'Cancel', ...
            'Callback', @this.onButtonCancel);
        
        set(vb, 'Sizes', [-1 40] );

        set(f, 'units', 'pixels');
        pos = get(f, 'position');
        set(f, 'position', [pos(1:2) 200 100]);

    end
    
end

%% GUI Items Callback
methods
    function onButtonOK(this, varargin)        
        % apply the threshold operation
        app = this.parent.gui.app;
        setDefaultConnectivity(app, 2, this.conn2d);
        setDefaultConnectivity(app, 3, this.conn3d);
        close(this.handles.figure);
    end
    
    function onButtonCancel(this, varargin)
        close(this.handles.figure);
    end
    
    function onConn2dChanged(this, varargin)
        index = get(this.handles.conn2dPopup, 'Value');
        this.conn2d = this.conn2dValues(index);
        
    end
    
    function onConn3dChanged(this, varargin)
        index = get(this.handles.conn3dPopup, 'Value');
        this.conn3d = this.conn3dValues(index);
        
    end
end

end % end classdef


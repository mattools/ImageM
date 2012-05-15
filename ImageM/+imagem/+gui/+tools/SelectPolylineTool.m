classdef SelectPolylineTool < imagem.gui.ImagemTool
%LINEPROFILETOOL  One-line description here, please.
%
%   Class SelectPolylineTool
%
%   Example
%   SelectPolylineTool
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-03-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    positions;
    
    lineHandle;
        
end % end properties


%% Constructor
methods
    function this = SelectPolylineTool(viewer, varargin)
        % Constructor for SelectPolylineTool class
        this = this@imagem.gui.ImagemTool(viewer, 'selectPolyline');
    end

end % end constructors


%% ImagemTool Methods
methods
    function select(this) %#ok<*MANU>
        disp('select polyline');
        this.positions = zeros(0, 2);
    end
    
    function deselect(this)
        removeLineHandle(this);
    end
    
    function removeLineHandle(this)
        if ~ishandle(this.lineHandle)
            return;
        end
        
        ax = this.viewer.handles.imageAxis;
        if isempty(ax)
            return;
        end
       
        delete(this.lineHandle);
        
    end
    
    function onMouseButtonPressed(this, hObject, eventdata) %#ok<INUSD>
        ax = this.viewer.handles.imageAxis;
        pos = get(ax, 'CurrentPoint');
        
        % check if right-clicked or double-clicked
        type = get(this.viewer.handles.figure, 'SelectionType');
        if ~strcmp(type, 'normal')
            % update viewer's current selection
            shape = struct('type', 'polyline', 'data', this.positions);
            this.viewer.selection = shape;
            
            this.positions = zeros(0, 2);
            return;
        end
        
        % udpate position list
        this.positions = [this.positions ; pos(1,1:2)];
        
        if size(this.positions, 1) == 1
            % if clicked first point, creates a new graphical object
            removeLineHandle(this);
            this.lineHandle = line(...
                'XData', pos(1,1), 'YData', pos(1,2), ...
                'Marker', 's', 'MarkerSize', 3, ...
                'Color', 'y', 'LineWidth', 1);
            
            this.viewer.selection = [];
        else
            % update graphical object
            set(this.lineHandle, 'xdata', this.positions(:,1));
            set(this.lineHandle, 'ydata', this.positions(:,2));
            
        end
        
    end
    
    function onMouseMoved(this, hObject, eventdata) %#ok<INUSD>
        
        if size(this.positions, 1) < 1
            return;
        end

        % determine the line current end point
        ax = this.viewer.handles.imageAxis;
        pos = get(ax, 'CurrentPoint');
        
        % update line display
        set(this.lineHandle, 'XData', [this.positions(:,1); pos(1,1)]);
        set(this.lineHandle, 'YData', [this.positions(:,2); pos(1,2)]);
    end
    
    
end % end methods

end % end classdef


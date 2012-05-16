classdef SelectPointsTool < imagem.gui.ImagemTool
%SELECTPOINTSTOOL Click on a set of points, right click to end
%
%   Class SelectPointsTool
%
%   Example
%   SelectPointsTool
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
    
    pointsHandle;
        
end % end properties


%% Constructor
methods
    function this = SelectPointsTool(viewer, varargin)
        % Constructor for SelectPointsTool class
        this = this@imagem.gui.ImagemTool(viewer, 'selectPoints');
    end

end % end constructors


%% ImagemTool Methods
methods
    function select(this) %#ok<*MANU>
        disp('select points');
        this.positions = zeros(0, 2);
    end
    
    function deselect(this)
        removePointsHandle(this);
    end
    
    function removePointsHandle(this)
        if ~ishandle(this.pointsHandle)
            return;
        end
        
        ax = this.viewer.handles.imageAxis;
        if isempty(ax)
            return;
        end
       
        delete(this.pointsHandle);
        
    end
    
    function onMouseButtonPressed(this, hObject, eventdata) %#ok<INUSD>
        ax = this.viewer.handles.imageAxis;
        pos = get(ax, 'CurrentPoint');
        
        % check if right-clicked or double-clicked
        type = get(this.viewer.handles.figure, 'SelectionType');
        if ~strcmp(type, 'normal')
            % update viewer's current selection
            shape = struct('type', 'pointset', 'data', this.positions);
            this.viewer.selection = shape;
            
            this.positions = zeros(0, 2);
            return;
        end
        
        % udpate position list
        this.positions = [this.positions ; pos(1,1:2)];
        
        if size(this.positions, 1) == 1
            % if clicked first point, creates a new graphical object
            removePointsHandle(this);
            this.pointsHandle = line(...
                'XData', pos(1,1), 'YData', pos(1,2), ...
                'LineStyle', 'none', ...
                'Marker', 'o', ...
                'MarkerSize', 6, 'LineWidth', 1, ...
                'Color', 'r', 'MarkerFaceColor', 'r');
            
%             this.viewer.selection = [];
        else
            % update graphical object
            set(this.pointsHandle, 'xdata', this.positions(:,1));
            set(this.pointsHandle, 'ydata', this.positions(:,2));
            
        end
        
%         % update viewer's current selection
%         shape = struct('type', 'pointset', 'data', this.positions, ...
%             'style', {{'Marker', 'o', 'MarkerSize', 6, 'LineWidth', 1, ...
%                 'Color', 'r', 'MarkerFaceColor', 'r'}});
%         this.viewer.selection = shape;
    end
    
%     function onMouseMoved(this, hObject, eventdata) %#ok<INUSD>
%         
%         if size(this.positions, 1) < 1
%             return;
%         end
% 
%         % determine the line current end point
%         ax = this.viewer.handles.imageAxis;
%         pos = get(ax, 'CurrentPoint');
%         
%         % update line display
%         set(this.pointsHandle, 'XData', [this.positions(:,1); pos(1,1)]);
%         set(this.pointsHandle, 'YData', [this.positions(:,2); pos(1,2)]);
%     end
    
    
end % end methods

end % end classdef


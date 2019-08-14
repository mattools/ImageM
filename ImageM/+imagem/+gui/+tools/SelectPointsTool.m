classdef SelectPointsTool < imagem.gui.ImagemTool
% Click on a set of points, right click to end.
%
%   Class SelectPointsTool
%
%   Example
%   SelectPointsTool
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    % the list of point positions, as a N-by-2 array
    Positions;
    
    % handle to the graphical item
    PointsHandle;
        
end % end properties


%% Constructor
methods
    function obj = SelectPointsTool(viewer, varargin)
        % Constructor for SelectPointsTool class
        obj = obj@imagem.gui.ImagemTool(viewer, 'selectPoints');
    end

end % end constructors


%% ImagemTool Methods
methods
    function select(obj) %#ok<*MANU>
        disp('select tool: "point selection"');
        obj.Positions = zeros(0, 2);
    end
    
    function deselect(obj)
        removePointsHandle(obj);
    end
    
    function removePointsHandle(obj)
        if ~ishandle(obj.PointsHandle)
            return;
        end
        
        ax = obj.Viewer.Handles.ImageAxis;
        if isempty(ax)
            return;
        end
       
        delete(obj.PointsHandle);
    end
    
    function onMouseButtonPressed(obj, hObject, eventdata) %#ok<INUSD>
        ax = obj.Viewer.Handles.ImageAxis;
        pos = get(ax, 'CurrentPoint');
        
        % check if right-clicked or double-clicked
        type = get(obj.Viewer.Handles.Figure, 'SelectionType');
        if ~strcmp(type, 'normal')
            % update viewer's current selection
            shape = struct('Type', 'PointSet', 'Data', obj.Positions);
            obj.Viewer.Selection = shape;
            
            obj.Positions = zeros(0, 2);
            return;
        end
        
        % udpate position list
        obj.Positions = [obj.Positions ; pos(1,1:2)];
        
        if size(obj.Positions, 1) == 1
            % if clicked first point, creates a new graphical object
            removePointsHandle(obj);
            obj.PointsHandle = line(...
                'XData', pos(1,1), 'YData', pos(1,2), ...
                'LineStyle', 'none', ...
                'Marker', 'o', ...
                'MarkerSize', 6, 'LineWidth', 1, ...
                'Color', 'r', 'MarkerFaceColor', 'r');
            
%             obj.Viewer.Selection = [];
        else
            % update graphical object
            set(obj.PointsHandle, 'xdata', obj.Positions(:,1));
            set(obj.PointsHandle, 'ydata', obj.Positions(:,2));
            
        end
        
        % update viewer's current selection
        shape = struct('Type', 'PointSet', 'Data', obj.Positions, ...
            'style', {{'Marker', 'o', 'MarkerSize', 6, 'LineWidth', 1, ...
                'Color', 'r', 'MarkerFaceColor', 'r'}});
        obj.Viewer.Selection = shape;
    end
    
%     function onMouseMoved(obj, hObject, eventdata) %#ok<INUSD>
%         
%         if size(obj.Positions, 1) < 1
%             return;
%         end
% 
%         % determine the line current end point
%         ax = obj.Viewer.Handles.ImageAxis;
%         pos = get(ax, 'CurrentPoint');
%         
%         % update line display
%         set(obj.PointsHandle, 'XData', [obj.Positions(:,1); pos(1,1)]);
%         set(obj.PointsHandle, 'YData', [obj.Positions(:,2); pos(1,2)]);
%     end
    
    
end % end methods

end % end classdef


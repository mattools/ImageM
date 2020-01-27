classdef SelectPolygon < imagem.gui.Tool
% Select a polygon, right-click to end.
%
%   Class SelectPolygon
%
%   Example
%   SelectPolygon
%
%   See also
%     SelectPolyline

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-01-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    Positions;
    
    LineHandle;
        
end % end properties


%% Constructor
methods
    function obj = SelectPolygon(viewer, varargin)
        % Constructor for SelectPolylineTool class
        obj = obj@imagem.gui.Tool(viewer, 'selectPolygon');
    end

end % end constructors


%% ImagemTool Methods
methods
    function select(obj) %#ok<*MANU>
        disp('select polygon');
        obj.Positions = zeros(0, 2);
    end
    
    function deselect(obj)
        removeLineHandle(obj);
    end
    
    function removeLineHandle(obj)
        if ~ishandle(obj.LineHandle)
            return;
        end
        
        ax = obj.Viewer.Handles.ImageAxis;
        if isempty(ax)
            return;
        end
       
        delete(obj.LineHandle);
        
    end
    
    function onMouseButtonPressed(obj, hObject, eventdata) %#ok<INUSD>
        ax = obj.Viewer.Handles.ImageAxis;
        pos = get(ax, 'CurrentPoint');
        
        % check if right-clicked or double-clicked
        type = get(obj.Viewer.Handles.Figure, 'SelectionType');
        if ~strcmp(type, 'normal')
            % update viewer's current selection
            shape = struct('Type', 'Polygon', 'Data', obj.Positions);
            obj.Viewer.Selection = shape;
            
            obj.Positions = zeros(0, 2);
            return;
        end
        
        % udpate position list
        obj.Positions = [obj.Positions ; pos(1,1:2)];
        
        if size(obj.Positions, 1) == 1
            % if clicked first point, creates a new graphical object
            removeLineHandle(obj);
            obj.LineHandle = line(...
                'XData', pos(1,1), 'YData', pos(1,2), ...
                'Marker', 's', 'MarkerSize', 3, ...
                'Color', 'y', 'LineWidth', 1);
            
            obj.Viewer.Selection = [];
        else
            % update graphical object
            set(obj.LineHandle, 'xdata', obj.Positions([1:end 1],1));
            set(obj.LineHandle, 'ydata', obj.Positions([1:end 1],2));
            
        end
        
    end
    
    function onMouseMoved(obj, hObject, eventdata) %#ok<INUSD>
        
        if size(obj.Positions, 1) < 1
            return;
        end

        % determine the line current end point
        ax = obj.Viewer.Handles.ImageAxis;
        pos = get(ax, 'CurrentPoint');
        
        % update line display
        set(obj.LineHandle, 'XData', [obj.Positions(:,1); pos(1,1) ; obj.Positions(1,1)]);
        set(obj.LineHandle, 'YData', [obj.Positions(:,2); pos(1,2) ; obj.Positions(1,2)]);
    end
    
end % end methods

end % end classdef


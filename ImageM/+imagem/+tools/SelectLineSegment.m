classdef SelectLineSegment < imagem.gui.Tool
% Select a line segment.
%
%   Class SelectLineSegmentTool
%
%   Example
%   SelectLineSegmentTool
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
    Pos1;
    
    LineHandle;
        
end % end properties


%% Constructor
methods
    function obj = SelectLineSegment(viewer, varargin)
        % Constructor for SelectLineSegmentTool class
        obj = obj@imagem.gui.Tool(viewer, 'selectLineSegment');
    end

end % end constructors


%% ImagemTool Methods
methods
    function select(obj) %#ok<*MANU>
        disp('select line segment');
        obj.Pos1 = [];
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
        
        if isempty(obj.Pos1)
            % initialise the first point
            obj.Pos1 = pos(1,1:2);
            
            % if clicked first point, creates a new graphical object
            removeLineHandle(obj);
            obj.LineHandle = line(...
                'XData', pos(1,1), 'YData', pos(1,2), ...
                'Marker', 's', 'MarkerSize', 3, ...
                'Color', 'y', 'LineWidth', 1);
            
            obj.Viewer.Selection = [];
            return;
        end
        
        % update graphical object
        set(obj.LineHandle, 'xdata', [obj.Pos1(1,1) pos(1,1)]);
        set(obj.LineHandle, 'ydata', [obj.Pos1(1,2) pos(1,2)]);
        
        % create new selection object
        positions = [obj.Pos1 pos(1,1:2)];
        shape = struct('Type', 'LineSegment', 'Data', positions);
        obj.Viewer.Selection = shape;
        
        obj.Pos1 = [];
    end
    
    function onMouseMoved(obj, hObject, eventdata) %#ok<INUSD>
        
        if isempty(obj.Pos1)
            return;
        end

        % determine the line current end point
        ax = obj.Viewer.Handles.ImageAxis;
        pos = get(ax, 'CurrentPoint');
        
        % update line display
        set(obj.LineHandle, 'XData', [obj.Pos1(1,1); pos(1,1)]);
        set(obj.LineHandle, 'YData', [obj.Pos1(1,2); pos(1,2)]);
    end
    
    
end % end methods

end % end classdef


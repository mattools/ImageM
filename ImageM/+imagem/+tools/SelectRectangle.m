classdef SelectRectangle < imagem.gui.Tool
% Select a rectangle.
%
%   Class SelectRectangleTool
%
%   Example
%   SelectRectangleTool
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    Pos1;
    
    LineHandle;
    
    % the current step, can be 1 or 2
    State = 0;
    
end % end properties


%% Constructor
methods
    function obj = SelectRectangle(viewer, varargin)
        % Constructor for SelectRectangleTool class
        obj = obj@imagem.gui.Tool(viewer, 'selectRectangle');
        
        % setup state
        obj.State = 1;
    end

end % end constructors


%% ImagemTool Methods
methods
    function select(obj) %#ok<*MANU>
        disp('select rectangle');
        obj.State= 1;
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
%         fprintf('%f %f\n', pos(1, 1:2));
        
        if obj.State== 1
            % determines the starting point of next line
            obj.Pos1 = pos(1, 1:2);
            obj.State= 2;
            removeLineHandle(obj);
            obj.LineHandle = line(...
                'XData', pos(1,1), 'YData', pos(1,2), ...
                'Marker', 'none', 'color', 'y', 'linewidth', 1);
            
            obj.Viewer.Selection = [];
            
            return;
        end
    
        % Start processing state 2
        
        % determine the line end point
        x1 = obj.Pos1(1, 1);
        x2 = pos(1, 1);
        y1 = obj.Pos1(1, 2);
        y2 = pos(1, 2);

        boxData = [min(x1,x2) max(x1,x2) min(y1,y2) max(y1,y2)];
        shape = Box2D(boxData);
        
        obj.Viewer.Selection = shape;
        
        
        % revert to first state
        obj.State= 1;
    end
    
    function onMouseMoved(obj, hObject, eventdata) %#ok<INUSD>
        
        if obj.State~= 2 || ~ishandle(obj.LineHandle)
            return;
        end

        % determine the line current end point
        ax = obj.Viewer.Handles.ImageAxis;
        pos = get(ax, 'CurrentPoint');
        
        x1 = obj.Pos1(1, 1);
        x2 = pos(1, 1);
        y1 = obj.Pos1(1, 2);
        y2 = pos(1, 2);
        xdata = [x1 x2 x2 x1 x1];
        ydata = [y1 y1 y2 y2 y1];
        
        % update line display
        set(obj.LineHandle, 'XData', xdata);
        set(obj.LineHandle, 'YData', ydata);
        
        % update label of info panel
        locString   = sprintf('(x,y) = (%d,%d) px', round(x2), round(y2));
        boxWidth    = abs(round(x2) - round(x1));
        boxHeight   = abs(round(y2) - round(y1));
        sizeString  = sprintf(', size=(%d,%d) px', boxWidth, boxHeight);
        set(obj.Viewer.Handles.InfoPanel, ...
            'string', [locString sizeString]);
        
    end
    
    
end % end methods

end % end classdef


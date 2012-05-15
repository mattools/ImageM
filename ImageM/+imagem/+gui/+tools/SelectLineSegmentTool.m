classdef SelectLineSegmentTool < imagem.gui.ImagemTool
%LINEPROFILETOOL  One-line description here, please.
%
%   Class SelectLineSegmentTool
%
%   Example
%   SelectLineSegmentTool
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
    pos1;
    
    lineHandle;
        
end % end properties


%% Constructor
methods
    function this = SelectLineSegmentTool(viewer, varargin)
        % Constructor for SelectLineSegmentTool class
        this = this@imagem.gui.ImagemTool(viewer, 'selectLineSegment');
    end

end % end constructors


%% ImagemTool Methods
methods
    function select(this) %#ok<*MANU>
        disp('select line segment');
        this.pos1 = [];
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
        
        if isempty(this.pos1)
            % initialise the first point
            this.pos1 = pos(1,1:2);
            
            % if clicked first point, creates a new graphical object
            removeLineHandle(this);
            this.lineHandle = line(...
                'XData', pos(1,1), 'YData', pos(1,2), ...
                'Marker', 's', 'MarkerSize', 3, ...
                'Color', 'y', 'LineWidth', 1);
            
            this.viewer.selection = [];
            return;
        end
        
        % update graphical object
        set(this.lineHandle, 'xdata', [this.pos1(1,1) pos(1,1)]);
        set(this.lineHandle, 'ydata', [this.pos1(1,2) pos(1,2)]);
        
        % create new selection object
        positions = [this.pos1 pos(1,1:2)];
        shape = struct('type', 'linesegment', 'data', positions);
        this.viewer.selection = shape;
        
        this.pos1 = [];
    end
    
    function onMouseMoved(this, hObject, eventdata) %#ok<INUSD>
        
        if isempty(this.pos1)
            return;
        end

        % determine the line current end point
        ax = this.viewer.handles.imageAxis;
        pos = get(ax, 'CurrentPoint');
        
        % update line display
        set(this.lineHandle, 'XData', [this.pos1(1,1); pos(1,1)]);
        set(this.lineHandle, 'YData', [this.pos1(1,2); pos(1,2)]);
    end
    
    
end % end methods

end % end classdef


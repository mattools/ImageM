classdef SelectRectangleTool < imagem.gui.ImagemTool
%LINEPROFILETOOL  One-line description here, please.
%
%   Class SelectRectangleTool
%
%   Example
%   SelectRectangleTool
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-03-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    pos1;
    
    lineHandle;
    
    % the current step, can be 1 or 2
    state = 0;
    
end % end properties


%% Constructor
methods
    function this = SelectRectangleTool(parent, varargin)
        % Constructor for SelectRectangleTool class
        this = this@imagem.gui.ImagemTool(parent, 'selectRectangle');
        
        % setup state
        this.state = 1;
    end

end % end constructors


%% ImagemTool Methods
methods
    function select(this) %#ok<*MANU>
        disp('select rectangle');
%         this.parent.selection = [];
        this.state = 1;
    end
    
    function deselect(this)
        removeLineHandle(this);
    end
    
    function removeLineHandle(this)
        if ~ishandle(this.lineHandle)
            return;
        end
        
        ax = this.parent.handles.imageAxis;
        if isempty(ax)
            return;
        end
       
        delete(this.lineHandle);
        
    end
    
    function onMouseButtonPressed(this, hObject, eventdata) %#ok<INUSD>
        ax = this.parent.handles.imageAxis;
        pos = get(ax, 'CurrentPoint');
%         fprintf('%f %f\n', pos(1, 1:2));
        
        if this.state == 1
            % determines the starting point of next line
            this.pos1 = pos(1, 1:2);
            this.state = 2;
            removeLineHandle(this);
            this.lineHandle = line(...
                'XData', pos(1,1), 'YData', pos(1,2), ...
                'Marker', 'none', 'color', 'y', 'linewidth', 1);
            
            this.parent.selection = [];
            
            return;
        end
    
        % Start processing state 2
        
        % determine the line end point
        x1 = this.pos1(1, 1);
        x2 = pos(1, 1);
        y1 = this.pos1(1, 2);
        y2 = pos(1, 2);

        boxData = [min(x1,x2) max(x1,x2) min(y1,y2) max(y1,y2)];
        shape = struct('type', 'box', 'data', boxData);
        
        this.parent.selection = shape;
        
        
        % revert to first state
        this.state = 1;
    end
    
    function onMouseMoved(this, hObject, eventdata) %#ok<INUSD>
        
        if this.state ~= 2 || ~ishandle(this.lineHandle)
            return;
        end

        % determine the line current end point
        ax = this.parent.handles.imageAxis;
        pos = get(ax, 'CurrentPoint');
        
        x1 = this.pos1(1, 1);
        x2 = pos(1, 1);
        y1 = this.pos1(1, 2);
        y2 = pos(1, 2);
        xdata = [x1 x2 x2 x1 x1];
        ydata = [y1 y1 y2 y2 y1];
        
        % update line display
        set(this.lineHandle, 'XData', xdata);
        set(this.lineHandle, 'YData', ydata);
        
        
        % update label of info panel
        
        locString = sprintf('(x,y) = (%d,%d) px', round(x2), round(y2));
        boxWidth    = abs(round(x2) - round(x1));
        boxHeight   = abs(round(y2) - round(y1));
        sizeString = sprintf(', size=(%d,%d) px', boxWidth, boxHeight);
        set(this.parent.handles.infoPanel, ...
            'string', [locString sizeString]);
        
    end
    
    
end % end methods

end % end classdef


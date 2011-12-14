classdef LineProfileTool < imagem.gui.ImagemTool
%LINEPROFILETOOL  One-line description here, please.
%
%   Class LineProfileTool
%
%   Example
%   LineProfileTool
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-11-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    pos1;
    
    lineHandle;
end % end properties


%% Constructor
methods
    function this = LineProfileTool(parent, varargin)
        % Constructor for LineProfileTool class
        this = this@imagem.gui.ImagemTool(parent, 'lineProfile');
        
        % setup state
        this.stateNumber = 2;
        this.state = 1;
    end

end % end constructors


%% ImagemTool Methods
methods
    function select(this) %#ok<*MANU>
        this.state = 1;
    end
    
    function onMouseButtonPressed(this, hObject, eventdata) %#ok<INUSD>
        ax = this.parent.handles.imageAxis;
        pos = get(ax, 'CurrentPoint');
        fprintf('%f %f\n', pos(1, 1:2));
        
        if this.state == 1
            % determines thestarting point of next line
            this.pos1 = pos(1, 1:2);
            this.state = 2;
            this.lineHandle = line(...
                'XData', pos(1,1), 'YData', pos(1,2), ...
                'Marker', '+', 'color', 'y', 'linewidth', 1);
            
        else
            % determine the line end point
            pos2 = pos(1, 1:2);
            
            % distribute points along the line
            nValues = 100;
            x = linspace(this.pos1(1), pos2(1), nValues);
            y = linspace(this.pos1(2), pos2(2), nValues);
            dists = [0 cumsum(hypot(diff(x), diff(y)))];
            
            % convert point to image indices
            pts = [x' y'];
            
            % extract corresponding pixel values (nearest-neighbor eval)
            vals = interp(this.parent.doc.image, pts);
            
            % display grayscale profile in new figure
            figure;
            plot(dists, vals);
            
            % revert to first state
            this.state = 1;
        end
    end
    
    function onMouseMoved(this, hObject, eventdata) %#ok<INUSD>
        if this.state == 2
            % determine the line current end point
            ax = this.parent.handles.imageAxis;
            pos = get(ax, 'CurrentPoint');
            
            % update line display
            set(this.lineHandle, 'XData', [this.pos1(1) pos(1, 1)]);
            set(this.lineHandle, 'YData', [this.pos1(2) pos(1, 2)]);
        end
    end
    
end % end methods

end % end classdef


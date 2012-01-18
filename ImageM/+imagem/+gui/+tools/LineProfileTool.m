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
            return;
        end
    
        % Start processing state 2
        
        % determine the line end point
        pos2 = pos(1, 1:2);
        
        % distribute points along the line
        nValues = 100;
        x = linspace(this.pos1(1), pos2(1), nValues);
        y = linspace(this.pos1(2), pos2(2), nValues);
        dists = [0 cumsum(hypot(diff(x), diff(y)))];
        
        % convert point to image indices
        pts = [x' y'];
        
        % new figure for display
        figure;
        
        img = this.parent.doc.image;
        
        % extract corresponding pixel values (nearest-neighbor eval)
        vals = interp(img, pts);
        if isGrayscaleImage(img)
            plot(dists, vals);
            
        elseif isColorImage(img)
            % display each color histogram as stairs, to see the 3 curves
            hh = stairs(vals);
            
            % setup curve colors
            set(hh(1), 'color', [1 0 0]); % red
            set(hh(2), 'color', [0 1 0]); % green
            set(hh(3), 'color', [0 0 1]); % blue
            
        else
            warning('LineProfileTool:UnsupportedImageImageType', ...
                ['Can not manage images of type ' img.type]);
        end
        
        % revert to first state
        this.state = 1;
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


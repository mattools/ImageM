classdef LineProfileTool < imagem.gui.ImagemTool
% Draw linear profile.
%
%   Class LineProfileTool
%
%   Example
%   LineProfileTool
%
%   See also
%     ImageSelectionLineProfile
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-11-16,    using Matlab 7.9.0.529 (R2009b)
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
    function obj = LineProfileTool(viewer, varargin)
        % Constructor for LineProfileTool class
        obj = obj@imagem.gui.ImagemTool(viewer, 'lineProfile');
        
        % setup state
        obj.State = 1;
    end

end % end constructors


%% ImagemTool Methods
methods
    function select(obj) %#ok<*MANU>
        disp('select line profile');
        obj.State = 1;
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
        fprintf('%f %f\n', pos(1, 1:2));
        
        if obj.State == 1
            % determines the starting point of next line
            obj.Pos1 = pos(1, 1:2);
            obj.State = 2;
            removeLineHandle(obj);
            obj.LineHandle = line(...
                'XData', pos(1,1), 'YData', pos(1,2), ...
                'Marker', '+', 'color', 'y', 'linewidth', 1);
            return;
        end
    
        % Start processing state 2
        
        % determine the line end point
        pos2 = pos(1, 1:2);
        
        % distribute points along the line
        nValues = 100;
        x = linspace(obj.Pos1(1), pos2(1), nValues);
        y = linspace(obj.Pos1(2), pos2(2), nValues);
        dists = [0 cumsum(hypot(diff(x), diff(y)))];
        
        % convert point to image indices
        pts = [x' y'];
        
        % new figure for display
        figure;
        
        img = obj.Viewer.Doc.Image;
        
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
        obj.State = 1;
    end
    
    function onMouseMoved(obj, hObject, eventdata) %#ok<INUSD>
        if obj.State ~= 2 || ~ishandle(obj.LineHandle)
            return;
        end

        % determine the line current end point
        ax = obj.Viewer.Handles.ImageAxis;
        pos = get(ax, 'CurrentPoint');
        
        % update line display
        set(obj.LineHandle, 'XData', [obj.Pos1(1) pos(1, 1)]);
        set(obj.LineHandle, 'YData', [obj.Pos1(2) pos(1, 2)]);
    end
    
end % end methods

end % end classdef


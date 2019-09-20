classdef PlotImageLineProfile < imagem.actions.CurrentImageAction
% Plot line profile of current selection.
%
%   Class PlotImageLineProfile
%
%   Example
%   PlotImageLineProfile
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
    Viewer;
end % end properties


%% Constructor
methods
    function obj = PlotImageLineProfile()
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSD>
        
        obj.Viewer = frame;
        selection = frame.Selection;
        if isempty(selection)
            return;
        end
        
        switch lower(selection.Type)
            case 'linesegment'
                % determine the line end point
                pos1 = selection.Data(1, 1:2);
                pos2 = selection.Data(1, 3:4);
                len = hypot(pos1(1) - pos2(1), pos1(2) - pos2(2));
                
                nValues = ceil(len) + 1;
                x = linspace(pos1(1), pos2(1), nValues);
                y = linspace(pos1(2), pos2(2), nValues);
                dists = [0 cumsum(hypot(diff(x), diff(y)))];
                
                pts = [x' y'];
                
            case 'polyline'
                dx = diff(selection.Data(:,1));
                dy = diff(selection.Data(:,2));
                len = sum(hypot(dx, dy));
                
                nValues = ceil(len) + 1;
                pts = resamplePolyline(selection.Data, nValues);
                
                dx = diff(pts(:,1));
                dy = diff(pts(:,2));
                dists = [0 cumsum(hypot(dx, dy))'];
                
            otherwise
                errordlg('Impossible to create line profile for %s selections', selection.Type);
                return;
        end
        
        
        % extract corresponding pixel values (nearest-neighbor eval)
        img = currentImage(frame);
        vals = interp(img, pts);
        

        % new figure for display
        hf = figure;
        set(hf, 'NumberTitle', 'off');
        
        % display resulting curve(s)
        if isScalarImage(img)
            plot(dists, vals);
            ylabel('Intensity');
            
        elseif isColorImage(img)
            % display each color histogram as stairs, to see the 3 curves
            hh = stairs(vals);
            
            % setup curve colors
            set(hh(1), 'color', [1 0 0]); % red
            set(hh(2), 'color', [0 1 0]); % green
            set(hh(3), 'color', [0 0 1]); % blue
            ylabel('Color intensity');
            
        else
            warning('LineProfileTool:UnsupportedImageImageType', ...
                ['Can not manage images of type ' img.Type]);
        end

        xlabel('Position on line');
        
        if ~isempty(img.Name)
            title(img.Name);
            set(gcf, 'name', ['Profile of ' img.Name]);
        end
    end
end % end methods

end % end classdef

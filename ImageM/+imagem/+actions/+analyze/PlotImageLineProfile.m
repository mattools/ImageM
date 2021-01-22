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
        
        % current selection
        selection = frame.Selection;
        if isempty(selection)
            return;
        end
        
        % current image (limit to one slice and one frame)
        img = currentImage(frame);
        if ndims(img) > 2 %#ok<ISMAT>
            if isprop(frame, 'FrameIndex')
                img = frame(img, frame.FrameIndex);
            end
            if isprop(frame, 'SliceIndex')
                img = slice(img, frame.SliceIndex);
            end
        end
        
        if isa(selection, 'LineSegment2D')
            % determine the line end point (calibrated coordinates)
            pos1 = selection.P1;
            pos2 = selection.P2;
            
            % length of selection in pixel coordinates
            pos1px = pointToContinuousIndex(img, pos1);
            pos2px = pointToContinuousIndex(img, pos2);
            len = hypot(pos1px(1) - pos2px(1), pos1px(2) - pos2px(2));
            
            % choose a number of points to have around 1 pixel spacing
            nValues = ceil(len) + 1;
            
            % compute (calibrated) position of sampling points
            x = linspace(pos1(1), pos2(1), nValues);
            y = linspace(pos1(2), pos2(2), nValues);
            pts = [x' y'];
            
            % use cumulative distance as abscissa
            dists = [0 cumsum(hypot(diff(x), diff(y)))];
            
        elseif isa(selection, 'LineString2D')
            % length of selection in pixel coordinates
            coords = vertexCoordinates(selection);
            coordsPx = pointToContinuousIndex(img, coords);
            
            poly2 = LineString2D(coordsPx);
            len = length(poly2);
            
            % choose a number of points to have around 1 pixel spacing
            nValues = ceil(len) + 1;
            
            % compute (calibrated) position of sampling points
            poly2 = resample(selection, nValues);
            
            % use cumulative distance as abscissa
            dists = verticesArcLength(poly2);
            pts = vertexCoordinates(poly2);
        else
            errordlg('Impossible to create line profile for %s selections with class ', class(selection));
        end

        % extract corresponding pixel values (linear interpolation)
        % new figure for display
        hf = figure;
        set(hf, 'NumberTitle', 'off');
        
        % display resulting curve(s)
        if isScalarImage(img)
            vals = interp(img, pts);
            plot(dists, vals);
            if isempty(img.ChannelNames)
                ylabel('Intensity');
            else
                ylabel(img.ChannelNames{1});
            end
            
        elseif isColorImage(img)
            % display each color histogram as stairs, to see the 3 curves
            vals = interp(img, pts);
            hh = stairs(dists, vals);
            
            % setup curve colors
            set(hh(1), 'color', [1 0 0]); % red
            set(hh(2), 'color', [0 1 0]); % green
            set(hh(3), 'color', [0 0 1]); % blue
            ylabel('Color intensity');
            if ~isempty(img.ChannelNames)
                legend(hh, img.ChannelNames);
            end
            
        elseif isVectorImage(img)
            % for vector images, display the profile of norm
            img2 = norm(img);
            vals = interp(img2, pts);
            plot(dists, vals);
            ylabel('Channels norm'); % TODO: use channel names for legend
            
        else
            warning('LineProfileTool:UnsupportedImageImageType', ...
                ['Can not manage images of type ' img.Type]);
        end
        
        % annotate plot
        if isempty(img.UnitName)
            xlabel('Position on line');
        else
            xlabel(sprintf('Position on line (%s)', img.UnitName));
        end
        
        if ~isempty(img.Name)
            title(img.Name);
            set(gcf, 'name', ['Profile of ' img.Name]);
        end
    end
end % end methods

end % end classdef

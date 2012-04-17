classdef ImageSelectionLineProfileAction < imagem.gui.actions.CurrentImageAction
%RENAMEIMAGEACTION  Plot line profile of current selection
%
%   Class ImageSelectionLineProfileAction
%
%   Example
%   ImageSelectionLineProfileAction
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
end % end properties


%% Constructor
methods
    function this = ImageSelectionLineProfileAction(viewer)
    % Constructor for ImageSelectionLineProfileAction class
    
        % calls the parent constructor
        this = this@imagem.gui.actions.CurrentImageAction(viewer, 'selectionLineProfile');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        
        viewer = this.viewer;
        selection = viewer.selection;
        if isempty(selection)
            return;
        end
        
        switch lower(selection.type)
            case 'linesegment'
                % determine the line end point
                pos1 = selection.data(1, 1:2);
                pos2 = selection.data(1, 3:4);
                len = hypot(pos1(1) - pos2(1), pos1(2) - pos2(2));
                
                nValues = ceil(len) + 1;
                x = linspace(pos1(1), pos2(1), nValues);
                y = linspace(pos1(2), pos2(2), nValues);
                dists = [0 cumsum(hypot(diff(x), diff(y)))];
                
                pts = [x' y'];
                
            case 'polyline'
                dx = diff(selection.data(:,1));
                dy = diff(selection.data(:,2));
                len = sum(hypot(dx, dy));
                
                nValues = ceil(len) + 1;
                pts = resamplePolyline(selection.data, nValues);
                
                dx = diff(pts(:,1));
                dy = diff(pts(:,2));
                dists = [0 cumsum(hypot(dx, dy))'];
                
            otherwise
                errordlg('Impossible to create line profile for %s selections', selection.type);
                return;
        end
        
        
        % extract corresponding pixel values (nearest-neighbor eval)
        img = viewer.doc.image;
        vals = interp(img, pts);
        

        % new figure for display
        figure;
        
        % display resulting curve(s)
        if isScalarImage(img)
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
        
    end
end % end methods

end % end classdef


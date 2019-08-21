classdef ZoomBestAction < imagem.gui.actions.CurrentImageAction
% Set zoom of current image viewer to the best possible one.
%
%   output = ZoomBestAction(input)
%
%   Example
%   ZoomBestAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function obj = ZoomBestAction(viewer)
        % calls the parent constructor
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, 'zoomBest');
    end
end

methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        
        % get handle to viewer figure
        viewer = obj.Viewer;
        
        % set up new zoom value
        zoom = findBestZoom(viewer);
        setCurrentZoomLevel(viewer, zoom);
        
        % update display
        updateTitle(viewer);
    end
end

end
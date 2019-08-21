classdef ZoomOutAction < imagem.gui.actions.CurrentImageAction
% Zoom out the current figure.
%
%   output = ZoomOutAction(input)
%
%   Example
%   ZoomOutAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function obj = ZoomOutAction(viewer)
        % calls the parent constructor
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, 'zoomOut');
    end
end

methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        
        % get handle to viewer figure
        viewer = obj.Viewer;
        
        % set up new zoom value
        zoom = currentZoomLevel(viewer);
        setCurrentZoomLevel(viewer, zoom / 2);
        
        % update display
        updateTitle(viewer);
    end
end

end
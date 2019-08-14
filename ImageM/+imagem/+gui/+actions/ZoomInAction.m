classdef ZoomInAction < imagem.gui.actions.CurrentImageAction
% Zoom in the current figure.
%
%   output = ZoomInAction(input)
%
%   Example
%   ZoomInAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function obj = ZoomInAction(viewer)
        % calls the parent constructor
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, 'zoomIn');
    end
end

methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        
        % get handle to viewer figure
        viewer = obj.Viewer;
        
        % set up new zoom value
        zoom = getZoom(viewer);
        setZoom(viewer, zoom * 2);
        
        % update display
        updateTitle(viewer);
    end
end

end
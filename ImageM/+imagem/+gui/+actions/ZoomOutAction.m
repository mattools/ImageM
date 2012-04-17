classdef ZoomOutAction < imagem.gui.actions.CurrentImageAction
%ZOOMINACTION Zoom out the current figure
%
%   output = ZoomOutAction(input)
%
%   Example
%   ZoomOutAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function this = ZoomOutAction(viewer)
        % calls the parent constructor
        this = this@imagem.gui.actions.CurrentImageAction(viewer, 'zoomOut');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        
        % get handle to viewer figure
        viewer = this.viewer;
        
        % set up new zoom value
        zoom = getZoom(viewer);
        setZoom(viewer, zoom / 2);
        
        % update display
        updateTitle(viewer);
    end
end

end
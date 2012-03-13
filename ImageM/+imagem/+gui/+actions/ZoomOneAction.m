classdef ZoomOneAction < imagem.gui.actions.CurrentImageAction
%ZOOMINACTION Set zoom of current image viewer to 1
%
%   output = ZoomOneAction(input)
%
%   Example
%   ZoomOneAction
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
    function this = ZoomOneAction(parent)
        % calls the parent constructor
        this = this@imagem.gui.actions.CurrentImageAction(parent, 'zoomOne');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        
        % get handle to parent figure
        viewer = this.parent;
        
        % set up new zoom value
        setZoom(viewer, 1);
        
        % update display
        updateTitle(viewer);
    end
end

end
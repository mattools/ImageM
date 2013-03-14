classdef ZoomChangeAction < imagem.gui.actions.CurrentImageAction
%ZOOMINACTION Set zoom of current image viewer to a chosen value
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

properties
    factor;
end

methods
    function this = ZoomChangeAction(viewer, factor)
        % calls the parent constructor
        this = this@imagem.gui.actions.CurrentImageAction(viewer, 'zoomChange');
        this.factor = factor;
        
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        
        % get handle to viewer figure
        viewer = this.viewer;
        
        % set up new zoom value
        setZoom(viewer, this.factor);
        
        % update display
        updateTitle(viewer);
    end
end

end
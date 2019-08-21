classdef ZoomChangeAction < imagem.gui.actions.CurrentImageAction
% Set zoom of current image viewer to a chosen value.
%
%   output = ZoomOneAction(input)
%
%   Example
%   ZoomOneAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    Factor;
end

methods
    function obj = ZoomChangeAction(viewer, factor)
        % calls the parent constructor
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, 'zoomChange');
        obj.Factor = factor;
        
    end
end

methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        
        % get handle to viewer figure
        viewer = obj.Viewer;
        
        % set up new zoom value
        setCurrentZoomLevel(viewer, obj.Factor);
        
        % update display
        updateTitle(viewer);
    end
end

end
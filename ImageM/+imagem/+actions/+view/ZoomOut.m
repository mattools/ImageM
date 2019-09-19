classdef ZoomOut < imagem.actions.CurrentImageAction
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
    function obj = ZoomOut()
    end
end

methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        
        % set up new zoom value
        zoom = currentZoomLevel(frame);
        setCurrentZoomLevel(frame, zoom / 2);
        
        % update display
        updateTitle(frame);
    end
end

end
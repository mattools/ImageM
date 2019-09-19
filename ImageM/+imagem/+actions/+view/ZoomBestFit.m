classdef ZoomBestFit < imagem.actions.CurrentImageAction
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
    function obj = ZoomBestFit()
    end
end

methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        
        % set up new zoom value
        zoom = findBestZoom(frame);
        setCurrentZoomLevel(frame, zoom);
        
        % update display
        updateTitle(frame);
    end
end

end
classdef ZoomOne < imagem.actions.CurrentImageAction
% Set zoom of current image viewer to 1.
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

methods
    function obj = ZoomOne()
    end
end

methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        
        % set up new zoom value
        setCurrentZoomLevel(frame, 1);
        
        % update display
        updateTitle(frame);
    end
end

end
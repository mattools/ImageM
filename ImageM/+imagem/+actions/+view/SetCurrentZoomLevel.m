classdef SetCurrentZoomLevel < imagem.actions.CurrentImageAction
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
    function obj = SetCurrentZoomLevel(factor)
        % calls the parent constructor
        obj.Factor = factor;
    end
end

methods
    function run(obj, frame) %#ok<INUSD>
        
        % set up new zoom value
        setCurrentZoomLevel(frame, obj.Factor);
        
        % update display
        updateTitle(frame);
    end
end

end
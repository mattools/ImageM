classdef ScalarImageAction < imagem.actions.CurrentImageAction
% Superclass for actions that require a scalar image.
%
%   output = ScalarImageAction(input)
%
%   Example
%   ScalarImageAction
%
%   See also
%     CurrentImageAction, BinaryImageAction
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function this = ScalarImageAction(varargin)
        % calls the parent constructor
        this = this@imagem.actions.CurrentImageAction(varargin{:});
    end
end

methods
    function b = isActivable(obj, frame)
        b = isActivable@imagem.actions.CurrentImageAction(obj, frame);
        b = b && isScalarImage(currentImage(frame));
    end
end

end
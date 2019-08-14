classdef ScalarImageAction < imagem.gui.actions.CurrentImageAction
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
    function this = ScalarImageAction(viewer, varargin)
        % calls the parent constructor
        this = this@imagem.gui.actions.CurrentImageAction(viewer, varargin{:});
    end
end

methods
    function b = isActivable(obj)
        b = isActivable@imagem.gui.actions.CurrentImageAction(obj);
        b = b && isScalarImage(currentImage(obj));
    end
end

end
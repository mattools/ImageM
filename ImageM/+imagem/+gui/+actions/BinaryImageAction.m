classdef BinaryImageAction < imagem.gui.actions.CurrentImageAction
% Superclass for actions that require a binary image.
%
%   output = BinaryImageAction(input)
%
%   Example
%   BinaryImageAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function obj = BinaryImageAction(viewer, varargin)
        % calls the parent constructor
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, varargin{:});
    end
end

methods
    function b = isActivable(obj)
        b = isActivable@imagem.gui.actions.CurrentImageAction(obj);
        if b
            b = isBinaryImage(currentImage(obj));
        end
    end
end

end
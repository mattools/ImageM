classdef BinaryImageAction < imagem.actions.CurrentImageAction
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
    function obj = BinaryImageAction(varargin)
        % calls the parent constructor
        obj = obj@imagem.actions.CurrentImageAction(varargin{:});
    end
end

methods
    function b = isActivable(obj, frame)
        b = isActivable@imagem.actions.CurrentImageAction(obj, frame);
        if b
            b = isBinaryImage(currentImage(frame));
        end
    end
end

end
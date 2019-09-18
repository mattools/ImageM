classdef VectorImageAction < imagem.actions.CurrentImageAction
%Superclass for actions that require a vector image as current image.
%
%   output = VectorImageAction(input)
%
%   Example
%   VectorImageAction
%
%   See also
%
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function this = VectorImageAction(varargin)
        % calls the parent constructor
        this = this@imagem.actions.CurrentImageAction(varargin{:});
    end
end

methods
    function b = isActivable(obj, frame)
        b = isActivable@imagem.actions.CurrentImageAction(obj, frame);
        b = b && isVectorImage(frame.Doc.Image);
    end
end

end
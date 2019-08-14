classdef VectorImageAction < imagem.gui.actions.CurrentImageAction
%Superclass for actions that require a vector image as current image
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
    function this = VectorImageAction(viewer, varargin)
        % calls the parent constructor
        this = this@imagem.gui.actions.CurrentImageAction(viewer, varargin{:});
    end
end

methods
    function b = isActivable(obj)
        b = isActivable@imagem.gui.actions.CurrentImageAction(obj);
        b = b && isVectorImage(obj.Viewer.Doc.Image);
    end
end

end
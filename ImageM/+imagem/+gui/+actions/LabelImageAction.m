classdef LabelImageAction < imagem.gui.actions.ScalarImageAction
% Superclass for actions that require a label image.
%
%   output = LabelImageAction(input)
%
%   Example
%   ScalarImageAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function obj = LabelImageAction(viewer, varargin)
        % calls the parent constructor
        obj = obj@imagem.gui.actions.ScalarImageAction(viewer, varargin{:});
    end
end

methods
    function b = isActivable(obj)
        b = isActivable@imagem.gui.actions.ScalarImageAction(obj);
        if b
            b = isLabelImage(currentImage(obj));
        end
    end
end

end
classdef LabelImageAction < imagem.gui.actions.ScalarImageAction
%LABELIMAGEACTION Superclass for actions that require a label image
%
%   output = LabelImageAction(input)
%
%   Example
%   ScalarImageAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-03-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function this = LabelImageAction(parent, varargin)
        % calls the parent constructor
        this = this@imagem.gui.actions.ScalarImageAction(parent, varargin{:});
    end
end

methods
    function b = isActivable(this)
        b = isActivable@imagem.gui.actions.ScalarImageAction(this);
        b = b && isLabelImage(this.parent.doc.image);
    end
end

end
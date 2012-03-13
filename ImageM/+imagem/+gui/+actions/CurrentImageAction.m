classdef CurrentImageAction < imagem.gui.ImagemAction
%INVERTIMAGEACTION Superclass for actions that require a current image
%
%   output = CurrentImageAction(input)
%
%   Example
%   CurrentImageAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-03-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function this = CurrentImageAction(parent, varargin)
        % calls the parent constructor
        this = this@imagem.gui.ImagemAction(parent, varargin{:});
    end
end

methods
    function b = isActivable(this)
        doc = this.parent.doc;
        b = ~isempty(doc) && ~isempty(doc.image);
    end
end

end
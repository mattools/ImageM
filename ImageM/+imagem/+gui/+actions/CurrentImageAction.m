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
% Created: 2012-03-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function this = CurrentImageAction(viewer, varargin)
        % calls the parent constructor
        this = this@imagem.gui.ImagemAction(viewer, varargin{:});
    end
end

methods
    function b = isActivable(this)
        doc = this.viewer.doc;
        b = ~isempty(doc) && ~isempty(doc.image);
    end
end

end
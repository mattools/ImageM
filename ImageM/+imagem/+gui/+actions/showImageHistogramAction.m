classdef showImageHistogramAction < imagem.gui.ImagemAction
%SHOWIMAGEHISTOGRAMACTION Display histogram of current image
%
%   output = showImageHistogramAction(input)
%
%   Example
%   showImageHistogramAction
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
    function this = showImageHistogramAction(varargin)
        % calls the parent constructor
        this = this@imagem.gui.ImagemAction(varargin{:});
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('Show image histogram');
        
        % get handle to parent figure, and current doc
        viewer = this.parent;
        doc = viewer.doc;
        
        % open figure to display histogram
        figure;
        histogram(doc.image);

    end
end

end
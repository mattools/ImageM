classdef ImageGradientAction < imagem.gui.ImagemAction
%IMAGEGRADIENTACTION Compute and display gradient of current image
%
%   output = ImageGradientAction(input)
%
%   Example
%   ImageGradientAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-11-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function this = ImageGradientAction(parent, varargin)
        % calls the parent constructor
        this = this@imagem.gui.ImagemAction(parent, 'imageGradient');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('Compute Image gradient');
        
        % get handle to parent figure, and current doc
        viewer = this.parent;
        doc = viewer.doc;
        
        % apply 'gradient' operation
        img2 = gradient(doc.image);
        
        % add image to application, and create new display
        addImageDocument(viewer.gui, img2);
    end
end

methods
    function b = isActivable(this)
        doc = this.parent.doc;
        b = ~isempty(doc.image) && isScalarImage(doc.image);
    end
end

end
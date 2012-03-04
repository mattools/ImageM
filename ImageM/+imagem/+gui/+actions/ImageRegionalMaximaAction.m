classdef ImageRegionalMaximaAction < imagem.gui.ImagemAction
%IMAGEEXTENDEDMAXIMAACTION Extract extended maxima in a grayscale image
%
%   output = ImageRegionalMaximaAction(input)
%
%   Example
%   ImageRegionalMaximaAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-11-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
end

methods
    function this = ImageRegionalMaximaAction(parent)
        % calls the parent constructor
        this = this@imagem.gui.ImagemAction(parent, 'regionalMaxima');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('apply regional maxima to current image');
        
        % get handle to parent figure, and current doc
        viewer = this.parent;
        img = viewer.doc.image;
        
        if ~isScalarImage(img)
            warning('ImageM:WrongImageType', ...
                'Regional maxima can be applied only on scalar images');
            return;
        end
        
        app = viewer.gui.app;
        conn = getDefaultConnectivity(app, ndims(img));
        bin = regionalMaxima(img, conn);
        
        addImageDocument(this.parent.gui, bin);
        
    end    
end


methods
    function b = isActivable(this)
        doc = this.parent.doc;
        b = ~isempty(doc.image) && isScalarImage(doc.image);
    end
end

end
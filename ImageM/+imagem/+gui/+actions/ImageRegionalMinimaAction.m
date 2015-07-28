classdef ImageRegionalMinimaAction < imagem.gui.actions.ScalarImageAction
%IMAGEEXTENDEDMINIMAACTION Extract extended minima in a grayscale image
%
%   output = ImageRegionalMinimaAction(input)
%
%   Example
%   ImageRegionalMinimaAction
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
    function this = ImageRegionalMinimaAction(viewer)
        % calls the parent constructor
        this = this@imagem.gui.actions.ScalarImageAction(viewer, 'regionalMinima');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        % apply regional minima to current image
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        img = viewer.doc.image;
        
        if ~isScalarImage(img)
            warning('ImageM:WrongImageType', ...
                'Regional minima can be applied only on scalar images');
            return;
        end
        
        app = viewer.gui.app;
        conn = getDefaultConnectivity(app, ndims(img));

        bin = regionalMinima(img, conn);
        newDoc = addImageDocument(this.viewer.gui, bin, [], 'rmin');
        
        % add history
        string = sprintf('%s = regionalMinima(%s, %d);\n', ...
            newDoc.tag, this.viewer.doc.tag, conn);
        addToHistory(this.viewer.gui.app, string);
    end    
end


end
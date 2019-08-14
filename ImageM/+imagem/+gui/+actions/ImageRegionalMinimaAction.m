classdef ImageRegionalMinimaAction < imagem.gui.actions.ScalarImageAction
% Extract regional minima in a grayscale image
%
%   output = ImageRegionalMinimaAction(input)
%
%   Example
%   ImageRegionalMinimaAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-11-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
end

methods
    function obj = ImageRegionalMinimaAction(viewer)
        % calls the parent constructor
        obj = obj@imagem.gui.actions.ScalarImageAction(viewer, 'regionalMinima');
    end
end

methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        % apply regional minima to current image
        
        % get handle to viewer figure, and current doc
        viewer = obj.Viewer;
        
        img = currentImage(obj);
        if ~isScalarImage(img)
            warning('ImageM:WrongImageType', ...
                'Regional minima can be applied only on scalar images');
            return;
        end
        
        app = viewer.Gui.App;
        conn = getDefaultConnectivity(app, ndims(img));

        bin = regionalMinima(img, conn);
        newDoc = addImageDocument(obj, bin, [], 'rmin');
        
        % add history
        string = sprintf('%s = regionalMinima(%s, %d);\n', ...
            newDoc.Tag, obj.Viewer.Doc.Tag, conn);
        addToHistory(obj, string);
    end    
end


end
classdef ImageRegionalMaximaAction < imagem.gui.actions.ScalarImageAction
% Extract extended maxima in a grayscale image.
%
%   output = ImageRegionalMaximaAction(input)
%
%   Example
%   ImageRegionalMaximaAction
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
    function obj = ImageRegionalMaximaAction(viewer)
        % calls the parent constructor
        obj = obj@imagem.gui.actions.ScalarImageAction(viewer, 'regionalMaxima');
    end
end

methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        % apply regional maxima to current image
        
        % get handle to viewer figure, and current doc
        viewer = obj.Viewer;
        img = currentImage(obj);
        
        if ~isScalarImage(img)
            warning('ImageM:WrongImageType', ...
                'Regional maxima can be applied only on scalar images');
            return;
        end
        
        app = viewer.Gui.App;
        conn = getDefaultConnectivity(app, ndims(img));
        bin = regionalMaxima(img, conn);
        
        newDoc = addImageDocument(obj.Viewer.Gui, bin, [], 'rmax');
        
        % add history
        string = sprintf('%s = regionalMaxima(%s, %d);\n', ...
            newDoc.Tag, obj.Viewer.Doc.Tag, conn);
        addToHistory(app, string);

    end    
end

end
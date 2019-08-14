classdef ImageOpeningAction < imagem.gui.actions.CurrentImageAction
% Apply morphological opening on current image.
%
%   output = ImageOpeningAction(input)
%
%   Example
%   ImageOpeningAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-09,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function obj = ImageOpeningAction(viewer, varargin)
        % calls the parent constructor
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, 'imageOpening');
    end
end

methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        % Compute Image opening
        
        % get handle to current doc
        doc = currentDoc(obj);
        
        % compute result image
        se = ones(3, 3);
        img2 = opening(doc.Image, se);
        
        % add image to application, and create new display
        newDoc = addImageDocument(obj, img2);
        
        % add history
        string = sprintf('%s = opening(%s, ones(3,3));\n', ...
            newDoc.Tag, doc.Tag);
        addToHistory(obj, string);
    end
end

end
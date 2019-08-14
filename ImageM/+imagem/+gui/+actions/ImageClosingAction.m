classdef ImageClosingAction < imagem.gui.actions.CurrentImageAction
% Morphological closing on current image.
%
%   output = ImageClosingAction(input)
%
%   Example
%   ImageClosingAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-09,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function obj = ImageClosingAction(viewer, varargin)
        % calls the parent constructor
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, 'imageClosing');
    end
end

methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        % apply 'closing' operation
        
        % get handle to current doc
        doc = currentDoc(obj);
        
        se = ones(3, 3);
        
        img2 = closing(doc.Image, se);
        
        % add image to application, and create new display
        newDoc = addImageDocument(obj, img2);
        
        % add history
        string = sprintf('%s = closing(%s, ones(3,3));\n', ...
            newDoc.Tag, doc.Tag);
        addToHistory(obj, string);
    end
end

end
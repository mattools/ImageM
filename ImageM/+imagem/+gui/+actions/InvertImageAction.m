classdef InvertImageAction < imagem.gui.actions.CurrentImageAction
% Invert the current image.
%
%   output = InvertImageAction(input)
%
%   Example
%   InvertImageAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-03-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function obj = InvertImageAction(viewer)
        % calls the parent constructor
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, 'invertImage');
    end
end

methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        
        % get handle to viewer figure, and current doc
        doc = currentDoc(obj);
        
        % apply 'invert' operation
        img2 = invert(currentImage(obj));
        
        % add image to application, and create new display
        newDoc = addImageDocument(obj, img2);
        
        % history
        string = sprintf('%s = invert(%s);\n', newDoc.Tag, doc.Tag);
        addToHistory(obj, string);
    end
end

end
classdef InvertImageAction < imagem.gui.actions.CurrentImageAction
%INVERTIMAGEACTION  Invert the current image
%
%   output = InvertImageAction(input)
%
%   Example
%   InvertImageAction
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
    function this = InvertImageAction(viewer)
        % calls the parent constructor
        this = this@imagem.gui.actions.CurrentImageAction(viewer, 'invertImage');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;
        
        % apply 'invert' operation
        img2 = invert(doc.image);
        
        % add image to application, and create new display
        newDoc = addImageDocument(viewer.gui, img2);
        
        % history
        string = sprintf('%s = invert(%s);\n', newDoc.tag, doc.tag);
        addToHistory(this.viewer.gui.app, string);
    end
end

end
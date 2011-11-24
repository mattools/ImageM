classdef InvertImageAction < imagem.gui.ImagemAction
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
    function this = InvertImageAction(parent)
        % calls the parent constructor
        this = this@imagem.gui.ImagemAction(parent, 'invertImage');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('Inverts the image');
        
        % get handle to parent figure, and current doc
        viewer = this.parent;
        doc = viewer.doc;
        
        % apply 'invert' operation
        img2 = invert(doc.image);
        
        % add image to application, and create new display
        addImageDocument(viewer.gui, img2);
    end
end

end
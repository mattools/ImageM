classdef ImageClosingAction < imagem.gui.actions.CurrentImageAction
%IMAGECLOSINGACTION  One-line description here, please.
%
%   output = ImageClosingAction(input)
%
%   Example
%   ImageClosingAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-09,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function this = ImageClosingAction(viewer, varargin)
        % calls the parent constructor
        this = this@imagem.gui.actions.CurrentImageAction(viewer, 'imageClosing');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        % apply 'closing' operation
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;
        
        se = ones(3, 3);
        
        img2 = closing(doc.image, se);
        
        % add image to application, and create new display
        newDoc = addImageDocument(viewer.gui, img2);
        
        % add history
        string = sprintf('%s = closing(%s, ones(3,3));\n', ...
            newDoc.tag, doc.tag);
        addToHistory(this.viewer.gui.app, string);
    end
end

end
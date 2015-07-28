classdef ImageDilationAction < imagem.gui.actions.CurrentImageAction
%IMAGEDILATIONACTION  One-line description here, please.
%
%   output = ImageDilationAction(input)
%
%   Example
%   ImageDilationAction
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
    function this = ImageDilationAction(viewer, varargin)
        % calls the parent constructor
        this = this@imagem.gui.actions.CurrentImageAction(viewer, 'imageDilation');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        % apply 'gradient' operation
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;
        
        % compute dilation
        se = ones(3, 3);
        img2 = dilation(doc.image, se);
        
        % add image to application, and create new display
        newDoc = addImageDocument(viewer.gui, img2);
        
        % add history
        string = sprintf('%s = dilation(%s, ones(3,3));\n', ...
            newDoc.tag, doc.tag);
        addToHistory(this.viewer.gui.app, string);
    end
end

end
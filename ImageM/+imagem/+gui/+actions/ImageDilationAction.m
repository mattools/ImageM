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
    function this = ImageDilationAction(parent, varargin)
        % calls the parent constructor
        this = this@imagem.gui.actions.CurrentImageAction(parent, 'imageDilation');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('Compute Image dilation');
        
        % get handle to parent figure, and current doc
        viewer = this.parent;
        doc = viewer.doc;
        
        se = ones(3, 3);
        
        % apply 'gradient' operation
        img2 = dilation(doc.image, se);
        
        % add image to application, and create new display
        addImageDocument(viewer.gui, img2);
    end
end

end
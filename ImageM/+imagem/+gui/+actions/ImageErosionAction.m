classdef ImageErosionAction < imagem.gui.actions.CurrentImageAction
%IMAGEEROSIONACTION  One-line description here, please.
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
    function this = ImageErosionAction(parent, varargin)
        % calls the parent constructor
        this = this@imagem.gui.actions.CurrentImageAction(parent, 'imageErosion');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('Compute Image erosion');
        
        % get handle to parent figure, and current doc
        viewer = this.parent;
        doc = viewer.doc;
        
        se = ones(3, 3);
        
        % apply 'gradient' operation
        img2 = erosion(doc.image, se);
        
        % add image to application, and create new display
        addImageDocument(viewer.gui, img2);
    end
end

end
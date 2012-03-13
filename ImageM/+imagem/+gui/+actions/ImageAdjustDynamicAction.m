classdef ImageAdjustDynamicAction < imagem.gui.actions.CurrentImageAction
%IMAGENORMACTION Compute norm of current image
%
%   output = ImageAdjustDynamicAction(input)
%
%   Example
%   ImageAdjustDynamicAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-03-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function this = ImageAdjustDynamicAction(parent, varargin)
        % calls the parent constructor
        this = this@imagem.gui.actions.CurrentImageAction(parent, 'adjustDynamic');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('Adjust image dynamic');
        
        % get handle to parent figure, and current doc
        viewer = this.parent;
        doc = viewer.doc;
        
        % apply 'norm' operation
        img2 = adjustDynamic(doc.image);
        
        % add image to application, and create new display
        addImageDocument(viewer.gui, img2);
    end
end

methods
    function b = isActivable(this)
        doc = this.parent.doc;
        b = ~isempty(doc.image) && isScalarImage(doc.image);
    end
end

end
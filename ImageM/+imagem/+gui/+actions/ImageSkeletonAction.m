classdef ImageSkeletonAction < imagem.gui.ImagemAction
%IMAGESKELETONACTION  One-line description here, please.
%
%   Class ImageSkeletonAction
%
%   Example
%   ImageSkeletonAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-15,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function this = ImageSkeletonAction(parent)
    % Constructor for ImageSkeletonAction class
        this = this@imagem.gui.ImagemAction(parent, 'imageSkeleton');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('Compute Image skeleton');
        
        % get handle to parent figure, and current doc
        viewer = this.parent;
        doc = viewer.doc;
        
        % compute Image skeleton
        img2 = skeleton(doc.image);
%         img2.name = [doc.image.name '-skeleton'];
        
        % add image to application, and create new display
        addImageDocument(viewer.gui, img2);
    end
end % end methods

methods
    function b = isActivable(this)
        doc = this.parent.doc;
        b = ~isempty(doc.image) && isBinaryImage(doc.image);
    end
end

end % end classdef


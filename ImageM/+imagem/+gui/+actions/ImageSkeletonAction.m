classdef ImageSkeletonAction < imagem.gui.actions.BinaryImageAction
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
    function this = ImageSkeletonAction(viewer)
    % Constructor for ImageSkeletonAction class
        this = this@imagem.gui.actions.BinaryImageAction(viewer, 'imageSkeleton');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('Compute Image skeleton');
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;
        
        % compute Image skeleton
        img2 = skeleton(doc.image);
%         img2.name = [doc.image.name '-skeleton'];
        
        % add image to application, and create new display
        addImageDocument(viewer.gui, img2);
    end
end % end methods

end % end classdef


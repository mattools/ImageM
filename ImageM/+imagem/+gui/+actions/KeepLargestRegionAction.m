classdef KeepLargestRegionAction < imagem.gui.actions.CurrentImageAction
%KILLIMAGEBORDERSACTION Kill borders of a binary image
%
%   Class keepLargestRegionAction
%
%   Example
%   keepLargestRegionAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-05-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function this = KeepLargestRegionAction(viewer)
    % Constructor for keepLargestRegionAction class
        this = this@imagem.gui.actions.CurrentImageAction(viewer, 'imageLargestRegion');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('keep largest region');
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;
        
        % compute Image skeleton
        img2 = largestRegion(doc.image);
        
        % add image to application, and create new display
        addImageDocument(viewer.gui, img2);
    end
end % end methods

methods
    function b = isActivable(this)
        b = isActivable@imagem.gui.actions.CurrentImageAction(this);
        if b
            img = this.viewer.doc.image;
            binFlag = isBinaryImage(img);
            lblFlag = isLabelImage(img);
            b = b && (binFlag || lblFlag);
        end
    end
end

end % end classdef


classdef ImageMedianFilter3x3Action < imagem.gui.actions.CurrentImageAction
%IMAGEMEDIANFILTER3X3 Apply a simple filter on current image
%
%   Class ImageMedianFilter3x3Action
%
%   Example
%   ImageMedianFilter3x3Action
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Constructor
methods
    function this = ImageMedianFilter3x3Action(viewer)
    % Constructor for the parent class
        this = this@imagem.gui.actions.CurrentImageAction(viewer, 'medianFilter');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('Compute Image median filter');
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;
        
        se = ones(3, 3);
        
        % apply 'median' operation
        img2 = medianFilter(doc.image, se);
        
        % add image to application, and create new display
        addImageDocument(viewer.gui, img2);
    end
end % end methods

end % end classdef


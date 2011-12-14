classdef ImageMeanFilter3x3Action < imagem.gui.ImagemAction
%IMAGEMEDIANFILTER3X3  One-line description here, please.
%
%   Class ImageMeanFilter3x3Action
%
%   Example
%   ImageMeanFilter3x3Action
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
    function this = ImageMeanFilter3x3Action(parent)
    % Constructor for ImageMeanFilter3x3Action class
        this = this@imagem.gui.ImagemAction(parent, 'meanFilter');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('Compute Image mean filter');
        
        % get handle to parent figure, and current doc
        viewer = this.parent;
        doc = viewer.doc;
        
        se = ones(3, 3);
        
        % apply 'mean' operation
        img2 = meanFilter(doc.image, se);
        
        % add image to application, and create new display
        addImageDocument(viewer.gui, img2);
    end
end % end methods

end % end classdef


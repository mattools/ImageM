classdef ImageMeanFilter3x3Action < imagem.gui.actions.CurrentImageAction
%IMAGEMEDIANFILTER3X3  Apply a simple filter on current image
%
%   Deprecated, see the class "ImagBoxMeanFilterAction"
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
    function this = ImageMeanFilter3x3Action(viewer)
    % Constructor for ImageMeanFilter3x3Action class
        this = this@imagem.gui.actions.CurrentImageAction(viewer, 'meanFilter');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('Compute Image mean filter');
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;
        
        se = ones(3, 3);
        
        % apply 'mean' operation
        img2 = meanFilter(doc.image, se);
        
        % add image to application, and create new display
        newDoc = addImageDocument(viewer.gui, img2);
        
        % add history
        string = sprintf('%s = meanFilter(%s, ones(3,3));\n', ...
            newDoc.tag, doc.tag);
        addToHistory(this.viewer.gui.app, string);

    end
end % end methods

end % end classdef


classdef ImageOpeningAction < imagem.gui.actions.CurrentImageAction
%IMAGEOPENINGACTION  One-line description here, please.
%
%   output = ImageOpeningAction(input)
%
%   Example
%   ImageOpeningAction
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
    function this = ImageOpeningAction(viewer, varargin)
        % calls the parent constructor
        this = this@imagem.gui.actions.CurrentImageAction(viewer, 'imageOpening');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        % Compute Image opening
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;
        
        se = ones(3, 3);
        
        % compute result image
        img2 = opening(doc.image, se);
        
        % add image to application, and create new display
        newDoc = addImageDocument(viewer.gui, img2);
        
        % add history
        string = sprintf('%s = opening(%s, ones(3,3));\n', ...
            newDoc.tag, doc.tag);
        addToHistory(this.viewer.gui, string);
    end
end

end
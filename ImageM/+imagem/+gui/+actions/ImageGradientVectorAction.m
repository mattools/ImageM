classdef ImageGradientVectorAction < imagem.gui.actions.ScalarImageAction
%IMAGEGRADIENTACTION Compute gradient of current image as vector image
%
%   output = ImageGradientVectorAction(input)
%
%   Example
%   ImageGradientVectorAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-02-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function this = ImageGradientVectorAction(viewer, varargin)
        % calls the parent constructor
        this = this@imagem.gui.actions.ScalarImageAction(viewer, 'imageGradientVector');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>

        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;
        
        % apply 'gradient' operation
        grad = gradient(doc.image);
        
        % add image to application, and create new display
        newDoc = addImageDocument(viewer.gui, grad);
        
        % add history
        string = sprintf('%s = gradient(%s);\n', newDoc.tag, doc.tag);
        addToHistory(viewer.gui, string);
    end
end


end
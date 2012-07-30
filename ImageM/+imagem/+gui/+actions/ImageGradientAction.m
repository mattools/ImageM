classdef ImageGradientAction < imagem.gui.actions.ScalarImageAction
%IMAGEGRADIENTACTION Compute gradient norm of current image
%
%   output = ImageGradientAction(input)
%
%   Example
%   ImageGradientAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-11-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function this = ImageGradientAction(viewer, varargin)
        % calls the parent constructor
        this = this@imagem.gui.actions.ScalarImageAction(viewer, 'imageGradient');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;
        
        % apply 'gradient' operation
        gradn = norm(gradient(doc.image));
        
        % add image to application, and create new display
        newDoc = addImageDocument(viewer.gui, gradn);
        
        % add history
        string = sprintf('%s = norm(gradient(%s));\n', newDoc.tag, doc.tag);
        addToHistory(viewer.gui, string);
    end
end

end
classdef ImageGradientVectorAction < imagem.gui.actions.ScalarImageAction
% Compute gradient of current image as vector image.
%
%   output = ImageGradientVectorAction(input)
%
%   Example
%   ImageGradientVectorAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-02-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function obj = ImageGradientVectorAction(viewer, varargin)
        % calls the parent constructor
        obj = obj@imagem.gui.actions.ScalarImageAction(viewer, 'imageGradientVector');
    end
end

methods
    function actionPerformed(obj, src, event) %#ok<INUSD>

        % get handle to current doc
        doc = currentDoc(obj);
        
        % apply 'gradient' operation
        grad = gradient(doc.Image);
        
        % add image to application, and create new display
        newDoc = addImageDocument(obj, grad);
        
        % add history
        string = sprintf('%s = gradient(%s);\n', newDoc.Tag, doc.Tag);
        addToHistory(obj, string);
    end
end


end
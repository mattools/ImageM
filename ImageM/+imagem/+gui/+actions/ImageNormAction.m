classdef ImageNormAction < imagem.gui.actions.VectorImageAction
% Compute norm of current (multi-channel) image
%
%   output = ImageNormAction(input)
%
%   Example
%   ImageNormAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-03-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function obj = ImageNormAction(viewer, varargin)
        % calls the parent constructor
        obj = obj@imagem.gui.actions.VectorImageAction(viewer, 'imageNorm');
    end
end

methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        
        % get handle to current doc
        doc = currentDoc(obj);
        
        % apply 'norm' operation
        img2 = norm(doc.Image);
        
        % add image to application, and create new display
        newDoc = addImageDocument(obj, img2);

        % add history
        string = sprintf('%s = norm(%s);\n', newDoc.Tag, doc.Tag);
        addToHistory(obj, string);

    end
end

end
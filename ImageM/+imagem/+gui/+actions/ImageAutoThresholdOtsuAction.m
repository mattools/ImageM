classdef ImageAutoThresholdOtsuAction < imagem.gui.actions.ScalarImageAction
% Threshold image using Otsu method.
%
%   output = ImageAutoThresholdOtsuAction(input)
%
%   Example
%   ImageAutoThresholdOtsuAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-04-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function obj = ImageAutoThresholdOtsuAction(viewer, varargin)
        % calls the parent constructor
        obj = obj@imagem.gui.actions.ScalarImageAction(viewer, 'imageOtsuThreshold');
    end
end

methods
    function actionPerformed(obj, src, event) %#ok<INUSD>

        % get handle to current doc
        doc = currentDoc(obj);
        
        % apply 'gradient' operation
        bin = otsuThreshold(doc.Image);
        
        % add image to application, and create new display
        newDoc = addImageDocument(obj, bin);
        
        % add history
        string = sprintf('%s = otsuThreshold(%s);\n', newDoc.Tag, doc.Tag);
        addToHistory(obj, string);

    end
end

end
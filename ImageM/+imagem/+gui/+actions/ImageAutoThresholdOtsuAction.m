classdef ImageAutoThresholdOtsuAction < imagem.gui.actions.ScalarImageAction
%IMAGEAUTOTHRESHOLDOTSUACTION Threshold image using Otsu method
%
%   output = ImageAutoThresholdOtsuAction(input)
%
%   Example
%   ImageAutoThresholdOtsuAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-04-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function this = ImageAutoThresholdOtsuAction(viewer, varargin)
        % calls the parent constructor
        this = this@imagem.gui.actions.ScalarImageAction(viewer, 'imageOtsuThreshold');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;
        
        % apply 'gradient' operation
        bin = otsuThreshold(doc.image);
        
        % add image to application, and create new display
        newDoc = addImageDocument(viewer.gui, bin);
        
        % add history
        string = sprintf('%s = otsuThreshold(%s);\n', newDoc.tag, doc.tag);
        addToHistory(viewer.gui.app, string);

    end
end

end
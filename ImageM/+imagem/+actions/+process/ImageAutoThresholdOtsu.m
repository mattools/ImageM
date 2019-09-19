classdef ImageAutoThresholdOtsu < imagem.actions.ScalarImageAction
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
    function obj = ImageAutoThresholdOtsu(varargin)
        % calls the parent constructor
        obj = obj@imagem.actions.ScalarImageAction(varargin{:});
    end
end

methods
    function run(obj, frame) %#ok<INUSL,INUSD>

        % get handle to current doc
        doc = currentDoc(frame);
        
        % apply 'gradient' operation
        bin = otsuThreshold(doc.Image);
        
        % add image to application, and create new display
        newDoc = addImageDocument(frame, bin);
        
        % add history
        string = sprintf('%s = otsuThreshold(%s);\n', newDoc.Tag, doc.Tag);
        addToHistory(frame, string);

    end
end

end
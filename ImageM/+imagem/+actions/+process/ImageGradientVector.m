classdef ImageGradientVector < imagem.actions.ScalarImageAction
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
    function obj = ImageGradientVector()
    end
end

methods
    function run(obj, frame) %#ok<INUSL,INUSD>

        % get handle to current doc
        doc = currentDoc(frame);
        
        % apply 'gradient' operation
        grad = gradient(doc.Image);
        
        % add image to application, and create new display
        newDoc = addImageDocument(frame, grad);
        
        % add history
        string = sprintf('%s = gradient(%s);\n', newDoc.Tag, doc.Tag);
        addToHistory(frame, string);
    end
end


end
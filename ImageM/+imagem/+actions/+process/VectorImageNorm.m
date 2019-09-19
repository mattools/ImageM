classdef VectorImageNorm < imagem.actions.VectorImageAction
% Compute norm of current (multi-channel) image.
%
%   output = VectorImageNorm(input)
%
%   Example
%   VectorImageNorm
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-03-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function obj = VectorImageNorm()
    end
end

methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        
        % get handle to current doc
        doc = currentDoc(frame);
        
        % apply 'norm' operation
        img2 = norm(doc.Image);
        
        % add image to application, and create new display
        newDoc = addImageDocument(frame, img2);

        % add history
        string = sprintf('%s = norm(%s);\n', newDoc.Tag, doc.Tag);
        addToHistory(frame, string);
    end
end

end
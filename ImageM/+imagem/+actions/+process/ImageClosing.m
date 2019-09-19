classdef ImageClosing < imagem.actions.CurrentImageAction
% Morphological closing on current image.
%
%   output = ImageClosing(input)
%
%   Example
%   ImageClosing
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-09,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function obj = ImageClosing()
    end
end

methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        % apply 'closing' operation
        
        % get handle to current doc
        doc = currentDoc(frame);
        
        se = ones(3, 3);
        
        img2 = closing(doc.Image, se);
        
        % add image to application, and create new display
        newDoc = addImageDocument(frame, img2);
        
        % add history
        string = sprintf('%s = closing(%s, ones(3,3));\n', ...
            newDoc.Tag, doc.Tag);
        addToHistory(frame, string);
    end
end

end
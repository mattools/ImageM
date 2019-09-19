classdef ImageDilation < imagem.actions.CurrentImageAction
% Morpohlogical dilation of current image.
%
%   output = ImageDilation(input)
%
%   Example
%   ImageDilation
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-09,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function obj = ImageDilation()
    end
end

methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        % apply morphological dilation operation
        
        % get handle to current doc
        doc = currentDoc(frame);
        
        % compute dilation
        se = ones(3, 3);
        img2 = dilation(doc.Image, se);
        
        % add image to application, and create new display
        newDoc = addImageDocument(frame, img2);
        
        % add history
        string = sprintf('%s = dilation(%s, ones(3,3));\n', ...
            newDoc.Tag, doc.Tag);
        addToHistory(frame, string);
    end
end

end
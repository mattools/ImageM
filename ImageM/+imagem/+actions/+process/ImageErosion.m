classdef ImageErosion < imagem.actions.CurrentImageAction
% Morphological erosion of current image.
%
%   output = ImageErosion(input)
%
%   Example
%   ImageDilationAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-09,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function obj = ImageErosion()
    end
end

methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        % Compute Image erosion
        
        % get handle to current doc
        doc = currentDoc(frame);
        
        se = ones(3, 3);
        
        % compute result image
        img2 = erosion(doc.Image, se);
        
        % add image to application, and create new display
        newDoc = addImageDocument(frame, img2);
        
        % add history
        string = sprintf('%s = erosion(%s, ones(3,3));\n', ...
            newDoc.Tag, doc.Tag);
        addToHistory(frame, string);
    end
end

end
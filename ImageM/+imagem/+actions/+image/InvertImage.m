classdef InvertImage < imagem.actions.CurrentImageAction
% Invert the current image.
%
%   output = InvertImageAction(input)
%
%   Example
%   InvertImageAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-03-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function obj = InvertImage()
    end
end

methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        
        % get handle to viewer figure, and current doc
        doc = currentDoc(frame);
        
        % apply 'invert' operation
        img2 = invert(currentImage(frame));
        
        % add image to application, and create new display
        newDoc = addImageDocument(frame, img2);
        
        % copy display settings
        newDoc.ColorMap = doc.ColorMap;
        newDoc.ColorMapName = doc.ColorMapName;
        newDoc.BackgroundColor = doc.BackgroundColor;
        
        % history
        string = sprintf('%s = invert(%s);\n', newDoc.Tag, doc.Tag);
        addToHistory(frame, string);
    end
end

end
classdef ImageRegionalMaxima < imagem.actions.ScalarImageAction
% Extract extended maxima in a grayscale image.
%
%   output = ImageRegionalMaximaAction(input)
%
%   Example
%   ImageRegionalMaximaAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-11-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
end

methods
    function obj = ImageRegionalMaxima()
    end
end

methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        % apply regional maxima to current image
        
        % get handle to viewer figure, and current doc
        img = currentImage(frame);
        
        if ~isScalarImage(img)
            warning('ImageM:WrongImageType', ...
                'Regional maxima can be applied only on scalar images');
            return;
        end
        
        app = frame.Gui.App;
        conn = getDefaultConnectivity(app, ndims(img));
        bin = regionalMaxima(img, conn);
        
        newDoc = addImageDocument(frame.Gui, bin, [], 'rmax');
        
        % add history
        string = sprintf('%s = regionalMaxima(%s, %d);\n', ...
            newDoc.Tag, frame.Doc.Tag, conn);
        addToHistory(frame, string);

    end    
end

end
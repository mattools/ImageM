classdef ImageRegionalMinima < imagem.actions.ScalarImageAction
% Extract regional minima in a grayscale image.
%
%   output = ImageRegionalMinimaAction(input)
%
%   Example
%   ImageRegionalMinimaAction
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
    function obj = ImageRegionalMinima()
    end
end

methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        % apply regional minima to current image
        
        img = currentImage(frame);
        if ~isScalarImage(img)
            warning('ImageM:WrongImageType', ...
                'Regional minima can be applied only on scalar images');
            return;
        end
        
        app = frame.Gui.App;
        conn = getDefaultConnectivity(app, ndims(img));
        bin = regionalMinima(img, conn);
        
        [frame2, newDoc] = createImageFrame(frame, bin); %#ok<ASGLU>
        
        % add history
        string = sprintf('%s = regionalMinima(%s, %d);\n', ...
            newDoc.Tag, frame.Doc.Tag, conn);
        addToHistory(frame, string);
    end    
end


end
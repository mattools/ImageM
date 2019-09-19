classdef ImageMorphoGradient < imagem.actions.ScalarImageAction
% Apply morphological gradient (Beucher Gradient) on current image.
%
%   Class ImageMorphoGradientAction
%
%   Example
%   ImageMorphoGradientAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-15,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = ImageMorphoGradient()
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        disp('Compute Image morphological gradient');
        
        % get handle to current doc
        doc = currentDoc(frame);
        
        % apply 'gradient' operation
        se = ones(3, 3);
        img2 = morphoGradient(doc.Image, se);
        
        % add image to application, and create new display
        newDoc = addImageDocument(frame, img2);
        
        % add history
        string = sprintf('%s = morphoGradient(%s, ones(3,3));\n', ...
            newDoc.Tag, doc.Tag);
        addToHistory(frame, string);
    end
end % end methods

end % end classdef


classdef ImageMorphoGradientAction < imagem.gui.ImagemAction
%IMAGEMORPHOGRADIENTACTION  One-line description here, please.
%
%   Class ImageMorphoGradientAction
%
%   Example
%   ImageMorphoGradientAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-15,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function this = ImageMorphoGradientAction(parent)
        % calls the parent constructor
        this = this@imagem.gui.ImagemAction(parent, 'imageMorphoGradient');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('Compute Image erosion');
        
        % get handle to parent figure, and current doc
        viewer = this.parent;
        doc = viewer.doc;
        
        se = ones(3, 3);
        
        % apply 'gradient' operation
        img2 = morphoGradient(doc.image, se);
        
        % add image to application, and create new display
        addImageDocument(viewer.gui, img2);
    end
end % end methods

end % end classdef


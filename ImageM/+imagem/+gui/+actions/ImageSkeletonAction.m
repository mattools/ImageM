classdef ImageSkeletonAction < imagem.gui.actions.BinaryImageAction
% Computes skeleton of a binary image.
%
%   Class ImageSkeletonAction
%
%   Example
%   ImageSkeletonAction
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
    function obj = ImageSkeletonAction(viewer)
    % Constructor for ImageSkeletonAction class
        obj = obj@imagem.gui.actions.BinaryImageAction(viewer, 'imageSkeleton');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        
        % get handle to viewer figure, and current doc
        doc = currentDoc(obj);
        
        % compute Image skeleton
        img2 = skeleton(doc.Image);
        
        % add image to application, and create new display
        newDoc = addImageDocument(obj, img2);

        % history
        string = sprintf('%s = skeleton(%s);\n', newDoc.Tag, doc.Tag);
        addToHistory(obj, string);

    end
end % end methods

end % end classdef


classdef DuplicateImageAction < imagem.gui.actions.CurrentImageAction
% Duplicate the current image.
%
%   Class DuplicateImageAction
%
%   Example
%   DuplicateImageAction
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
    function obj = DuplicateImageAction(viewer)
    % Constructor for DuplicateImageAction class
    
        % calls the parent constructor
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, 'duplicateImage');
    end

end % end constructors


%% Methods
methods
     function actionPerformed(obj, src, event) %#ok<INUSD>
         
         image = clone(currentImage(obj));
         
         % add image to application, and create new display
         addImageDocument(obj, image);
         
     end
end % end methods

end % end classdef


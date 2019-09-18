classdef DuplicateImage < imagem.actions.CurrentImageAction
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
    function obj = DuplicateImage()
    end

end % end constructors


%% Methods
methods
     function run(obj, frame) %#ok<INUSL,INUSD>
         
         image = clone(currentImage(frame));
         
         % add image to application, and create new display
         addImageDocument(frame, image);
         
     end
end % end methods

end % end classdef


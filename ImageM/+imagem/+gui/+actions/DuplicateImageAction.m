classdef DuplicateImageAction < imagem.gui.actions.CurrentImageAction
%RENAMEIMAGEACTION  One-line description here, please.
%
%   Class DuplicateImageAction
%
%   Example
%   DuplicateImageAction
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
    function this = DuplicateImageAction(parent)
    % Constructor for DuplicateImageAction class
    
        % calls the parent constructor
        this = this@imagem.gui.actions.CurrentImageAction(parent, 'duplicateImage');
    end

end % end constructors


%% Methods
methods
     function actionPerformed(this, src, event) %#ok<INUSD>
         
         image = clone(this.parent.doc.image);
         
         % add image to application, and create new display
         addImageDocument(this.parent.gui, image);
         
     end
end % end methods

end % end classdef


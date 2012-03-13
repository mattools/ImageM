classdef CropImageSelectionAction < imagem.gui.actions.CurrentImageAction
%RENAMEIMAGEACTION  One-line description here, please.
%
%   Class CropImageSelectionAction
%
%   Example
%   CropImageSelectionAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-03-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function this = CropImageSelectionAction(parent)
    % Constructor for CropImageSelectionAction class
    
        % calls the parent constructor
        this = this@imagem.gui.actions.CurrentImageAction(parent, 'cropImageSelection');
    end

end % end constructors


%% Methods
methods
     function actionPerformed(this, src, event) %#ok<INUSD>
  
         selection = this.parent.selection;
         if isempty(selection)
             warndlg('Requires a non empty selection', ...
                 'Empty Selection', createmode);
             return;
         end
         
         type = selection.type;
         if ~ismember(lower(type), {'box'})
             warndlg('Current selection must be a box', ...
                 'Invalid Selection', createmode);
             return;
         end

         box = selection.data;
         box = round(box);
         cropped = crop(this.parent.doc.image, box);
         
         % add image to application, and create new display
         addImageDocument(this.parent.gui, cropped);
         
     end
end % end methods

end % end classdef


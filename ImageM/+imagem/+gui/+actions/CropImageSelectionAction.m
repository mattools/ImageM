classdef CropImageSelectionAction < imagem.gui.actions.CurrentImageAction
%RENAMEIMAGEACTION  Crop current rectangular selection 
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
    function this = CropImageSelectionAction(viewer)
    % Constructor for CropImageSelectionAction class
    
        % calls the parent constructor
        this = this@imagem.gui.actions.CurrentImageAction(viewer, 'cropImageSelection');
    end

end % end constructors


%% Methods
methods
     function actionPerformed(this, src, event) %#ok<INUSD>
         
         selection = this.viewer.selection;
         if isempty(selection)
             warndlg('Requires a non empty selection', ...
                 'Empty Selection', 'modal');
             return;
         end
         
         type = selection.type;
         if ~ismember(lower(type), {'box'})
             warndlg('Current selection must be a box', ...
                 'Invalid Selection', 'modal');
             return;
         end
         
         box = selection.data;
         box = round(box);
         cropped = crop(this.viewer.doc.image, box);
         
         % add image to application, and create new display
         newDoc = addImageDocument(this.viewer.gui, cropped);
         
         tag = this.viewer.doc.tag;
         newTag = newDoc.tag;
         
         % history
         nd = ndims(this.viewer.doc.image);
         pattern = ['%s = crop(%s, [' repmat(' %d %d', 1, nd) ']);\n'];
         string = sprintf(pattern, newTag, tag, box);
         addToHistory(this.viewer.gui, string);
         
     end
end % end methods

end % end classdef


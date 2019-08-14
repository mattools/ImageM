classdef CropImageSelectionAction < imagem.gui.actions.CurrentImageAction
% Crop current rectangular selection.
%
%   Class CropImageSelectionAction
%
%   Example
%   CropImageSelectionAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = CropImageSelectionAction(viewer)
    % Constructor for CropImageSelectionAction class
    
        % calls the parent constructor
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, 'cropImageSelection');
    end

end % end constructors


%% Methods
methods
     function actionPerformed(obj, src, event) %#ok<INUSD>
         
         selection = obj.Viewer.Selection;
         if isempty(selection)
             warndlg('Requires a non empty selection', ...
                 'Empty Selection', 'modal');
             return;
         end
         
         type = selection.Type;
         if ~ismember(lower(type), {'box'})
             warndlg('Current selection must be a box', ...
                 'Invalid Selection', 'modal');
             return;
         end
         
         box = selection.Data;
         box = round(box);
         cropped = crop(currentImage(obj), box);
         
         % add image to application, and create new display
         newDoc = addImageDocument(obj, cropped);
         
         tag = obj.Viewer.Doc.Tag;
         newTag = newDoc.Tag;
         
         % history
         nd = ndims(currentImage(obj));
         pattern = ['%s = crop(%s, [' repmat(' %d %d', 1, nd) ']);\n'];
         string = sprintf(pattern, newTag, tag, box);
         addToHistory(obj, string);
         
     end
end % end methods

end % end classdef


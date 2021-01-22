classdef CropImageSelection < imagem.actions.CurrentImageAction
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
    function obj = CropImageSelection()
    end

end % end constructors


%% Methods
methods
     function run(obj, frame) %#ok<INUSL>
         % Crop the portion of image delimited by selection.
         
         % check current selection validity
         box = frame.Selection;
         if isempty(box)
             warndlg('Requires a non empty selection', ...
                 'Empty Selection', 'modal');
             return;
         end
         
         if ~isa(box, 'Box2D')
             warndlg('Current selection must be a box', ...
                 'Invalid Selection', 'modal');
             return;
         end
         
         bounds = [box.XMin box.XMax box.YMin box.YMax];
         bounds = round(bounds);
         
         img = currentImage(frame);
         nd = ndims(img);
         if nd > 2
             bounds = [bounds 1 size(img, 3)];
         end
         cropped = crop(img, bounds);
         
         % add image to application, and create new display
         newDoc = addImageDocument(frame, cropped);
         
         tag = frame.Doc.Tag;
         newTag = newDoc.Tag;
         
         % history
         pattern = ['%s = crop(%s, [' strtrim(repmat(' %d %d', 1, nd)) ']);\n'];
         string = sprintf(pattern, newTag, tag, bounds);
         addToHistory(frame, string);
         
     end
end % end methods

end % end classdef


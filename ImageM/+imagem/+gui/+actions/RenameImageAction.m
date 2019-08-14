classdef RenameImageAction < imagem.gui.actions.CurrentImageAction
% Rename the current image.
%
%   Class RenameImageAction
%
%   Example
%   RenameImageAction
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
    function obj = RenameImageAction(viewer)
    % Constructor for RenameImageAction class
    
        % calls the parent constructor
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, 'renameImage');
    end

end % end constructors


%% Methods
methods
     function actionPerformed(obj, src, event) %#ok<INUSD>
         
         % extract app data
         image = currentImage(obj);
         app = obj.Viewer.Gui.App;
         
         % setup widget options
         prompt = {'New image name:'};
         name = 'Rename current image';
         numLines = 1;
         defaultAnswer = {image.Name};
         
         while true
             % ask for a new image name
             answer = inputdlg(prompt, name, numLines, defaultAnswer);
             if isempty(answer)
                 return;
             end
             newName = answer{1};
             
             % if new name is valid, update title and escape
             if ~hasDocumentWithName(app, newName) || strcmp(newName, image.Name)
                 image.Name = newName;
                 updateTitle(obj.Viewer);
                 return;
             end
             
             % if name already exists, re-display dialog until valid name
             h = errordlg('An image with obj name already exists', ...
                 'Image Name error', 'modal');
             uiwait(h);
             defaultAnswer = {newName};
         end
         
     end
end % end methods

end % end classdef


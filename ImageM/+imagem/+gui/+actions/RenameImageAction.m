classdef RenameImageAction < imagem.gui.ImagemAction
%RENAMEIMAGEACTION  One-line description here, please.
%
%   Class RenameImageAction
%
%   Example
%   RenameImageAction
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
    function this = RenameImageAction(parent)
    % Constructor for RenameImageAction class
    
        % calls the parent constructor
        this = this@imagem.gui.ImagemAction(parent, 'renameImage');
    end

end % end constructors


%% Methods
methods
     function actionPerformed(this, src, event) %#ok<INUSD>
         
         image = this.parent.doc.image;
         app = this.parent.gui.app;
         
         prompt = {'New image name:'};
         name = 'Rename current image';
         numLines = 1;
         defaultAnswer = {image.name};
         
         while true
             answer = inputdlg(prompt, name, numLines, defaultAnswer);
             if isempty(answer)
                 return;
             end
             
             newName = answer{1};
             if ~hasDocumentWithName(app, newName)
                 image.name = newName;
                 updateDisplay(this.parent);
                 updateTitle(this.parent);
                 return;
             end
             
             h = errordlg('An image with this name already exists', ...
                 'Image Name error', 'modal');
             uiwait(h);
             
             defaultAnswer = {newName};
         end
         
     end
end % end methods

end % end classdef


classdef ImportImageFromWorkspaceAction < imagem.gui.ImagemAction
%OPENIMAGEACTION Open an image from a file
%
%   Class ImportImageFromWorkspaceAction
%
%   Example
%   ImportImageFromWorkspaceAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-11-07,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function this = ImportImageFromWorkspaceAction(viewer)
    % Constructor for ImportImageFromWorkspaceAction class
        
        % calls the parent constructor
        this = this@imagem.gui.ImagemAction(viewer, 'importImageFromWorkspace');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('Import image from workspace');
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        gui = viewer.gui;
        
         % open dialog to input image name
        prompt = {'Enter Variable Name:'};
        title = 'Import From Workspace';
        lines = 1;
        def = {'ans'};
        answer = inputdlg(prompt, title, lines, def);
        
        % if user cancels, answer is empty
        if isempty(answer)
            return;
        end
        
        data = evalin('base', answer{1});
        
        if isa(data, 'Image')
            img = data;
        else
            img = Image('data');
        end
        
        % add image to application, and create new display
        addImageDocument(gui, img);
    end
end % end methods

end % end classdef


classdef ImportImageFromWorkspace < imagem.gui.Action
% Import an image from workspace.
%
%   Class ImportImageFromWorkspaceAction
%
%   Example
%   ImportImageFromWorkspace
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-11-07,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function this = ImportImageFromWorkspace()
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        disp('Import image from workspace');
                
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
            img = Image(data);
        end
        
        % add image to application, and create new display
        addImageDocument(frame, img);
    end
end % end methods

end % end classdef


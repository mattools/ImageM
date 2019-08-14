classdef ExportImageToWorkspaceAction < imagem.gui.actions.CurrentImageAction
% Export image to workspace.
%
%   Class ExportImageToWorkspaceAction
%
%   Example
%   ExportImageToWorkspaceAction
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
    function obj = ExportImageToWorkspaceAction(viewer)
    % Constructor for ExportImageToWorkspaceAction class
        
        % calls the viewer constructor
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, 'exportImageToWorkspace');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        disp('Export current image to workspace');
        
        % open dialog to input image name
        prompt = {'Enter image name:'};
        title = 'Export Image Data';
        lines = 1;
        def = {'img'};
        answer = inputdlg(prompt, title, lines, def);
        
        % if user cancels, answer is empty
        if isempty(answer)
            return;
        end
        
        assignin('base', answer{1}, currentImage(obj));
        
    end
end % end methods

end % end classdef


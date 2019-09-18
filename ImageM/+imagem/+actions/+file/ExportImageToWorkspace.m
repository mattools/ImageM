classdef ExportImageToWorkspace < imagem.actions.CurrentImageAction
% Export current image to workspace.
%
%   Class ExportImageToWorkspace
%
%   Example
%   ExportImageToWorkspace
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
    function obj = ExportImageToWorkspace()
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL,INUSD>
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
        
        assignin('base', answer{1}, currentImage(frame));
    end
end % end methods

end % end classdef


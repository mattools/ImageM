classdef SelectToolAction < imagem.gui.ImagemAction
% Changes the selected tool.
%
%   output = SelectToolAction(input)
%
%   Example
%   SelectToolAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-11-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    % the tool to select
    Tool;
end

methods
    function obj = SelectToolAction(viewer, tool)
        % calls the parent constructor
        name = ['selectTool-' tool.Name];
        obj = obj@imagem.gui.ImagemAction(viewer, name);
        obj.Tool = tool;
    end
end

methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        disp(['select another tool: ' obj.Tool.Name]);
        
        viewer = obj.Viewer;
        obj.Tool.Viewer = viewer;
        
        viewer.CurrentTool = obj.Tool;
    end
end

methods
    function b = isActivable(obj)
        b = isActivable(obj.Tool);
    end
end

end

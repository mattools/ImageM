classdef SelectTool < imagem.gui.Action
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
    function obj = SelectTool(tool)
        obj.Tool = tool;
    end
end

methods
    function run(obj, frame)
        disp(['select another tool: ' obj.Tool.Name]);
        
        obj.Tool.Viewer = frame;
        
        frame.CurrentTool = obj.Tool;
    end
end

methods
    function b = isActivable(obj, frame)
        b = isActivable(obj.Tool);
    end
end

end

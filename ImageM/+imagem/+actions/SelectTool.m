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
    % A function handle to the tool constructor.
    BuildFunction;
    
    % An optional function used to decide whether the action can be used.
    IsActivableFunction;
end

methods
    function obj = SelectTool(buildFn, varargin)
        obj.BuildFunction = buildFn;
        
        obj.IsActivableFunction = @(x) true;
        if ~isempty(varargin)
            var1 = varargin{1};
            if isa(var1, 'function_handle')
                obj.IsActivableFunction = var1;
            end
        end
    end
end

methods
    function run(obj, frame)
        tool = obj.BuildFunction(frame);
        frame.CurrentTool = tool;
    end
end

methods
    function b = isActivable(obj, frame)
        b = obj.IsActivableFunction(frame);
    end
end

end

classdef GenericAction < imagem.gui.Action
% A generic class for managing actions with simple commands.
%
%   action = GenericAction(VIEWER, COMMAND_NAME, FHANDLE)
%
%   Example
%   GenericAction
%
%   See also
%
 

properties
    FunctionHandle;
end

methods
    function obj = GenericAction(fhandle)
        % calls the parent constructor
        obj.FunctionHandle = fhandle;
    end
end

methods
    function run(obj, frame)
        % simply calls the stored handle
        obj.FunctionHandle(frame);
    end
end

end
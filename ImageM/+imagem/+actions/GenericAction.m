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
    function this = GenericAction(fhandle)
        % calls the parent constructor
        this.FunctionHandle = fhandle;
    end
end

methods
    function run(obj, frame)
        % simply calls the stored handle
        obj.FunctionHandle(frame);
    end
end

end
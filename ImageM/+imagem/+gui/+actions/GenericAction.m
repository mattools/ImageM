classdef GenericAction < imagem.gui.ImagemAction
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
    function this = GenericAction(viewer, name, handle)
        % calls the parent constructor
        this = this@imagem.gui.ImagemAction(viewer, name);
        this.FunctionHandle = handle;
    end
end

methods
    function actionPerformed(this, src, event)
        % simply calls the stored handle
        this.FunctionHandle(src, event);
    end
end

end
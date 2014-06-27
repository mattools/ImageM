classdef GenericAction < imagem.gui.ImagemAction
%GENERICACTION A generic class for managing actions with simple commands
%
%   action = GenericAction(VIEWER, COMMAND_NAME, FHANDLE)
%
%   Example
%   GenericAction
%
%   See also
%
 

properties
    functionHandle;
end

methods
    function this = GenericAction(viewer, name, handle)
        % calls the parent constructor
        this = this@imagem.gui.ImagemAction(viewer, name);
        this.functionHandle = handle;
    end
end

methods
    function actionPerformed(this, src, event)
        % simply calls the stored handle
        this.functionHandle(src, event);
    end
end

end
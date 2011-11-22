classdef ApplyImageFunctionAction < imagem.gui.ImagemAction
%APPLYIMAGEFUNCTIONACTION  Apply a function to Image object, and display result 
%
%   output = ApplyImageFunctionAction(input)
%
%   Example
%   ApplyImageFunctionAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-11-22,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    methodName;
end

methods
    function this = ApplyImageFunctionAction(parent, name, methodName)
        % calls the parent constructor
        this = this@imagem.gui.ImagemAction(parent, name);
        this.methodName = methodName;
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        if isempty(this.methodName)
            return;
        end
        
        % get handle to parent figure, and current doc
        viewer = this.parent;
        doc = viewer.doc;
        
        % apply the given operation
        res = feval(this.methodName, doc.image);
        
        % depending on result type, should do different processes
        if isa(res, 'Image')
            addImageDocument(viewer.gui, res);
        else
            error('Image expected');
        end
        
    end
end

end
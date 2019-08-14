classdef ApplyImageFunctionAction < imagem.gui.actions.CurrentImageAction
% Apply a function to Image object, and display result.
%
%   output = ApplyImageFunctionAction(input)
%
%   Example
%   ApplyImageFunctionAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-11-22,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    MethodName;
end

methods
    function obj = ApplyImageFunctionAction(viewer, methodName)
        % calls the parent constructor
        name = ['applyImageMethod-' methodName];
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, name);
        obj.MethodName = methodName;
    end
end

methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        if isempty(obj.MethodName)
            return;
        end
        
        % get handle to current doc
        doc = obj.Viewer.Doc;
        
        % apply the given operation
        res = feval(obj.MethodName, doc.Image ~= 0);
        
        % depending on result type, should do different processes
        if isa(res, 'Image')
            newDoc = addImageDocument(obj, res);
        else
            error('Image expected');
        end
        
        % add history
        string = sprintf('%s = %s(%s);\n', ...
            newDoc.Tag, obj.MethodName, doc.Tag);
        addToHistory(obj, string);

    end
end

end
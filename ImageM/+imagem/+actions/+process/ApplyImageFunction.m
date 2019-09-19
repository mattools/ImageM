classdef ApplyImageFunction < imagem.actions.CurrentImageAction
% Apply a method to Image object, and display result.
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
    function obj = ApplyImageFunction(methodName)
        % calls the parent constructor
        obj.MethodName = methodName;
    end
end

methods
    function run(obj, frame) %#ok<INUSD>
        if isempty(obj.MethodName)
            return;
        end
        
        % get handle to current doc
        doc = currentDoc(frame);
        
        % apply the given operation
        res = feval(obj.MethodName, doc.Image ~= 0);
        
        % depending on result type, should do different processes
        if isa(res, 'Image')
            newDoc = addImageDocument(frame, res);
        else
            error('Image expected');
        end
        
        % add history
        string = sprintf('%s = %s(%s);\n', ...
            newDoc.Tag, obj.MethodName, doc.Tag);
        addToHistory(frame, string);

    end
end

end
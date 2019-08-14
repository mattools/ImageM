classdef ImageConvertTypeAction < imagem.gui.actions.CurrentImageAction
% Convert the type of the current image.
%
%   Class ImageConvertTypeAction
%
%   Example
%   ImageConvertTypeAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2016-01-06,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2016 INRA - BIA-BIBS.


%% Properties
properties
    TypeName;
end % end properties


%% Constructor
methods
    function obj = ImageConvertTypeAction(viewer, typeName)
        % Constructor for ImageConvertTypeAction class
        
        % calls the parent constructor
        name = ['convertType-' typeName];
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, name);
        
        % init inner fields
        obj.TypeName = typeName;
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        if isempty(obj.TypeName)
            return;
        end
        
        % get handle to current doc
        doc = currentDoc(obj);
        
        % apply the conversion operation
        res = Image(doc.Image, 'type', obj.TypeName);
        
        % create a new doc
        newDoc = addImageDocument(obj, res);
        
        % add history
        string = sprintf('%s = Image(%s, ''type'', ''%s'');\n', ...
            newDoc.Tag, doc.Tag, obj.TypeName);
        addToHistory(obj, string);
    end
end % end methods

end % end classdef


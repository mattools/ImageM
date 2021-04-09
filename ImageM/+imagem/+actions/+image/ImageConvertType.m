classdef ImageConvertType < imagem.actions.ScalarImageAction
% Convert the type (grayscale, label...) of the current (scalar) image.
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
% e-mail: david.legland@inrae.fr
% Created: 2016-01-06,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2016 INRA - BIA-BIBS.


%% Properties
properties
    TypeName;
end % end properties


%% Constructor
methods
    function obj = ImageConvertType(typeName)
        % Constructor for ImageConvertType class
        
        % init inner fields
        obj.TypeName = typeName;
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSD>
        if isempty(obj.TypeName)
            return;
        end
        
        % get handle to current doc
        doc = currentDoc(frame);
        
        % apply the conversion operation
        res = Image(doc.Image, 'Type', obj.TypeName);
        
        % create a new doc
        newDoc = addImageDocument(frame, res);
        
        % add history
        string = sprintf('%s = Image(%s, ''Type'', ''%s'');\n', ...
            newDoc.Tag, doc.Tag, obj.TypeName);
        addToHistory(frame, string);
    end
end % end methods

end % end classdef


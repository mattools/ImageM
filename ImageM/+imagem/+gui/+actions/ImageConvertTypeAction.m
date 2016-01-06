classdef ImageConvertTypeAction < imagem.gui.actions.CurrentImageAction
%IMAGECONVERTTYPEACTION Convert the type of the current image
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
% e-mail: david.legland@nantes.inra.fr
% Created: 2016-01-06,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2016 INRA - BIA-BIBS.


%% Properties
properties
    typeName;
end % end properties


%% Constructor
methods
    function this = ImageConvertTypeAction(viewer, typeName)
        % Constructor for ImageConvertTypeAction class
        
        % calls the parent constructor
        name = ['convertType-' typeName];
        this = this@imagem.gui.actions.CurrentImageAction(viewer, name);
        
        % init inner fields
        this.typeName = typeName;
    end

end % end constructors


%% Methods
methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        if isempty(this.typeName)
            return;
        end
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;
        
        % apply the conversion operation
        res = Image(doc.image, 'type', this.typeName);
        
        % create a new doc
        newDoc = addImageDocument(viewer.gui, res);
        
        % add history
        string = sprintf('%s = Image(%s, ''type'', ''%s'');\n', ...
            newDoc.tag, doc.tag, this.typeName);
        addToHistory(this.viewer.gui.app, string);
    end
end % end methods

end % end classdef


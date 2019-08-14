classdef RotateImage90Action < imagem.gui.actions.CurrentImageAction
% Rotate current image by 90 degrees.
%
%   Class RotateImage90Action
%
%   Example
%   RotateImage90Action
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-05-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
    Number = 1;
end % end properties


%% Constructor
methods
    function obj = RotateImage90Action(viewer, number, varargin)
        % calls the parent constructor
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, 'rotateImage');
        if nargin > 1
            obj.Number = number;
        end
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        
        % get handle to viewer figure, and current doc
        doc = currentDoc(obj);
        
        % flip image
        res = rotate90(doc.Image, obj.Number);
        
        % add image to application, and create new display
        newDoc = addImageDocument(obj, res);
        
        % history
        string = sprintf('%s = rotate90(%s, %d);\n', ...
            newDoc.Tag, doc.Tag, obj.Number);
        addToHistory(obj, string);
    end
end

end % end classdef


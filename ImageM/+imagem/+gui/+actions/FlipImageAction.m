classdef FlipImageAction < imagem.gui.actions.CurrentImageAction
% Flip current image.
%
%   Class FlipImageAction
%
%   Example
%   FlipImageAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-05-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
    Axis = 3;
end % end properties


%% Constructor
methods
    function obj = FlipImageAction(viewer, axis, varargin)
        % calls the parent constructor
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, 'flipImage');
        if nargin > 1
            obj.Axis = axis;
        end
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
         
        % flip image
        doc = currentDoc(obj);
        res = flip(doc.Image, obj.Axis);
        
        % add image to application, and create new display
        newDoc = addImageDocument(obj, res);
        
        % add history
        string = sprintf('%s = flip(%s, %d);\n', ...
             newDoc.Tag, doc.Tag, obj.Axis);
        addToHistory(obj, string);
    end
end

end % end classdef


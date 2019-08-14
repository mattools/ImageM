classdef ImageDilationAction < imagem.gui.actions.CurrentImageAction
% Morpohlogical dilation of current image.
%
%   output = ImageDilationAction(input)
%
%   Example
%   ImageDilationAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-09,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function obj = ImageDilationAction(viewer, varargin)
        % calls the parent constructor
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, 'imageDilation');
    end
end

methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        % apply 'gradient' operation
        
        % get handle to viewer figure, and current doc
        viewer = obj.Viewer;
        doc = viewer.Doc;
        
        % compute dilation
        se = ones(3, 3);
        img2 = dilation(doc.Image, se);
        
        % add image to application, and create new display
        newDoc = addImageDocument(viewer.Gui, img2);
        
        % add history
        string = sprintf('%s = dilation(%s, ones(3,3));\n', ...
            newDoc.Tag, doc.Tag);
        addToHistory(obj.Viewer.Gui.App, string);
    end
end

end
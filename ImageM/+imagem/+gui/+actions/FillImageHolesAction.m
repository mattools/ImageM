classdef FillImageHolesAction < imagem.gui.actions.ScalarImageAction
% Fill holes within a binary or scalar image.
%
%   Class FillImageHolesAction
%
%   Example
%   FillImageHolesAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-05-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = FillImageHolesAction(viewer)
    % Constructor for FillImageHolesAction class
        obj = obj@imagem.gui.actions.ScalarImageAction(viewer, 'imageFillHoles');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
       
        % get handle to viewer figure, and current doc
        viewer = obj.Viewer;
        doc = viewer.Doc;
        
        % compute Image skeleton
        img2 = fillHoles(doc.Image);
        
        % add image to application, and create new display
        newDoc = addImageDocument(obj, img2);
        
        % add history
        string = sprintf('%s = fillHoles(%s, %d);\n', ...
             newDoc.Tag, doc.Tag, ...
             getDefaultConnectivity(viewer.Gui.App, ndims(img2)));
        addToHistory(obj, string);
    end
end % end methods

end % end classdef


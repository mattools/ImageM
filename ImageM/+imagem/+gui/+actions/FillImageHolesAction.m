classdef FillImageHolesAction < imagem.gui.actions.BinaryImageAction
%FILLIMAGEHOLESACTION  Fill holes of a binary image
%
%   Class FillImageHolesAction
%
%   Example
%   FillImageHolesAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-05-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function this = FillImageHolesAction(viewer)
    % Constructor for FillImageHolesAction class
        this = this@imagem.gui.actions.BinaryImageAction(viewer, 'imageFillHoles');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(this, src, event) %#ok<INUSD>
       
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;
        
        % compute Image skeleton
        img2 = fillHoles(doc.image);
        
        % add image to application, and create new display
        newDoc = addImageDocument(viewer.gui, img2);
        
        % add history
        string = sprintf('%s = fillHoles(%s, %d);\n', ...
             newDoc.tag, this.viewer.doc.tag, ...
             getDefaultConnectivity(viewer.gui.app, ndims(img2)));
        addToHistory(viewer.gui, string);
    end
end % end methods

end % end classdef


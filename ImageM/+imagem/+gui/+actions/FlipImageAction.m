classdef FlipImageAction < imagem.gui.actions.CurrentImageAction
%IMAGEFLIPACTION  Flip current image
%
%   Class FlipImageAction
%
%   Example
%   FlipImageAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-05-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
    axis = 3;
end % end properties


%% Constructor
methods
    function this = FlipImageAction(viewer, axis, varargin)
        % calls the parent constructor
        this = this@imagem.gui.actions.CurrentImageAction(viewer, 'flipImage');
        if nargin > 1
            this.axis = axis;
        end
    end

end % end constructors


%% Methods
methods
    function actionPerformed(this, src, event) %#ok<INUSD>
         
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;
        
        % flip image
        res = flip(doc.image, this.axis);
        
        % add image to application, and create new display
        newDoc = addImageDocument(viewer.gui, res);
        
        % add history
        string = sprintf('%s = flip(%s, %d);\n', ...
             newDoc.tag, this.viewer.doc.tag, this.axis);
        addToHistory(viewer.gui.app, string);
    end
end

end % end classdef


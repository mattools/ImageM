classdef RotateImage90Action < imagem.gui.actions.CurrentImageAction
%ROTATEIMAGE90ACTION Rotate current image by 90 degrees
%
%   Class RotateImage90Action
%
%   Example
%   RotateImage90Action
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
    number = 1;
end % end properties


%% Constructor
methods
    function this = RotateImage90Action(viewer, number, varargin)
        % calls the parent constructor
        this = this@imagem.gui.actions.CurrentImageAction(viewer, 'rotateImage');
        if nargin > 1
            this.number = number;
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
        res = rotate90(doc.image, this.number);
        
        % add image to application, and create new display
        newDoc = addImageDocument(viewer.gui, res);
        
        % history
        string = sprintf('%s = rotate90(%s, %d);\n', ...
            newDoc.tag, doc.tag, this.number);
        addToHistory(this.viewer.gui, string);
    end
end

end % end classdef


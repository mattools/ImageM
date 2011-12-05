classdef SplitImageRGBAction < imagem.gui.ImagemAction
%SPLITIMAGERGBACTION  One-line description here, please.
%
%   Class SplitImageRGBAction
%
%   Example
%   SplitImageRGBAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Constructor
methods
    function this = SplitImageRGBAction(parent, varargin)
        this = this@imagem.gui.ImagemAction(parent, 'splitImageRGB');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('Split RGB channels');
        
        % get handle to parent figure, and current doc
        viewer = this.parent;
        doc = viewer.doc;
        
        if ~isColorImage(doc.image)
            errordlg('Requires a Color image', 'Image Format Error');
            return;
        end
        
        % extract the ifferent channels
        [red green blue] = splitChannels(doc.image);
        
        % add new images to application, and create new displays
        addImageDocument(viewer.gui, red);
        addImageDocument(viewer.gui, green);
        addImageDocument(viewer.gui, blue);
        
    end
end % end methods

end % end classdef


classdef SplitImageRGBAction < imagem.gui.actions.CurrentImageAction
%SPLITIMAGERGBACTION  One-line description here, please.
%
%   Class SplitImageRGBAction
%
%   Example
%   SplitImageRGBAction
%
%   See also
%     SplitImageChannelsAction
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Constructor
methods
    function obj = SplitImageRGBAction(viewer, varargin)
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, 'splitImageRGB');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        
        % get handle to viewer figure, and current doc
        viewer = obj.Viewer;
        doc = viewer.Doc;
        
        if ~isColorImage(doc.Image)
            errordlg('Requires a Color image', 'Image Format Error');
            return;
        end
        
        % extract the different channels in three image instances
        [red, green, blue] = splitChannels(doc.Image);
        
        % add new images to application, and create new displays
        docR = addImageDocument(viewer.Gui, red, [], 'red');
        docG = addImageDocument(viewer.Gui, green, [], 'green');
        docB = addImageDocument(viewer.Gui, blue, [], 'blue');
        
        % add history
        string = sprintf('[%s %s %s] = splitChannels(%s);\n', ...
            docR.Tag, docG.Tag, docB.Tag, doc.Tag);
        addToHistory(viewer.Gui.App, string);
        
    end
end % end methods

methods
    function b = isActivable(obj)
        doc = obj.Viewer.Doc;
        b = ~isempty(doc) && ~isempty(doc.Image) && isColorImage(doc.Image);
    end
end

end % end classdef

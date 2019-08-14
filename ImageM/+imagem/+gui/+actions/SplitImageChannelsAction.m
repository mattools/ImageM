classdef SplitImageChannelsAction < imagem.gui.actions.VectorImageAction
% Split image channels.
%
%   Class SplitImageChannelsAction
%
%   Example
%   SplitImageChannelsAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Constructor
methods
    function obj = SplitImageChannelsAction(viewer, varargin)
        obj = obj@imagem.gui.actions.VectorImageAction(viewer, 'splitImageChannels');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        disp('Split Image channels');
        
        % get handle to viewer figure, and current doc
        viewer = obj.Viewer;
        doc = viewer.Doc;
        
        if ~isVectorImage(doc.Image)
            errordlg('Requires a Vector image', 'Image Format Error');
            return;
        end
        
        % extract the ifferent channels
        channels = splitChannels(doc.Image);
        
        % add new images to application, and create new displays
        for i = 1:length(channels)
            addImageDocument(viewer.Gui, channels{i});
        end
        
    end
end % end methods

end % end classdef


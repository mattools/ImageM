classdef SplitImageChannelsAction < imagem.gui.actions.VectorImageAction
%SPLITIMAGERGBACTION  One-line description here, please.
%
%   Class SplitImageChannelsAction
%
%   Example
%   SplitImageChannelsAction
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
    function this = SplitImageChannelsAction(viewer, varargin)
        this = this@imagem.gui.actions.VectorImageAction(viewer, 'splitImageChannels');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('Split RGB channels');
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;
        
        if ~isVectorImage(doc.image)
            errordlg('Requires a Vector image', 'Image Format Error');
            return;
        end
        
        % extract the ifferent channels
        channels = splitChannels(doc.image);
        
        % add new images to application, and create new displays
        for i = 1:length(channels)
            addImageDocument(viewer.gui, channels{i});
        end
        
    end
end % end methods

methods
    function b = isActivable(this)
        doc = this.viewer.doc;
        b = ~isempty(doc) && ~isempty(doc.image) && isVectorImage(doc.image);
    end
end


end % end classdef


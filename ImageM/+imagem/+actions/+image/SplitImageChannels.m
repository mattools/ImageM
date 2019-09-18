classdef SplitImageChannels < imagem.actions.VectorImageAction
% Split the channels from a multi-channel image.
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
    function obj = SplitImageChannels()
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        disp('Split Image channels');
        
        % get handle to current doc
        doc = frame.Doc;
        
        if ~isVectorImage(doc.Image)
            errordlg('Requires a Vector image', 'Image Format Error');
            return;
        end
        
        % extract the different channels
        channels = splitChannels(doc.Image);
        
        % add new images to application, and create new displays
        for i = 1:length(channels)
            addImageDocument(frame, channels{i});
        end
        
    end
end % end methods

end % end classdef


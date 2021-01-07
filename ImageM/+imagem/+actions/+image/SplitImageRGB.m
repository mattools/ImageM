classdef SplitImageRGB < imagem.actions.CurrentImageAction
% Split the three channels from a color image.
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
    function obj = SplitImageRGB()
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        
        % get handle to current doc
        doc = frame.Doc;
        
        if ~isColorImage(doc.Image)
            errordlg('Requires a Color image', 'Image Format Error');
            return;
        end
        
        % extract the different channels in three image instances
        [red, green, blue] = splitChannels(doc.Image);
        
        % add new images to application, and create new displays
        docR = addImageDocument(frame, red);
        docG = addImageDocument(frame, green);
        docB = addImageDocument(frame, blue);
        
        % add history
        string = sprintf('[%s, %s, %s] = splitChannels(%s);\n', ...
            docR.Tag, docG.Tag, docB.Tag, doc.Tag);
        addToHistory(frame, string);
    end
    
end % end methods

methods
    function b = isActivable(obj, frame) %#ok<INUSL>
        doc = frame.Doc;
        b = ~isempty(doc) && ~isempty(doc.Image) && isColorImage(doc.Image);
    end
end

end % end classdef

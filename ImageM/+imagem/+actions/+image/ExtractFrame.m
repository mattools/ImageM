classdef ExtractFrame < imagem.actions.TimeLapseImageAction
% Extract a frame from a lime-lapse image.
%
%   Class ExtractFrame
%
%   Example
%   ExtractFrame
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-11-15,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = ExtractFrame(varargin)
        % Constructor for ExtractFrame class
    end

end % end constructors


%% Methods
methods
    function run(obj, viewer) %#ok<INUSL,INUSD>
        
        % get handle to current doc
        doc = currentDoc(viewer);
        img = doc.Image;

        % determine current slice, and slice number
        currentFrame = viewer.FrameIndex; % assume class 'Image5DViewer'
        nFrames = frameNumber(img);
        
        % open a dialog to choose slice index
        gd = imagem.gui.GenericDialog('Extract Frame');
        frameLabel = sprintf('Frame Index (max %d)', nFrames);
        addNumericField(gd, frameLabel, currentFrame, 0);
        setSize(gd, [300 100]);
        
        showDialog(gd);
        if wasCanceled(gd)
            return;
        end
        
        frameIndex = getNextNumber(gd);
        if frameIndex < 1 || frameIndex > nFrames
            error('frameIndex must be comprised between 1 and %d', nFrames);
        end
        
        % apply the conversion operation
        res = frame(img, frameIndex);
        if ~isempty(img.Name)
            nDigits = ceil(log10(nFrames));
            pattern = ['%s_t%0' num2str(nDigits) 'd'];
            res.Name = sprintf(pattern, img.Name, frameIndex);
        end
        
        % create a new doc
        newDoc = addImageDocument(viewer, res);
        
        % add history
        string = sprintf('%s = frame(%s, %d));\n', ...
            newDoc.Tag, doc.Tag, frameIndex);
        addToHistory(viewer, string);
    end
    
end % end methods

end % end classdef


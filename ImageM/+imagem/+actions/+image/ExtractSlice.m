classdef ExtractSlice < imagem.actions.Image3DAction
% Extract an XY slice from a 3D image.
%
%   Class ExtractSlice
%
%   Example
%   ExtractSlice
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
    function obj = ExtractSlice(varargin)
    % Constructor for ExtractSlice class

    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        
        % get handle to current doc
        doc = currentDoc(frame);
        img = doc.Image;

        % determine current slice, and slice number
        currentSlice = frame.SliceIndex; % assume class 'Image3DSliceViewer'
        sliceNumber = size(img, 3);
        
        % open a dialog to choose slice index
        gd = imagem.gui.GenericDialog('Extract Slice');
        sliceLabel = sprintf('Slice Index (max %d)', sliceNumber);
        addNumericField(gd, sliceLabel, currentSlice, 0);
        setSize(gd, [300 100]);
        
        showDialog(gd);
        if wasCanceled(gd)
            return;
        end
        
        sliceIndex = getNextNumber(gd);
        if sliceIndex < 1 || sliceIndex > sliceNumber
            error('sliceIndex must be comprised between 1 and %d', sliceNumber);
        end
        
        % apply the conversion operation
        res = slice(img, sliceIndex);
        if ~isempty(img.Name)
            nDigits = ceil(log10(sliceNumber));
            pattern = ['%s_z%0' num2str(nDigits) 'd'];
            res.Name = sprintf(pattern, img.Name, sliceIndex);
        end
        
        % create a new doc
        newDoc = addImageDocument(frame, res);
        
        % add history
        string = sprintf('%s = slice(%s, %d);\n', ...
            newDoc.Tag, doc.Tag, sliceIndex);
        addToHistory(frame, string);
    end
    
end % end methods

end % end classdef


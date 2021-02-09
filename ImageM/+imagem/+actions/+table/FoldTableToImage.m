classdef FoldTableToImage < imagem.actions.CurrentTableAction
%FOLDTABLETOIMAGE  One-line description here, please.
%
%   Class FoldTableToImage
%
%   Example
%   FoldTableToImage
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-11-19,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = FoldTableToImage(varargin)
    % Constructor for FoldTableToImage class

    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        
        % get handle to current doc
        doc = frame.Doc;
        tab = doc.Table;
        
        % table size
        nRows = size(tab, 1);
        nCols = size(tab, 2);
        
        % default options
        sizeX = nRows;
        sizeY = 1;
        if ~isempty(doc.ImageSize)
            sizeX = doc.ImageSize(1);
            sizeY = doc.ImageSize(2);
        end
        
        % open a dialog to choose slice index
        gd = imagem.gui.GenericDialog('Fold Table to image');
        addNumericField(gd, 'Size X: ', sizeX, 0);
        addNumericField(gd, 'Size Y: ', sizeY, 0);
        setSize(gd, [200 150]);
        
        while true
            showDialog(gd);
            if wasCanceled(gd)
                return;
            end
        
            sizeX = getNextNumber(gd);
            sizeY = getNextNumber(gd);
            
            if sizeX * sizeY == nRows
                break;
            end
            msg = sprintf('Product of dimensions must match number of rows (%d)', nRows);
            hf = errordlg(msg, 'ImageM Error');
            uiwait(hf);

            resetCounter(gd);
        end
        
        data = zeros(sizeX, sizeY, 1, nCols, 'like', tab.Data);
        data(:) = tab.Data(:);
        
        if nCols == 1
            img = Image('Data', data, 'type', 'intensity', 'channelNames', tab.ColNames(1));
        else
            img = Image('Data', data, 'type', 'vector', 'channelNames', tab.ColNames);
        end
        
        createImageFrame(frame.Gui, img);
    end
    
end % end methods

end % end classdef


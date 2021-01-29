classdef ConvertVectorImageToRGB < imagem.actions.CurrentImageAction
% Convert vector image to RGB image by selecting the three channels.
%
%   Class ConvertVectorImageToRGB
%
%   Example
%   ConvertVectorImageToRGB
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-11-25,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = ConvertVectorImageToRGB(varargin)
    % Constructor for ConvertVectorImageToRGB class

    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        
        % get handle to current doc
        doc = currentDoc(frame);
        
        img = doc.Image;
        if ~isVectorImage(img)
            errordlg('Requires a vector image');
            return;
        end
        nc = channelCount(img);
        if nc < 3
            errordlg('Requires at least three channels in image');
            return;
        end
        channelNames = cellstr(num2str((1:nc)', 'Channel %d'));
        
        % open a dialog to choose channel indices
        gd = imagem.gui.GenericDialog('Vector To RGB');
        addChoice(gd, 'Red: ', channelNames, channelNames{1});
        addChoice(gd, 'Green: ', channelNames, channelNames{2});
        addChoice(gd, 'Blue: ', channelNames, channelNames{3});
%         addCheckBox(gd, 'Adjust intensities', true);
        setSize(gd, [200 150]);
        
        showDialog(gd);
        if wasCanceled(gd)
            return;
        end
        
        indR = getNextChoiceIndex(gd);
        indG = getNextChoiceIndex(gd);
        indB = getNextChoiceIndex(gd);

        chR = adjustDynamic(channel(img, indR));
        chG = adjustDynamic(channel(img, indG));
        chB = adjustDynamic(channel(img, indB));
        rgbData = uint8(cat(4, chR.Data, chG.Data, chB.Data));
        
        % apply the conversion operation
        res = Image('Data', rgbData, 'parent', img, 'type', 'color');
        
        
        % create a new doc
        newDoc = addImageDocument(frame, res);
        
%         % add history
%         string = sprintf('%s = Image(permute(%s.Data, [1 2 4 3 5]);\n', ...
%             newDoc.Tag, doc.Tag);
%         addToHistory(frame, string);
    end

    
    function b = isActivable(obj, frame)
        b = isActivable@imagem.actions.CurrentImageAction(obj, frame);
        if b
            b = isVectorImage(currentImage(frame));
        end
    end
    
end % end methods

end % end classdef


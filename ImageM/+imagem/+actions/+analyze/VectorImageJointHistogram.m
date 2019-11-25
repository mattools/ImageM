classdef VectorImageJointHistogram < imagem.actions.VectorImageAction
% One-line description here, please.
%
%   Class VectorImageJointHistogram
%
%   Example
%   VectorImageJointHistogram
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
    function obj = VectorImageJointHistogram(varargin)
    % Constructor for VectorImageJointHistogram class

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
        nc = channelNumber(img);
        if nc < 2
            errordlg('Requires at least two channels in image');
            return;
        end
        channelNames = cellstr(num2str((1:nc)', 'Channel %d'));
        
        % open a dialog to choose channel indices
        gd = imagem.gui.GenericDialog('Vector To RGB');
        addChoice(gd, 'Channel 1: ', channelNames, channelNames{1});
        addChoice(gd, 'Channel 2: ', channelNames, channelNames{2});
        addNumericField(gd, 'Quantization: ', 256, 0);
        addCheckBox(gd, 'Log-scale', true);
        setSize(gd, [200 200]);
        
        showDialog(gd);
        if wasCanceled(gd)
            return;
        end
        
        ind1 = getNextChoiceIndex(gd);
        ind2 = getNextChoiceIndex(gd);
        nBins = getNextNumber(gd);
        logScale = getNextBoolean(gd);
        
        % get channels of interest
        ch1 = channel(img, ind1);
        ch2 = channel(img, ind2);
        
        % ensure channels are uint8
        if ~isa(ch1.Data, 'uint8')
            ch1 = adjustDynamic(ch1);
        end
        if ~isa(ch2.Data, 'uint8')
            ch2 = adjustDynamic(ch2);
        end
        
        % compute joint histogram
        jHist = jointHistogram(ch1, ch2, nBins);
        if logScale
            jHist = log(jHist);
        end
        
        
        % create a new doc
        [newDoc, newFrame] = addImageDocument(frame, jHist);
        
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


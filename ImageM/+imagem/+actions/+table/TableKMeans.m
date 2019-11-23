classdef TableKMeans < imagem.actions.CurrentTableAction
%EXTRACTSLICE  One-line description here, please.
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
    function obj = TableKMeans(varargin)
    % Constructor for ExtractSlice class

    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        
        % get handle to current doc
        doc = frame.Doc;
        tab = doc.Table;
        
        % default options
        nClasses = 3;
        maxClassNumber = size(tab, 1);
        
        % open a dialog to choose slice index
        gd = imagem.gui.GenericDialog('K-Means');
        numberLabel = 'Class number: ';
        addNumericField(gd, numberLabel, nClasses, 0);
        addCheckBox(gd, 'Display Centroids', true);
        addCheckBox(gd, 'Plot Result', true);
        setSize(gd, [200 150]);
        
        showDialog(gd);
        if wasCanceled(gd)
            return;
        end
        
        nClasses = getNextNumber(gd);
        if nClasses < 1 || nClasses > maxClassNumber
            error('sliceIndex must be comprised between 1 and %d', maxClassNumber);
        end
        displayCentroids = getNextBoolean(gd);
        displayFlag = getNextBoolean(gd);
        
        
        % run the kmeans
        [k, centroids] = kmeans(tab, nClasses);
        
        % create a new doc
        createTableFrame(frame.Gui, k);

        if displayCentroids
            % create a new doc
            createTableFrame(frame.Gui, centroids);
        end
        
        if displayFlag && size(tab, 2) > 1
            figure;
            scatterGroup(tab(:,1), tab(:,2), k);
        end
        
%         % add history
%         string = sprintf('%s = squeeze(slice(%s, 3, %d));\n', ...
%             newDoc.Tag, doc.Tag, sliceIndex);
%         addToHistory(frame, string);
    end
    
end % end methods

end % end classdef


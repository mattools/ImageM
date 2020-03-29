classdef TableKMeans < imagem.actions.CurrentTableAction
%Apply K-means clustering on the current table.
%
%   Class TableKMeans
%
%   Example
%   TableKMeans
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2019-11-15,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRAE - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = TableKMeans(varargin)
    % Constructor for TableKMeans class

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
        [frame2, doc2] = createTableFrame(frame.Gui, k);
        
        % optional processing of centroids
        if displayCentroids
            % create a new doc
            [frameC, docC] = createTableFrame(frame.Gui, centroids); %#ok<ASGLU>
            historyString = sprintf('[%s,%s] = kmeans(%s, %d);\n', ...
                doc2.Tag, docC.Tag, doc.Tag, nClasses);
        else
            historyString = sprintf('%s = kmeans(%s, %d);\n', ...
                doc2.Tag, doc.Tag, nClasses);
        end
        addToHistory(frame2, historyString);
        
        
        if displayFlag && size(tab, 2) > 1
            figure;
            scatterGroup(tab(:,1), tab(:,2), k);
        end
        
    end
    
end % end methods

end % end classdef


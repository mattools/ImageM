classdef PairPlot < imagem.actions.CurrentTableAction
% Pair-wise scatter plot of table columns.
%
%   Class PairPlot
%
%   Example
%   PairPlot
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-12-23,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = PairPlot(varargin)
        % Constructor for PairPlot class.

    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        
        table = frame.Doc.Table;
        
        % identify numeric columns
        inds = ~isFactor(table, 1:size(table, 2));
        colNames = table.ColNames(inds);
        
        % Open a dialog for choosing the columns to display
        [numColInds, ok] = listdlg(...
            'ListString', colNames, ...
            'Name', 'Pair Plot', ...
            'PromptString', 'Columns To Plot:', ...
            'ListSize', frame.Gui.Options.DlgListSize, ...
            'SelectionMode', 'Multiple');
        
        if ~ok || isempty(numColInds)
            return;
        end
        
        % If Table has factor columsn, add possibility to choose one
        factorIndex = -1;
        factorColumnName = '';
        inds = isFactor(table, 1:size(table, 2));
        if any(inds)
            factorColumnNames = table.ColNames(inds);
            % creates a new dialog, and populates it with some fields
            gd = imagem.gui.GenericDialog('Pair Plot Factor');
            addCheckBox(gd, 'Color by Factor Levels', true);
            addChoice(gd, 'Factor Column: ', factorColumnNames, factorColumnNames{1});
            
            % displays the dialog, and waits for user
            showDialog(gd);
            % check if ok or cancel was clicked
            if wasCanceled(gd)
                return;
            end
            
            % parse the user inputs
            if getNextBoolean(gd)
                factorColumnName = getNextString(gd);
                factorIndex = columnIndex(table, factorColumnName);
            end
        end
        
        % create pattern for writing history
        numColNames = table.ColNames(numColInds);
        nc = length(numColNames);
        pattern = ['{''%s''' repmat(', ''%s''', 1, nc-1) '}'];
        numColsString = sprintf(pattern, numColNames{:});
        
        % create Plot Pair display
        createPlotFrame(frame.Gui);
        if factorIndex > 0
            % plot using factor levels
            pairPlot(table(:, numColInds), table(:, factorIndex));
            % create history string
            historyString = sprintf('figure; pairPlot(%s(%s), %s(''%s''));\n', ...
                frame.Doc.Tag, numColsString, frame.Doc.Tag, factorColumnName);
        else
            % plot without factor
            pairPlot(table(:, numColInds));
            % create history string
            historyString = sprintf('figure; pairPlot(%s(%s));\n', ...
                frame.Doc.Tag, numColsString);
        end
        
        % add to history
        addToHistory(frame, historyString);
        
    end
end % end methods

end % end classdef


classdef PlotCorrelationCircles < imagem.actions.CurrentTableAction
% Pair-wise scatter plot of table columns.
%
%   Class PlotCorrelationCircles
%
%   Example
%   PlotCorrelationCircles
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
    function obj = PlotCorrelationCircles(varargin)
        % Constructor for PlotCorrelationCircles class.

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
            'Name', 'Correlation Circles', ...
            'PromptString', 'Columns To Plot:', ...
            'ListSize', frame.Gui.Options.DlgListSize, ...
            'SelectionMode', 'Multiple');
        
        if ~ok || isempty(numColInds)
            return;
        end
        
        % create Plot Pair display
        createPlotFrame(frame.Gui);
        correlationCircles(table(:, numColInds));
        
        % create pattern for writing history
        numColNames = table.ColNames(numColInds);
        nc = length(numColNames);
        pattern = ['{''%s''' repmat(', ''%s''', 1, nc-1) '}'];
        numColsString = sprintf(pattern, numColNames{:});
                
        % add to history
        string = sprintf('figure; correlationCircles(%s(%s));\n', ...
            frame.Doc.Tag, numColsString);
        addToHistory(frame, string);
        
    end
end % end methods

end % end classdef


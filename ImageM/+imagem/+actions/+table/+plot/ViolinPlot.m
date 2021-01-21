classdef ViolinPlot < imagem.actions.CurrentTableAction
% Violin plot of features within a table.
%
%   Class ViolinPlot
%
%   Example
%   ViolinPlot
%
%   See also
%     imagem.actions.CurrentTableAction
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-11-26,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = ViolinPlot(viewer)
    % Constructor for ViolinPlot class
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        
        % retrieve current table
        gui = frame.Gui;
        table = frame.Doc.Table;
        
        % opens a dialog to select features to display
        [indVar, ok] = listdlg('ListString', table.ColNames, ...
            'Name', 'ViolinPlot', ...
            'PromptString', 'Variables to display:', ...
            'ListSize', gui.Options.DlgListSize, ...
            'SelectionMode', 'multiple');
        
        if ~ok || isempty(indVar)
            return;
        end
        
        % open a new frame for plotting
        createPlotFrame(gui);
        violinPlot(table(:, indVar));

    end
end % end methods

end % end classdef


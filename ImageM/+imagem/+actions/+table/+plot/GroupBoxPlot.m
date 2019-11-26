classdef GroupBoxPlot < imagem.actions.CurrentTableAction
% GROUPBOXPLOTACTION
%
%   Class GroupBoxPlot
%
%   Example
%   GroupBoxPlot
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
    function obj = GroupBoxPlot()
    % Constructor for GroupBoxPlot class
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        gui = frame.Gui;
        table = frame.Doc.Table;

        [indVar, ok] = listdlg('ListString', table.ColNames, ...
            'Name', 'BoxPlot', ...
            'PromptString', 'Variable to display:', ...
            'ListSize', gui.Options.DlgListSize, ...
            'SelectionMode', 'Single');

        if ~ok || isempty(indVar)
            return;
        end

        [indGroup, ok] = listdlg('ListString', table.ColNames, ...
            'Name', 'BoxPlot', ...
            'PromptString', 'Grouping variable:', ...
            'ListSize', gui.Options.DlgListSize, ...
            'SelectionMode', 'Single');

        if ~ok || isempty(indGroup)
            return;
        end

        createPlotFrame(gui);

        boxplot(table(:, indVar), table(:, indGroup));

    end
end % end methods

end % end classdef


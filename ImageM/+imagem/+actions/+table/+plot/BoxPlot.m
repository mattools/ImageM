classdef BoxPlot < imagem.actions.CurrentTableAction
%Box Plot
%
%   Class BoxPlot
%
%   Example
%   BoxPlot
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
    function obj = BoxPlot(viewer)
    % Constructor for BoxPlot class
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        gui = frame.Gui;
        table = frame.Doc.Table;

        [indVar, ok] = listdlg('ListString', table.ColNames, ...
            'Name', 'BoxPlot', ...
            'PromptString', 'Variables to display:', ...
            'ListSize', gui.Options.DlgListSize, ...
            'SelectionMode', 'multiple');

        if ~ok || isempty(indVar)
            return;
        end

        createPlotFrame(gui);

        boxplot(table(:, indVar));

    end
end % end methods

end % end classdef


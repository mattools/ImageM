classdef PlotColumns < imagem.actions.CurrentTableAction
% Plot selected columns of the current table.
%
%   Class PlotSelectedColumns
%
%   Example
%   PlotSelectedColumns
%
%   See also
%     tblui.TableGuiAction
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
    function obj = PlotColumns()
    % Constructor for PlotSelectedColumns class
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        
        table = frame.Doc.Table;
        
        [sel, ok] = listdlg('ListString', table.ColNames, ...
            'Name', 'Plot Histogram', ...
            'PromptString', 'Columns To Plot:', ...
            'ListSize', frame.Gui.Options.DlgListSize, ...
            'SelectionMode', 'Multiple');
        
        if ~ok || isempty(sel)
            return;
        end
        
        
        createPlotFrame(frame.Gui);
        
        plot(table(:, sel));
        
    end
end % end methods

end % end classdef


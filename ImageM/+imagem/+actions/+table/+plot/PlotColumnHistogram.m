classdef PlotColumnHistogram < imagem.actions.CurrentTableAction
% Histogram of the values within the selected column of a table.
%
%   Class PlotColumnHistogram
%
%   Example
%   PlotColumnHistogram
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-12-07,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = PlotColumnHistogram(varargin)
        % Constructor for PlotColumnHistogram class.

    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        
        % retrieve data
        gui = frame.Gui;
        table = frame.Doc.Table;
        
        % create a dialog to select column from its name
        [indVar, ok] = listdlg('ListString', table.ColNames, ...
            'Name', 'Histogram', ...
            'PromptString', 'Column to display:', ...
            'ListSize', gui.Options.DlgListSize, ...
            'SelectionMode', 'single');
        
        % check the click on the "OK" button
        if ~ok || isempty(indVar)
            return;
        end
        
        % prepare graphics
        createPlotFrame(gui);
        
        % plot the histogram
        histogram(table(:, indVar));
    end
    
end % end methods

end % end classdef


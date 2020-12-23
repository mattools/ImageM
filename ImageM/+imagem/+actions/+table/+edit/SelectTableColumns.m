classdef SelectTableColumns < imagem.actions.CurrentTableAction
% Select several columns and create new table.
%
%   Class SelectTableColumns
%
%   Example
%   SelectTableColumns
%
%   See also
%     tblui.TableGui
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = SelectTableColumns(viewer)
    % Constructor for SelectTableColumnsAction class
        obj = obj@imagem.actions.CurrentTableAction();
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        
        % retrieve data
        gui = frame.Gui;
        table = frame.Doc.Table;
        
        % open dialog to select relevant columns
        [sel, ok] = listdlg('ListString', table.ColNames, ...
            'Name', 'Select Columns', ...
            'PromptString', 'Select the columns:', ...
            'ListSize', gui.Options.DlgListSize, ...
            'selectionmode', 'multiple');
        
        % check cancel
        if ~ok || isempty(sel)
            return;
        end
        
        % create new table
        tab2 = table(:, sel);
        [frame2, doc2] = createTableFrame(gui, tab2, frame);
        
        % add history
        indsString = ['[' num2str(sel(:)', '%d ') ']'];
        string = sprintf('%s = %s(:, %s);\n', ...
            doc2.Tag, frame.Doc.Tag, indsString);
        addToHistory(frame2, string);
    end
end % end methods

end % end classdef


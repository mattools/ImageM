classdef SelectTableRows < imagem.actions.CurrentTableAction
% Select several rows and create new table.
%
%   Class SelectTableRowsAction
%
%   Example
%   SelectTableRowsAction
%
%   See also
%     tblui.TableGuiAction
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
    function obj = SelectTableRows()
    % Constructor for SelectTableRowsAction class
        obj = obj@imagem.actions.CurrentTableAction();
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        
        gui = frame.Gui;
        table = frame.Doc.Table;
        
        [sel, ok] = listdlg('ListString', table.RowNames, ...
            'Name', 'Select Rows', ...
            'PromptString', 'Select the rows:', ...
            'ListSize', gui.Options.DlgListSize, ...
            'selectionmode', 'multiple');
        
        if ~ok || isempty(sel)
            return;
        end
        
        tab2 = table(sel, :);
        [frame2, doc2] = createTableFrame(gui, tab2);
        
        % add history
        indsString = ['[' num2str(sel(:)', '%d ') ']'];
        string = sprintf('%s = %s(%s, :);\n', ...
            doc2.Tag, frame.Doc.Tag, indsString);
        addToHistory(frame2, string);
    end
end % end methods

end % end classdef


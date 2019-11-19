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
        
        gui = frame.Gui;
        table = frame.Doc.Table;
        
        [sel, ok] = listdlg('ListString', table.ColNames, ...
            'Name', 'Select Columns', ...
            'PromptString', 'Select the columns:', ...
            'ListSize', gui.Options.DlgListSize, ...
            'selectionmode', 'multiple');
        
        if ~ok || isempty(sel)
            return;
        end
        
        tab2 = table(:, sel);
        createTableFrame(gui, tab2);
        
    end
end % end methods

end % end classdef


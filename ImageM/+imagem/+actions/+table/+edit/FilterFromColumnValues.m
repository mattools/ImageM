classdef FilterFromColumnValues < imagem.actions.CurrentTableAction
% Select rows in a table based on a logical condition on column values.
%
%   Class FilterFromColumnValues
%
%   Example
%   FilterFromColumnValues
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
    function obj = FilterFromColumnValues(varargin)
        % Constructor for FilterFromColumnValues class.
        obj = obj@imagem.actions.CurrentTableAction();
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        
        % retrieve data
        gui = frame.Gui;
        table = frame.Doc.Table;
        
        % initialize table name
        tableName = 'Table';
        if ~isempty(tableName)
            tableName = [table.Name '-sel'];
        end
        
        % identify numeric columns
        inds = ~isFactor(table, 1:size(table, 2));
        colNames = table.ColNames(inds);
        
        % get labels for operators
        opLabels = imagem.util.enums.RelationalOperators.allLabels;
        
        % creates a new dialog, and populates it with some fields
        gd = imagem.gui.GenericDialog('Filter Table from values');
        addChoice(gd, 'Column: ', colNames, colNames{1});
        addChoice(gd, 'Operation: ', opLabels, opLabels{1});
        addNumericField(gd, 'Value: ', 0);
        addTextField(gd, 'New Table Name: ', tableName);
        
        % displays the dialog, and waits for user
        showDialog(gd);
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % parse the user inputs
        colName = getNextString(gd);
        op = imagem.util.enums.RelationalOperators.fromLabel(getNextString(gd));
        value = getNextNumber(gd);
        tableName = getNextString(gd);
        
        % select the rows that fullfil the condition
        column = table(:, colName);
        inds = apply(op, column.Data, value);
        
        % create new tables
        tab2 = table(inds, :);
        tab2.Name = tableName;
        [frame2, doc2] = createTableFrame(gui, tab2, frame);
        
        % add to history
        string = sprintf('%s = %s(%s(''%s'') %s %d, :);\n', ...
            doc2.Tag, frame.Doc.Tag, frame.Doc.Tag, colName, op.Symbol, value);
        addToHistory(frame2, string);
        string = sprintf('%s.Name = ''%s'';\n', doc2.Tag, tableName);
        addToHistory(frame2, string);
    end
end % end methods

end % end classdef


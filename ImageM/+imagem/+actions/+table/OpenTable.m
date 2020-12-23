classdef OpenTable < imagem.gui.Action
% Open a new data table stored in a file.
%
%   Class OpenTable
%
%   Example
%   OpenTable
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
    function obj = OpenTable()
    % Constructor for OpenTable class
        obj = obj@imagem.gui.Action();
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        disp('% Open new table ');
        
        % get handle to parent GUI
        gui = frame.Gui;
        
        [fileName, pathName] = uigetfile( ...
            {'*.txt;*.csv',     'All Text Files (*.txt, *.csv)'; ...
            '*.txt',            'Text Files (*.txt)'; ...
            '*.csv',            'Coma-Separated Values (*.csv)'; ...
            '*.div',            'DIV Files (*.div)'; ...
            '*.*',              'All Files (*.*)'}, ...
            'Choose a data table file to open:');
        
        if isequal(fileName,0) || isequal(pathName,0)
            return;
        end
        
        % determine file options
        filePath = fullfile(pathName, fileName);
        [~, tableName] = fileparts(fileName);
        
        % creates a new dialog, and populates it with some fields
        gd = imagem.gui.GenericDialog('Import Table');
        addTextField(gd, 'Table Name: ', tableName);
        addNumericField(gd, 'Skip Lines: ', 0);
        addCheckBox(gd, 'Header Line', true);
        addChoice(gd, 'Delimiter: ', {'All spaces', ';', ',', 'Tabs', 'Spaces'}, 'All spaces');
        
        % displays the dialog, and waits for user
        showDialog(gd);
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % parse the user inputs
        tableName = getNextString(gd);
        skipLines = getNextNumber(gd);
        header = getNextBoolean(gd);
        delimIndex = getNextChoiceIndex(gd);
        delimList = {' \b\t', ';', ',', '\t', ' '};
        delim = delimList{delimIndex};
        
        % read the table
        tab = Table.read(filePath, ...
            'SkipLines', skipLines, ...
            'Header', header, ...
            'Delimiter', delim);
        tab.Name = tableName;
        
        % add image to application, and create new display
        [frame, doc] = createTableFrame(gui, tab);
        
        % add history
        string = sprintf('%s = Table.read(''%s'');\n', ...
            doc.Tag, filePath);
        addToHistory(frame, string);
    end
end % end methods

end % end classdef


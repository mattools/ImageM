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

        % read the table
        filePath = fullfile(pathName, fileName);
        tab = Table.read(filePath);
        
        % add image to application, and create new display
        [frame, doc] = createTableFrame(gui, tab);
        
        % add history
        string = sprintf('%s = Table.read(''%s'');\n', ...
            doc.Tag, filePath);
        addToHistory(frame, string);
    end
end % end methods

end % end classdef


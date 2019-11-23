classdef SaveTable < imagem.actions.CurrentTableAction
% Save the current image into a file.
%
%   Class SaveTable
%
%   Example
%   SaveTable
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = SaveTable()
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        disp('Save current table');
        
        % Open dialog to save image
        [fileName, pathName] = uiputfile( ...
            {'*.txt;*.csv', ...
            'All Table Files (*.txt, *.csv)'; ...
            '*.txt',                    'Text Files (*.txt)'; ...
            '*.tsv',                    'Tab-Separated values (*.csv)'; ...
            '*.csv',                    'Comma-Separated values (*.csv)'; ...
            '*.*',                      'All Files (*.*)'}, ...
            'Save Table');
        
        if isequal(fileName,0) || isequal(pathName,0)
            return;
        end

        % try to save the current image
        doc = currentDoc(frame);
        tab = doc.Table;
        try
            write(tab, fullfile(pathName, fileName));
        catch ex
            errordlg(ex.message, 'Image Writing Error', 'modal');
            return;
        end
        
        % add history
        string = sprintf('write(%s, ''%s'');\n', ...
            doc.Tag, fullfile(pathName, fileName));
        addToHistory(frame, string);
        
    end % end actionPerformed
    
end % end methods

end % end classdef


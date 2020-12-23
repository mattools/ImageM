classdef RenameTable < imagem.actions.CurrentTableAction
% Change the name of the current table.
%
%   Class RenameTable
%
%   Example
%   RenameTable
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
    function obj = RenameTable()
    % Constructor for RenameTableAction class
        obj = obj@imagem.actions.CurrentTableAction();
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        
        table = frame.Doc.Table;

        answer = inputdlg({'Enter the new table name:'}, ...
            'Change Table Name', ...
            1, ...
            {table.Name});
        
        if isempty(answer)
            return;
        end

        % get new name
        newName = answer{1};
        
        % setup new name
        table.Name = newName;
        updateTitle(frame);
        
        % add history
        string = sprintf('%s.Name = ''%s'';\n', ...
            frame.Doc.Tag, newName);
        addToHistory(frame, string);

    end
end % end methods

end % end classdef


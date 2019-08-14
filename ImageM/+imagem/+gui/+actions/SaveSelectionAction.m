classdef SaveSelectionAction < imagem.gui.actions.CurrentImageAction
% Save current selection in text file.
%
%   Class SaveSelectionAction
%
%   Example
%   SaveSelectionAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = SaveSelectionAction(viewer)
    % Constructor for SaveSelectionAction class
    
        % calls the parent constructor
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, 'saveSelection');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, src, event) %#ok<INUSD>

        disp('Save current image selection');
        
        viewer = obj.Viewer;
        selection = viewer.Selection;
        if isempty(selection)
            errordlg('No selection in current image');
            return;
        end
        
        % Open dialog to save selection
        [fileName, pathName] = uiputfile( ...
            {'*.txt',       'Text file (*.txt)'; ...
            '*.*',          'All Files (*.*)'}, ...
            'Save Selection');
        
        if isequal(fileName,0) || isequal(pathName,0)
            return;
        end

        % open file for writing
        f = fopen(fullfile(pathName, fileName), 'wt');
        if f == -1
            errordlg(['Could not open file:\n' fullfile(pathName, fileName)]);
            return;
        end
       
        
        % different type of processing depending on selection type
        switch lower(selection.Type)
            case {'polyline', 'polygon', 'pointset'}
                % number of vertices
                nv = size(selection.Data, 1);
                
                % write selection type
                fprintf(f, '# %s 2 %d\n', selection.Type, nv);
                
                for i = 1:nv
                    fprintf(f, '%d %d\n', selection.Data(i,1), selection.Data(i,2));
                end
                
            otherwise
                errordlg('Can not save type-%s selections', selection.Type);
                return;
        end
        
        % closes the file
        fclose(f);
        
    end
end % end methods

end % end classdef


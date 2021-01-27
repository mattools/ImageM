classdef SaveSelection < imagem.actions.CurrentImageAction
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
    function obj = SaveSelection()
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>

        disp('Save current image selection');
        
        selection = frame.Selection;
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
        if isa(selection, 'LineString2D')
            % get vertex coords
            coords = vertexCoordinates(selection);
            nv = size(coords, 1);
            % write selection data
            fprintf(f, '# %s 2 %d\n', 'Polyline2D', nv);
            for i = 1:nv
                fprintf(f, '%d %d\n', coords(i,1), coords(i,2));
            end
            
        elseif isa(selection, 'SimplePolygon2D')
            % get vertex coords
            coords = selection.Coords;
            nv = size(coords, 1);
            % write selection data
            fprintf(f, '# %s 2 %d\n', 'Polygon2D', nv);
            for i = 1:nv
                fprintf(f, '%d %d\n', coords(i,1), coords(i,2));
            end
            
        elseif isa(selection, 'MultiPoint2D')
            % get vertex coords
            coords = selection.Coords;
            nv = size(coords, 1);
            % write selection data
            fprintf(f, '# %s 2 %d\n', 'MultiPoint2D', nv);
            for i = 1:nv
                fprintf(f, '%d %d\n', coords(i,1), coords(i,2));
            end
        else
            errordlg('Can not save type-%s selections', class(selection));
            return;
        end
        
        % closes the file
        fclose(f);
        
    end
end % end methods

end % end classdef


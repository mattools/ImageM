classdef TableFrame < imagem.gui.ImagemFrame
%TABLEFRAME Frame for displaying Table and providing some operations.
%
%   Class TableFrame
%
%   Example
%   TableFrame
%
%   See also
%      ImagemFrame, ImageViewer, PlanarImageViewer

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-11-17,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    % The Table Document containing the table.
    Doc;
    
    SelectedIndices;
    
end % end properties


%% Constructor
methods
    function obj = TableFrame(gui, doc)
        % Constructor for TableFrame class.
        %
        %  Usage:
        %  OBJ = imagem.gui.TableFrame(GUI, Doc);
        %  where GUI is an instance of ImagemGUI, and DOC is an instance of
        %  the "imagem.app.TableDoc" class.
        
        % call constructor of super class
        obj = obj@imagem.gui.ImagemFrame(gui);
        
        if ~isempty(doc) && ~isa(doc, 'imagem.app.TableDoc')
            error('Second Input must be an instance of TableDoc');
        end
        obj.Doc = doc;
        
        % create default figure
        fig = figure(...
            'MenuBar', 'none', ...
            'NumberTitle', 'off', ...
            'HandleVisibility', 'On', ...
            'Name', 'Table Viewer', ...
            'CloseRequestFcn', @obj.close);
        
        % create main figure menu
        createFrameMenu(gui, fig, obj);
        if ~isempty(obj.Doc)
            setupLayout(fig);
        end
        
        obj.Handles.Figure = fig;
        
        updateTitle(obj);
        
        
        function setupLayout(hf)
            
            table = obj.Doc.Table;
            
            % format table data
            if ~hasFactors(table)
                % create a numeric data table
                data = table.Data;
                
            else
                % if data table has factor columns, need to convert data array
                data = num2cell(table.Data);
                indLevels = find(~cellfun(@isnumeric, table.Levels));
                for i = indLevels
                    data(:,i) = table.Levels{i}(table.Data(:, i));
                end
                
            end
                        
            % add a uitable component
            ht = uitable(hf, ...
                'Units', 'normalized', ...
                'Position', [0 0 1 1], ...
                'Data', data,...
                'ColumnName', table.ColNames,...
                'RowName', table.RowNames, ...
                'ColumnEditable', false, ...
                ... 'UIContextMenu', hMenu, ...
                'CellSelectionCallback', @obj.onCellSelected, ...
                'CellEditCallback', @obj.onCellEdited);
            
            obj.Handles.Uitable = ht;
            drawnow;
        end
        
    end

end % end constructors


%% Methods
methods
    function updateTitle(obj)
        % Set up title of the figure, depending on image size and type.
        
        % small checkup, because function can be called before figure was
        % initialised
        if ~isfield(obj.Handles, 'Figure')
            return;
        end
        
        if isempty(obj.Doc.Table)
            return;
        end
        
        tab = obj.Doc.Table;
        
        % setup name to display
        tableName = tab.Name;
        if isempty(tableName)
            tableName = '[NoName]';
        end
    
        % size of table
        nr = size(tab, 1);
        nc = size(tab, 2);
        
        if obj.Doc.Modified
            modif = '*';
        else
            modif = '';
        end

        % compute new title string
        titlePattern = '%s%s [%d x %d Table] - ImageM';
        titleString = sprintf(titlePattern, tableName, modif, nr, nc);
        
        % display new title
        set(obj.Handles.Figure, 'Name', titleString);
    end
        
end % end methods

%% Edition of cells
methods
    function onCellEdited(obj, varargin) %#ok<INUSD>
        disp('edited a cell');
    end

    function onCellSelected(obj, gcbo, eventdata)  %#ok<INUSL>
        obj.SelectedIndices = eventdata.Indices;
    end

end


%% Figure management
methods
    function close(obj, varargin)
        delete(obj.Handles.Figure);
    end
    
end

end % end classdef


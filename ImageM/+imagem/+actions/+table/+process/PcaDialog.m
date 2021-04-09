classdef PcaDialog < handle
% Choose options for PCA and display results of computations.
%
%   Class PcaDialog
%
%   Example
%   PcaDialog
%
%   See also
%     tblui.TableGuiAction
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2013-04-16,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.


%% Properties
properties
    % the input data table
    Table;
    
    % The original parent document
    ParentDoc;
    
    % the results of the PCA
    ResPca;
    
    % flag indicating whether the pca results are valid or not
    ValidFlag = false;
    
    % the parent GUI
    Gui;
    
    % list of handles to the various gui items
    Handles;
    
end % end properties


%% Constructor
methods
    function obj = PcaDialog(gui, table, varargin)
    % Constructor for PcaDialog class
    
        % call parent constructor to initialize members
        obj = obj@handle();
        
        obj.Gui = gui;
        obj.Table = table;
        
        while ~isempty(varargin)
            if isa(varargin{1}, 'imagem.gui.TableFrame')
                refFrame = varargin{1};
                obj.ParentDoc = currentDoc(refFrame);
            else
                error('Unkown parameter');
            end
            varargin(1) = [];
        end

        % create default figure
        fig = figure(...
            'MenuBar', 'none', ...
            'NumberTitle', 'off', ...
            'HandleVisibility', 'On', ...
            'Name', 'Pca Results Frame', ...
            'CloseRequestFcn', @obj.close);
        obj.Handles.Figure = fig;
        
        updateTitle(obj);
        
        % create main figure menu
        createFigureMenu(fig);
        setupLayout(fig);
        

        function createFigureMenu(hf)
            % Creates the figure menu bar
            
            fileMenu = uimenu(hf, 'Label', 'Files');
            uimenu(fileMenu, ...
                'Enable', 'off', ...
                'Label', 'Save');
            uimenu(fileMenu, 'Label', 'Close', ...
                'Separator', 'on', ...
                'Callback', @obj.close);
            
            
            tableMenu = uimenu(hf, 'Label', 'Tables');
            uimenu(tableMenu, ...
                'Label', 'Show Eigen Values Table', ...
                'Callback', @obj.onShowEigenValuesTable);
            uimenu(tableMenu, ...
                'Label', 'Show Scores Table', ...
                'Callback', @obj.onShowScoresTable);
            uimenu(tableMenu, ...
                'Label', 'Show Loadings Table', ...
                'Callback', @obj.onShowLoadingsTable);
            
            
            plotMenu = uimenu(hf, 'Label', 'Plot');
            uimenu(plotMenu, 'Label', 'Scree Plot', ...
                'Callback', @obj.onScreePlot);
            
            action = tblui.pca.ScorePlotAction(obj);
            uimenu(plotMenu, ...
                'Label', 'Score Plot', ...
                'Separator', 'on', ...
                'Callback', @action.actionPerformed);
            
            action = tblui.pca.LoadingPlotAction(obj);
            uimenu(plotMenu, ...
                'Label', 'Loadings Plot', ...
                'Callback', @action.actionPerformed);
            
            action = tblui.pca.CorrelationCirclePlotAction(obj);
            uimenu(plotMenu, ...
                'Label', 'Correlation circle', ...
                'Callback', @action.actionPerformed);
            
        end
        

        function setupLayout(hf)
            % Setup layout of figure widgets
            
            % compute background color of most widgets
            bgColor = get(0, 'defaultUicontrolBackgroundColor');
            if ispc
                bgColor = 'White';
            end
            set(hf, 'defaultUicontrolBackgroundColor', bgColor);
            set(hf, 'Units', 'pixels');
            pos = get(hf, 'Position');
            pos(3:4) = [440 330];
            set(hf, 'Position', pos);
            set(hf, 'Units', 'normalized');
            
            leftPanel = uix.VBox('Parent', hf, ...
                'Position', [.03 .03 .35 .94]);
            
            % Setup figure background to the same color as widgets
            bgColor = get(leftPanel, 'BackgroundColor');
            set(hf, 'Color', bgColor);

            % control panel: use vertical layout
            optionsPanel = uix.VButtonBox('Parent', leftPanel, ...
                'ButtonSize', [150 30], ...
                'VerticalAlignment', 'top', ...
                'HorizontalAlignment', 'left', ...
                'Spacing', 5, 'Padding', 5);

            obj.Handles.ScaleCheckbox = uicontrol(...
                'Style', 'checkbox', 'Parent', optionsPanel, ...
                'String', 'Scaled', ...
                'Value', 1, ...
                'Enable', 'on', ...
                'BackgroundColor', bgColor, ...
                'HorizontalAlignment', 'Left');
            
            obj.Handles.DisplayCheckbox = uicontrol(...
                'Style', 'checkbox', 'Parent', optionsPanel, ...
                'String', 'Display', ...
                'Value', true, ...
                'Enable', 'on', ...
                'BackgroundColor', bgColor, ...
                'HorizontalAlignment', 'Left');
            
            obj.Handles.LoadingsPlotTypeLabel = uicontrol(...
                'Style', 'text', 'Parent', optionsPanel, ...
                'String', 'Loadings Plot Type:', ...
                'Value', true, ...
                'Enable', 'on', ...
                'BackgroundColor', bgColor, ...
                'HorizontalAlignment', 'Left');
            
            obj.Handles.LoadingsPlotTypePopup = uicontrol(...
                'Style', 'popupmenu', 'Parent', optionsPanel, ...
                'String', {'line', 'bar', 'stairSteps', 'stem'}, ...
                'Value', 2, ...
                'Enable', 'on', ...
                'BackgroundColor', bgColor, ...
                'HorizontalAlignment', 'Left');
            
            obj.Handles.SaveCheckbox = uicontrol(...
                'Style', 'checkbox', 'Parent', optionsPanel, ...
                'String', 'Save Results', ...
                'Value', true, ...
                'Enable', 'on', ...
                'BackgroundColor', bgColor, ...
                'HorizontalAlignment', 'Left');
            

            buttonsPanel = uix.HButtonBox('Parent', leftPanel, ...
                'ButtonSize', [70 30], ...
                'VerticalAlignment', 'top', ...
                'Spacing', 5, 'Padding', 5, ...
                'Units', 'normalized', ...
                'Position', [0 0 1 1]);
            obj.Handles.ApplyButton = uicontrol('Style', 'PushButton', ...
                'Parent', buttonsPanel, ...
                'String', 'Compute', ...
                'Enable', 'on', ...
                'BackgroundColor', bgColor, ...
                'Callback', @obj.onApplyButtonClicked);
            obj.Handles.CloseButton = uicontrol('Style', 'PushButton', ...
                'Parent', buttonsPanel, ...
                'String', 'Close', ...
                'BackgroundColor', bgColor, ...
                'Callback', @obj.onCloseButtonClicked);
            
            leftPanel.Heights = [-1 40];

            
            % Display a table with inertia
            obj.Handles.EigenValuesTable = uitable(...
                'Parent', hf', ...
                'Units', 'normalized', ...
                'Position', [.40 .03 .57 .94]);            
        end
        
        
    end

end % end constructors


%% Figure creation
methods
    function updateTitle(obj)
        % Update title of main figure with current data

        if obj.ValidFlag
            % extract table infos
            name = obj.Table.Name;
            nr = size(obj.Table, 1);
            nc = size(obj.Table, 2);

            % create figure name
            pattern = 'Pca Results of %s (%d-by-%d Data Table)';
            titleString = sprintf(pattern, name, nr, nc);
        else
            titleString = 'Principal Components Analysis';
        end
        
        % display new title
        set(obj.Handles.Figure, 'Name', titleString);
    end
end

%% GUI Widgets management

methods
    
    function onShowEigenValuesTable(obj, varargin)
        % Display a new table frame with eigen values
        
        if isempty(obj.ResPca)
            return;
        end
        
        eigenValues = obj.ResPca.EigenValues;
        createTableFrame(obj.Gui, eigenValues, obj.ParentDoc);
    end
    
    function onShowScoresTable(obj, varargin)
        % Display a new table frame with scores
        
        if isempty(obj.ResPca)
            return;
        end
        
        scores = obj.ResPca.Scores;
        createTableFrame(obj.Gui, scores, obj.ParentDoc);
    end
    
    function onShowLoadingsTable(obj, varargin)
        % Display a new table frame with loadings
        
        if isempty(obj.ResPca)
            return;
        end
        
        loadings = obj.ResPca.Loadings;
        createTableFrame(obj.Gui, loadings, obj.ParentDoc);
    end
    
    function onScreePlot(obj, varargin)
        screePlot(obj.ResPca);
    end
        
    function onApplyButtonClicked(obj, hObject, eventdata) %#ok<INUSD>
        % Computes the PCA and display some results
        
        % invalidate some gui items
        set(obj.Handles.ApplyButton, 'Enable', 'off');

        % extract computations options
        scale = get(obj.Handles.ScaleCheckbox, 'Value');
        if get(obj.Handles.DisplayCheckbox, 'Value')
            display = 'on';
        else
            display = 'off';
        end
        
        loadingsPlotTypeIndex = get(obj.Handles.LoadingsPlotTypePopup, 'Value');
        typeList = get(obj.Handles.LoadingsPlotTypePopup, 'String');
        loadingsPlotType = typeList{loadingsPlotTypeIndex};
        
        % performs computations
        obj.ResPca = Pca(obj.Table, 'scale', scale, 'display', display);
        obj.ValidFlag = true;

        % setup loadings display
        nc = size(obj.ResPca.Loadings, 2);
        obj.ResPca.Loadings.PreferredPlotTypes = repmat({loadingsPlotType}, 1, nc);
        
        % update display of results
        set(obj.Handles.EigenValuesTable, ...
            'Data', obj.ResPca.EigenValues.Data, ...
            'ColumnName', {'Values', 'Inertia', 'Cumulated'}, ...
            'ColumnWidth', {55, 55, 60} );
        
        updateTitle(obj);
        
        % revalidate gui items
        set(obj.Handles.ApplyButton, 'Enable', 'on');
    end
    
    function onCloseButtonClicked(obj, hObject, eventdata) %#ok<INUSD>
        close(obj);
    end
 
end


%% Figure management
methods
    function close(obj, varargin)
        delete(obj.Handles.Figure);
    end
    
end


end % end classdef


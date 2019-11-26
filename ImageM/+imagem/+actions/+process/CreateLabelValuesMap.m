classdef CreateLabelValuesMap < imagem.actions.LabelImageAction
%CREATELABELVALUESMAP  One-line description here, please.
%
%   Class CreateLabelValuesMap
%
%   Example
%   CreateLabelValuesMap
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-11-22,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    Handles;
    Frame;
    
    TableNameList;
    ColumnNameList;
    
end % end properties


%% Constructor
methods
    function obj = CreateLabelValuesMap(varargin)
    % Constructor for CreateLabelValuesMap class

    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSD>
        % Convert a label image to RGB image
        
        if ~isLabelImage(currentImage(frame))
            warning('ImageM:WrongImageType', ...
                'Can only be applied on label images');
            return;
        end
        
        obj.Frame = frame;

        % initialize clas fields
        app = frame.Gui.App;
        obj.TableNameList = getTableNames(app);
        if isempty(obj.TableNameList)
            errordlg('Requires At least one table frame', 'modal');
            return;
        end
        tableName = obj.TableNameList{1};
        doc = getTableDocument(app, tableName);
        obj.ColumnNameList = doc.Table.ColNames;
        
        % display figure
        createFigure(obj, frame);
    end
    
    
    function hf = createFigure(obj, frame)
        
        % creates the figure
        hf = figure(...
            'Name', 'Colorize Labels', ...
            'MenuBar', 'none', ...
            'Toolbar', 'none', ...
            'CloseRequestFcn', @obj.closeFigure);
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = [250 200];
        set(hf, 'Position', pos);
        
        obj.Handles.Figure = hf;
        
        % vertical layout
        vb  = uix.VBox('Parent', hf, 'Spacing', 5, 'Padding', 5);
        mainPanel = uix.VBox('Parent', vb);
        
        gui = frame.Gui;
        
        obj.Handles.TableNameCombo = addComboBoxLine(gui, mainPanel, ...
            'Table Name:', obj.TableNameList, ...
            @obj.onTableNameChanged);
        
        obj.Handles.ColumnNameCombo = addComboBoxLine(gui, mainPanel, ...
            'Column Name:', obj.ColumnNameList, ...
            @obj.onColumnNameChanged);
        
        obj.Handles.BackgroundValueTextField = addInputTextLine(gui, mainPanel, ...
            'Background Value:', '0.0');
        
        %         obj.Handles.shuffleMapCheckbox = addCheckBox(gui, mainPanel, ...
        %             'Shuffle map', true, ...
        %             @obj.onShuffleMapChanged);
        
        
        set(mainPanel, 'Heights', [35 25 35]);
        
        % button for control panel
        buttonsPanel = uix.HButtonBox( 'Parent', vb, 'Padding', 5);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'OK', ...
            'Callback', @obj.onButtonOK);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'Cancel', ...
            'Callback', @obj.onButtonCancel);
        
        set(vb, 'Heights', [-1 40] );
    end
    
    function closeFigure(obj, varargin)
        
        % close the current fig
        if ishandle(obj.Handles.Figure)
            delete(obj.Handles.Figure);
        end
    end
    
end % end methods


%% GUI Items Callback
methods
    function onTableNameChanged(obj, varargin)
        ind = get(obj.Handles.TableNameCombo, 'Value');
        tableName = obj.TableNameList{ind};
        doc = getTableDocument(obj.Frame.Gui.App, tableName);
        obj.ColumnNameList = doc.Table.ColNames;
        set(obj.Handles.ColumnNameCombo, 'String', obj.ColumnNameList);
%         obj.MapName = obj.MapFuns{ind};
%         updatePreviewImage(obj);
    end

    function onColumnNameChanged(obj, varargin)
%         ind = get(obj.Handles.ColumnNameCombo, 'Value');
%         obj.BgColorName = obj.ColorNames{ind};
%         updatePreviewImage(obj);
    end
       
end

%% Control buttons Callback
methods
    function onButtonOK(obj, varargin)
        ind = get(obj.Handles.TableNameCombo, 'Value');
        tableName = obj.TableNameList{ind};
        tableDoc = getTableDocument(obj.Frame.Gui.App, tableName);
        
        ind = get(obj.Handles.ColumnNameCombo, 'Value');
        colName = obj.ColumnNameList{ind};
        column = tableDoc.Table(colName);
        values = column.Data;
        
        bgValueText = get(obj.Handles.BackgroundValueTextField, 'String');
        if strcmpi(bgValueText, 'NaN')
            bgValue = NaN;
        elseif strcmpi(bgValueText, '-inf')
            bgValue = -inf;
        elseif strcmpi(bgValueText, '+inf')
            bgValue = inf;
        else
            bgValue = str2double(bgValueText);
        end

        labelImage = obj.Frame.Doc.Image;
        labelList = unique(labelImage.Data(:));
        labelList(labelList == 0) = [];
        nLabels = length(labelList);

        resData = ones(size(labelImage.Data)) * bgValue;
        for i = 1:nLabels
            resData(labelImage.Data == labelList(i)) = values(i);
        end
        res = Image('Data', resData, 'parent', labelImage, 'type', 'intensity');

        % create document containing the new image
        [newDoc, newFrame] = addImageDocument(obj.Frame, res); %#ok<ASGLU>

        valueRange = [min(values) max(values)];
        newFrame.DisplayRange = valueRange;
%         newDoc = addImageDocument(obj.Frame, res);
%         
%         % add history
%         string = sprintf('%s = label2rgb(%s, ''%s'', ''%s''));\n', ...
%             newDoc.Tag, obj.Viewer.Doc.Tag, obj.MapName, obj.BgColorName);
%         addToHistory(obj.Frame, string);
%         
        closeFigure(obj);
    end
    
    function onButtonCancel(obj, varargin)
        closeFigure(obj);
    end
end

end % end classdef


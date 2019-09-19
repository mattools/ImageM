classdef ImageWatershed < imagem.actions.ScalarImageAction
% Apply watershed to an intensity image.
%
%   output = ImageWatershedAction(input)
%
%   Example
%   ImageWatershedAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-02-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    Handles;
    Viewer;
    
    Conn = 4;
    ConnValues = [4, 8];
    
    ComputeWatershed = true;
    ComputeBasins = false;
end

methods
    function obj = ImageWatershed()
    end
end

methods
    function run(obj, frame) %#ok<INUSD>

        obj.Viewer = frame;
        if ~isScalarImage(currentImage(frame))
            warning('ImageM:WrongImageType', ...
                'Watershed can be applied only on scalar images');
            return;
        end
        
        createWatershedFigure(obj);
        updateWidgets(obj);
    end
    
    function hf = createWatershedFigure(obj)
        
        gui = obj.Viewer.Gui;

        % creates the figure
        hf = figure(...
            'Name', 'Image Watershed', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', ...
            'Toolbar', 'none', ...
            'CloseRequestFcn', @obj.closeFigure);
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = [200 150];
        set(hf, 'Position', pos);
        
        obj.Handles.Figure = hf;
        
        % vertical layout
        vb  = uix.VBox('Parent', hf, 'Spacing', 5, 'Padding', 5);
        mainPanel = uix.VBox('Parent', vb);
        
        obj.Handles.ConnectivityPopup = addComboBoxLine(gui, mainPanel, ...
            'Connectivity:', {'4', '8'}, ...
            @obj.onConnectivityChanged);

        obj.Handles.resultTypePopup = addComboBoxLine(gui, mainPanel, ...
            'ResultType:', {'Watershed', 'Basins', 'Both'}, ...
            @obj.onResultTypeChanged);
        
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
        % clean up viewer figure
        clearPreviewImage(obj.Viewer);
        
        % close the current fig
        if ishandle(obj.Handles.Figure)
            delete(obj.Handles.Figure);
        end
    end
    
    function updateWidgets(obj)
        
        % update preview image of the document
        bin = computeWatershedImage(obj) == 0;
        img = overlay(currentImage(obj), bin);
        updatePreviewImage(obj.Viewer, img);
    end
    
end

%% Control buttons Callback
methods
    function onButtonOK(obj, varargin)        
        % apply the threshold operation
        wat = computeWatershedImage(obj);
        if obj.ComputeWatershed
            newDoc = addImageDocument(obj.Viewer, wat == 0);
        end
        if obj.ComputeBasins
            newDoc = addImageDocument(obj.Viewer, uint16(wat));
        end
        
        % add history
        string = sprintf('%s = watershed(%s, %d);\n', ...
            newDoc.Tag, obj.Viewer.Doc.Tag, obj.Conn);
        addToHistory(obj.Viewer, string);

        closeFigure(obj);
    end
    
    function onButtonCancel(obj, varargin)
        closeFigure(obj);
    end
end


%% GUI Items Callback
methods
    function onConnectivityChanged(obj, varargin)
        index = get(obj.Handles.ConnectivityPopup, 'Value');
        obj.Conn = obj.ConnValues(index);
        
        updateWidgets(obj);
    end
    
    function onResultTypeChanged(obj, varargin)
        type = get(obj.Handles.resultTypePopup, 'Value');
        switch type
            case 1
                obj.ComputeWatershed = true;
                obj.ComputeBasins = false;
            case 2
                obj.ComputeWatershed = false;
                obj.ComputeBasins = true;
            case 3
                obj.ComputeWatershed = true;
                obj.ComputeBasins = true;
        end
    end
    
    function wat = computeWatershedImage(obj)
        wat = watershed(obj.Viewer.Doc.Image, obj.Conn);
    end
end

end
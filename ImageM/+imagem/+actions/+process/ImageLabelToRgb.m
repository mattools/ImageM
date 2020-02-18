classdef ImageLabelToRgb < imagem.actions.LabelImageAction
% Convert label image to RGB image.
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
    
    Frame;
    
    MapNames = {'Jet', 'ColorCube', 'HSV'};
    MapFuns = {'jet', 'colorcube', 'hsv'};
    MapName = 'jet';
    
    ColorNames = {'White', 'Black', 'Red', 'Green', 'Blue', 'Cyan', 'Magenta', 'Yellow'};
    ColorChars = {'w', 'k', 'r', 'g', 'b', 'c', 'm', 'y'};
    BgColorName = 'w';
    
    ShuffleString = 'shuffle';
    
end

methods
    function obj = ImageLabelToRgb()
    end
end

methods
    function run(obj, frame) %#ok<INUSD>
        % Convert a label image to RGB image
        
        if ~isLabelImage(currentImage(frame))
            warning('ImageM:WrongImageType', ...
                'Can only be applied on label images');
            return;
        end
        
        obj.Frame = frame;
        createFigure(obj, frame);
        updatePreviewImage(obj);
    end
    
    function hf = createFigure(obj, frame)
        
        % creates the figure
        hf = figure(...
            'Name', 'Label To RGB', ...
            'NumberTitle', 'off', ...
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

        obj.Handles.ColorMapCombo = addComboBoxLine(gui, mainPanel, ...
            'Colormap:', obj.MapNames, ...
            @obj.onColorMapChanged);

        obj.Handles.BgColorCombo = addComboBoxLine(gui, mainPanel, ...
            'Background Color:', obj.ColorNames, ...
            @obj.onBgColorChanged);

        obj.Handles.ShuffleMapCheckbox = addCheckBox(gui, mainPanel, ...
            'Shuffle map', true, ...
            @obj.onShuffleMapChanged);

        
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
        % clean up viewer figure
        obj.Frame.Doc.PreviewImage = [];
        updateDisplay(obj.Frame);
        
        % close the current fig
        if ishandle(obj.Handles.Figure)
            delete(obj.Handles.Figure);
        end
    end
    
    function updatePreviewImage(obj)
        % update preview image of the document
        img = computePreviewImage(obj);
        obj.Frame.Doc.PreviewImage = img;
        updateDisplay(obj.Frame);
    end
    
    function rgb = computePreviewImage(obj)
        img = currentImage(obj.Frame);
        rgb = label2rgb(img, obj.MapName, obj.BgColorName, obj.ShuffleString);
    end
end

%% Control buttons Callback
methods
    function onButtonOK(obj, varargin)        
        
        % apply the threshold operation
        res = computePreviewImage(obj);

        % create document containing the new image
        newDoc = addImageDocument(obj.Frame, res);
        
        % add history
        string = sprintf('%s = label2rgb(%s, ''%s'', ''%s''));\n', ...
            newDoc.Tag, obj.Frame.Doc.Tag, obj.MapName, obj.BgColorName);
        addToHistory(obj.Frame, string);
        
        closeFigure(obj);
    end
    
    function onButtonCancel(obj, varargin)
        closeFigure(obj);
    end
end


%% GUI Items Callback
methods
    
    function onColorMapChanged(obj, varargin)
        ind = get(obj.Handles.ColorMapCombo, 'Value');
        obj.MapName = obj.MapFuns{ind};
        updatePreviewImage(obj);
    end

    function onBgColorChanged(obj, varargin)
        ind = get(obj.Handles.BgColorCombo, 'Value');
        obj.BgColorName = obj.ColorNames{ind};
        updatePreviewImage(obj);
    end
    
    function onShuffleMapChanged(obj, varargin)
        if get(obj.Handles.ShuffleMapCheckbox, 'Value')
            obj.ShuffleString = 'shuffle';
        else
            obj.ShuffleString = 'noshuffle';
        end
        updatePreviewImage(obj);
    end
    
end

end
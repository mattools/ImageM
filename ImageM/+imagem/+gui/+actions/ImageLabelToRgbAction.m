classdef ImageLabelToRgbAction < imagem.gui.actions.LabelImageAction
%IMAGEIMPOSEDWATERSHEDACTION Apply imposed watershed to an intensity image
%
%   output = ImageWatershedAction(input)
%
%   Example
%   ImageWatershedAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-02-27,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    handles;
    
    mapNames = {'Jet', 'ColorCube', 'HSV'};
    mapFuns = {'jet', 'colorcube', 'hsv'};
    mapName = 'jet';
    
    colorNames = {'White', 'Black', 'Red', 'Green', 'Blue', 'Cyan', 'Magenta', 'Yellow'};
    colorChars = {'w', 'k', 'r', 'g', 'b', 'c', 'm', 'y'};
    bgColorName = 'w';
    
    shuffleString = 'shuffle';
    
end

methods
    function this = ImageLabelToRgbAction(viewer)
        % calls the parent constructor
        this = this@imagem.gui.actions.LabelImageAction(viewer, 'labelToRgb');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        % Convert a label image to RGB image
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;
        
        if ~isLabelImage(doc.image)
            warning('ImageM:WrongImageType', ...
                'Can be applied only on label images');
            return;
        end
        
        createFigure(this);
        updatePreviewImage(this);
    end
    
    function hf = createFigure(this)
        
        % creates the figure
        hf = figure(...
            'Name', 'Label To RGB', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', ...
            'Toolbar', 'none', ...
            'CloseRequestFcn', @this.closeFigure);
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = [250 200];
        set(hf, 'Position', pos);
        
        this.handles.figure = hf;
        
        % vertical layout
        vb  = uiextras.VBox('Parent', hf, 'Spacing', 5, 'Padding', 5);
        mainPanel = uiextras.VBox('Parent', vb);
        
        gui = this.viewer.gui;

        this.handles.colorMapCombo = addComboBoxLine(gui, mainPanel, ...
            'Colormap:', this.mapNames, ...
            @this.onColorMapChanged);

        this.handles.bgColorCombo = addComboBoxLine(gui, mainPanel, ...
            'Background Color:', this.colorNames, ...
            @this.onBgColorChanged);

        this.handles.shuffleMapCheckbox = addCheckBox(gui, mainPanel, ...
            'Shuffle map', true, ...
            @this.onShuffleMapChanged);

        
        set(mainPanel, 'Sizes', [35 25 35]);
        
        % button for control panel
        buttonsPanel = uiextras.HButtonBox( 'Parent', vb, 'Padding', 5);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'OK', ...
            'Callback', @this.onButtonOK);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'Cancel', ...
            'Callback', @this.onButtonCancel);
        
        set(vb, 'Sizes', [-1 40] );
    end
        
    function closeFigure(this, varargin)
        % clean up viewer figure
        this.viewer.doc.previewImage = [];
        updateDisplay(this.viewer);
        
        % close the current fig
        if ishandle(this.handles.figure)
            delete(this.handles.figure);
        end
    end
    
    function updatePreviewImage(this)
        % update preview image of the document
        img = computePreviewImage(this);
        this.viewer.doc.previewImage = img;
        updateDisplay(this.viewer);
    end
    
    function rgb = computePreviewImage(this)
        rgb = label2rgb(this.viewer.doc.image, this.mapName, ...
            this.bgColorName, this.shuffleString);
    end
end

%% Control buttons Callback
methods
    function onButtonOK(this, varargin)        
        
        % apply the threshold operation
        res = computePreviewImage(this);
        
        gui = this.viewer.gui;
        refDoc = this.viewer.doc;
        
        % create document containing the new image
        newDoc = addImageDocument(gui, res);
        
        % add history
        string = sprintf('%s = label2rgb(%s, ''%s'', ''%s''));\n', ...
            newDoc.tag, refDoc.tag, this.mapName, this.bgColorName);
        addToHistory(gui, string);
        
        closeFigure(this);
    end
    
    function onButtonCancel(this, varargin)
        closeFigure(this);
    end
end


%% GUI Items Callback
methods
    
    function onColorMapChanged(this, varargin)
        ind = get(this.handles.colorMapCombo, 'Value');
        this.mapName = this.mapFuns{ind};
        updatePreviewImage(this);
    end

    function onBgColorChanged(this, varargin)
        ind = get(this.handles.bgColorCombo, 'Value');
        this.bgColorName = this.colorNames{ind};
        updatePreviewImage(this);
    end
    
    function onShuffleMapChanged(this, varargin)
        if get(this.handles.shuffleMapCheckbox, 'Value')
            this.shuffleString = 'shuffle';
        else
            this.shuffleString = 'noshuffle';
        end
        updatePreviewImage(this);
    end
    
end

end
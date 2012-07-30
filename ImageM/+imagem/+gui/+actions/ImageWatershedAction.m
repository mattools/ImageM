classdef ImageWatershedAction < imagem.gui.actions.ScalarImageAction
%IMAGEEXTENDEDMINIMAACTION Apply watershed to an intensity image
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
    
    conn = 4;
    connValues = [4, 8];
    
    computeWatershed = true;
    computeBasins = false;
end

methods
    function this = ImageWatershedAction(viewer)
        % calls the parent constructor
        this = this@imagem.gui.actions.ScalarImageAction(viewer, 'watershed');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;
        
        if ~isScalarImage(doc.image)
            warning('ImageM:WrongImageType', ...
                'Watershed can be applied only on scalar images');
            return;
        end
        
        createWatershedFigure(this);
        updateWidgets(this);
    end
    
    function hf = createWatershedFigure(this)
        
        % creates the figure
        hf = figure(...
            'Name', 'Image Watershed', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', ...
            'Toolbar', 'none', ...
            'CloseRequestFcn', @this.closeFigure);
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = [200 150];
        set(hf, 'Position', pos);
        
        this.handles.figure = hf;
        
        % vertical layout
        vb  = uiextras.VBox('Parent', hf, 'Spacing', 5, 'Padding', 5);
        mainPanel = uiextras.VBox('Parent', vb);
        
        gui = this.viewer.gui;
        this.handles.connectivityPopup = addComboBoxLine(gui, mainPanel, ...
            'Connectivity:', {'4', '8'}, ...
            @this.onConnectivityChanged);

        this.handles.resultTypePopup = addComboBoxLine(gui, mainPanel, ...
            'ResultType:', {'Watershed', 'Basins', 'Both'}, ...
            @this.onResultTypeChanged);
        
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
    
    function updateWidgets(this)
        
        % update preview image of the document
        bin = computeWatershedImage(this) == 0;
        doc = this.viewer.doc;
        doc.previewImage = overlay(doc.image, bin);
        updateDisplay(this.viewer);
    end
    
end

%% Control buttons Callback
methods
    function onButtonOK(this, varargin)        
        % apply the threshold operation
        wat = computeWatershedImage(this);
        if this.computeWatershed
            newDoc = addImageDocument(this.viewer.gui, wat == 0);
        end
        if this.computeBasins
            newDoc = addImageDocument(this.viewer.gui, uint16(wat));
        end
        
        % add history
        string = sprintf('%s = watershed(%s, %d);\n', ...
            newDoc.tag, this.viewer.doc.tag, this.conn);
        addToHistory(this.viewer.gui, string);

        closeFigure(this);
    end
    
    function onButtonCancel(this, varargin)
        closeFigure(this);
    end
end


%% GUI Items Callback
methods
    function onConnectivityChanged(this, varargin)
        index = get(this.handles.connectivityPopup, 'Value');
        this.conn = this.connValues(index);
        
        updateWidgets(this);
    end
    
    function onResultTypeChanged(this, varargin)
        type = get(this.handles.resultTypePopup, 'Value');
        switch type
            case 1
                this.computeWatershed = true;
                this.computeBasins = false;
            case 2
                this.computeWatershed = false;
                this.computeBasins = true;
            case 3
                this.computeWatershed = true;
                this.computeBasins = true;
        end
    end
    
    function wat = computeWatershedImage(this)
        wat = watershed(this.viewer.doc.image, this.conn);
    end
end

end
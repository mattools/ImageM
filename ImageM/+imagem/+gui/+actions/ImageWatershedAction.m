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
    function this = ImageWatershedAction(parent)
        % calls the parent constructor
        this = this@imagem.gui.actions.ScalarImageAction(parent, 'watershed');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('apply watershed to current image');
        
        % get handle to parent figure, and current doc
        viewer = this.parent;
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
        
        % background color of most widgets
        bgColor = getWidgetBackgroundColor(this.parent.gui);
        
        % vertical layout
        vb  = uiextras.VBox('Parent', hf, 'Spacing', 5, 'Padding', 5);
        mainPanel = uiextras.VBox('Parent', vb);
        
        line1 = uiextras.HBox('Parent', mainPanel, ...
            'Spacing', 5, 'Padding', 5);
        
        % popup to choose the connectivity
        uicontrol('Style', 'Text', ...
            'Parent', line1, ...
            'String', 'Connectivity:', ...
            'FontWeight', 'Bold', ...
            'FontSize', 10, ...
            'HorizontalAlignment', 'Right');
        this.handles.connectivityPopup = uicontrol(...
            'Style', 'PopupMenu', ...
            'Parent', line1, ...
            'String', {'4', '8'}, ...
            'BackgroundColor', bgColor, ...
            'Value', 1, ...
            'Callback', @this.onConnectivityChanged);
        set(line1, 'Sizes', [-1 -1]);

        % popup to decide the kind of result to display
        line2 = uiextras.HBox('Parent', mainPanel, ...
            'Spacing', 5, 'Padding', 5);        
        uicontrol('Style', 'Text', ...
            'Parent', line2, ...
            'String', 'ResultType:', ...
            'FontWeight', 'Bold', ...
            'FontSize', 10, ...
            'HorizontalAlignment', 'Right');
        this.handles.resultTypePopup = uicontrol(...
            'Style', 'PopupMenu', ...
            'Parent', line2, ...
            'String', {'Watershed', 'Basins', 'Both'}, ...
            'BackgroundColor', bgColor, ...
            'Value', 1, ...
            'Callback', @this.onResultTypeChanged);
        set(line2, 'Sizes', [-1 -1]);
            
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
        % clean up parent figure
        this.parent.doc.previewImage = [];
        updateDisplay(this.parent);
        
        % close the current fig
        if ishandle(this.handles.figure)
            delete(this.handles.figure);
        end
    end
    
    function updateWidgets(this)
        
        % update preview image of the document
        bin = computeWatershedImage(this) == 0;
        doc = this.parent.doc;
        doc.previewImage = overlay(doc.image, bin);
        updateDisplay(this.parent);
    end
    
end

%% Control buttons Callback
methods
    function onButtonOK(this, varargin)        
        % apply the threshold operation
        wat = computeWatershedImage(this);
        if this.computeWatershed
            addImageDocument(this.parent.gui, wat == 0);
        end
        if this.computeBasins
            addImageDocument(this.parent.gui, uint16(wat));
        end
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
        wat = watershed(this.parent.doc.image, this.conn);
    end
end

end
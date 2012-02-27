classdef ImageWatershedAction < imagem.gui.ImagemAction
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
        this = this@imagem.gui.ImagemAction(parent, 'watershed');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('apply Watershed to current image');
        
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
        
        % action figure
        hf = figure(...
            'Name', 'Image Threshold', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', 'Toolbar', 'none');
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = 200;
        set(hf, 'Position', pos);
        
        this.handles.figure = hf;
        
        
        % compute background color of most widgets
        if ispc
            bgColor = 'White';
        else
            bgColor = get(0,'defaultUicontrolBackgroundColor');
        end
        
        % vertical layout
        vb  = uiextras.VBox('Parent', hf, 'Spacing', 5, 'Padding', 5);
        mainPanel = uiextras.VBox('Parent', vb);
        
        % popup to choose the connectivity
        uicontrol(...
            'Style', 'Text', ...
            'Parent', mainPanel, ...
            'String', 'Connectivity:');
        this.handles.connectivityPopup = uicontrol(...
            'Style', 'PopupMenu', ...
            'Parent', mainPanel, ...
            'String', {'4', '8'}, ...
            'BackgroundColor', bgColor, ...
            'Value', 1, ...
            'Callback', @this.onConnectivityChanged);

        % popup to decide the kind of result to display
        uicontrol(...
            'Style', 'Text', ...
            'Parent', mainPanel, ...
            'String', 'Result Type:');
        this.handles.resultTypePopup = uicontrol(...
            'Style', 'PopupMenu', ...
            'Parent', mainPanel, ...
            'String', {'Watershed', 'Basins', 'Both'}, ...
            'BackgroundColor', bgColor, ...
            'Value', 1, ...
            'Callback', @this.onResultTypeChanged);
            
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
        
    function closeFigure(this)
        % clean up parent figure
        this.parent.doc.previewImage = [];
        updateDisplay(this.parent);
        
        % close the current fig
        close(this.handles.figure);
    end
    
    function updateWidgets(this)
        
        % update preview image of the document
        bin = computeWatershedImage(this) == 0;
        doc = this.parent.doc;
        doc.previewImage = overlay(doc.image, bin);
        updateDisplay(this.parent);
    end
    
end

%% GUI Items Callback
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

methods
    function b = isActivable(this)
        doc = this.parent.doc;
        b = ~isempty(doc.image) && isScalarImage(doc.image);
    end
end

end
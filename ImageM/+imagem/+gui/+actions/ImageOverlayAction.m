classdef ImageOverlayAction < imagem.gui.ImagemAction
%IMAGEOVERLAYACTION  One-line description here, please.
%
%   Class ImageOverlayAction
%
%   Example
%   ImageOverlayAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-15,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    handles;
end % end properties


%% Constructor
methods
    function this = ImageOverlayAction(viewer)
    % Constructor for ImageOverlayAction class
        this = this@imagem.gui.ImagemAction(viewer, 'imageOverlay');
    end

end % end constructors

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        createFigure(this);
    end
    
    function hf = createFigure(this)
        
        % action figure
        hf = figure(...
            'Name', 'Binary overlay', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', 'Toolbar', 'none');
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = 200;
        set(hf, 'Position', pos);
        
        this.handles.figure = hf;
        
        imageNames = getImageNames(this.viewer.gui.app);
        colorNames = {'Red', 'Green', 'Blue', 'Yellow', 'Magenta', 'Cyan'};
        
        % compute background color of most widgets
        if ispc
            bgColor = 'White';
        else
            bgColor = get(0,'defaultUicontrolBackgroundColor');
        end
        
        % vertical layout
        vb  = uix.VBox('Parent', hf, ...
            'Spacing', 5, 'Padding', 5);
        
        % one panel for value text input
        mainPanel = uix.VBox('Parent', vb);
        uicontrol(...
            'Style', 'Text', ...
            'Parent', mainPanel, ...
            'HorizontalAlignment', 'left', ...
            'String', 'Reference image:');

        this.handles.imageList1 = uicontrol(...
            'Style', 'popupmenu', ...
            'Parent', mainPanel, ...
            'BackgroundColor', bgColor, ...
            'String', imageNames);

        uicontrol(...
            'Style', 'Text', ...
            'Parent', mainPanel, ...
            'HorizontalAlignment', 'left', ...
            'String', 'Overlay image:');

        this.handles.imageList2 = uicontrol(...
            'Style', 'popupmenu', ...
            'Parent', mainPanel, ...
            'BackgroundColor', bgColor, ...
            'String', imageNames);

        uicontrol(...
            'Style', 'Text', ...
            'Parent', mainPanel, ...
            'HorizontalAlignment', 'left', ...
            'String', 'Overlay Color:');

        this.handles.colorList = uicontrol(...
            'Style', 'popupmenu', ...
            'Parent', mainPanel, ...
            'BackgroundColor', bgColor, ...
            'String', colorNames);


        % button for control panel
        buttonsPanel = uix.HButtonBox( 'Parent', vb, 'Padding', 5);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'OK', ...
            'Callback', @this.onButtonOK);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'Cancel', ...
            'Callback', @this.onButtonCancel);
        
        set(vb, 'Heights', [-1 40] );
    end

    function closeFigure(this)
        % clean up viewer figure
        
        % close the current fig
        delete(this.handles.figure);
    end
    
end

%% GUI Items Callback
methods
    function onButtonOK(this, varargin)        
        
        gui = this.viewer.gui;
        
        refDoc = getDocument(gui.app, get(this.handles.imageList1, 'Value'));
        refImg = refDoc.image;

        binDoc = getDocument(gui.app, get(this.handles.imageList2, 'Value'));
        binImg = binDoc.image;
        
        % check inputs
        if ~isBinaryImage(binImg)
            error('Overlay Image must be binary');
        end
        if ndims(refImg) ~= ndims(binImg)
            error('Input images must have same dimension');
        end
        if any(size(refImg) ~= size(binImg))
            error('Input images must have same size');
        end
        
        colors = [1 0 0;0 1 0;0 0 1;1 1 0;1 0 1;0 1 1];
        colorCodes = {'r', 'g', 'b', 'y', 'm', 'c'};
        
        indColor = get(this.handles.colorList, 'Value');
        color = colors(indColor, :);
        
        ovr = overlay(refImg, binImg, color);
        
        % add image to application, and create new display
        newDoc = addImageDocument(gui, ovr, [], 'ovr');
        
        % add history
        string = sprintf('%s = overlay(%s, %s, ''%c'');\n', ...
            newDoc.tag, refDoc.tag, binDoc.tag, colorCodes{indColor});
        addToHistory(this.viewer.gui.app, string);

        closeFigure(this);
    end
    
    function onButtonCancel(this, varargin)
        closeFigure(this);
    end
    
end

end % end classdef


classdef ImageOverlayAction < imagem.gui.ImagemAction
% Apply binary overlay over current image.
%
%   Class ImageOverlayAction
%
%   Example
%   ImageOverlayAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-15,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    Handles;
end % end properties


%% Constructor
methods
    function obj = ImageOverlayAction(viewer)
    % Constructor for ImageOverlayAction class
        obj = obj@imagem.gui.ImagemAction(viewer, 'imageOverlay');
    end

end % end constructors

methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        createFigure(obj);
    end
    
    function hf = createFigure(obj)
        
        % action figure
        hf = figure(...
            'Name', 'Binary overlay', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', 'Toolbar', 'none');
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = 200;
        set(hf, 'Position', pos);
        
        obj.Handles.Figure = hf;
        
        imageNames = getImageNames(obj.Viewer.Gui.App);
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

        obj.Handles.ImageList1 = uicontrol(...
            'Style', 'popupmenu', ...
            'Parent', mainPanel, ...
            'BackgroundColor', bgColor, ...
            'String', imageNames);

        uicontrol(...
            'Style', 'Text', ...
            'Parent', mainPanel, ...
            'HorizontalAlignment', 'left', ...
            'String', 'Overlay image:');

        obj.Handles.ImageList2 = uicontrol(...
            'Style', 'popupmenu', ...
            'Parent', mainPanel, ...
            'BackgroundColor', bgColor, ...
            'String', imageNames);

        uicontrol(...
            'Style', 'Text', ...
            'Parent', mainPanel, ...
            'HorizontalAlignment', 'left', ...
            'String', 'Overlay Color:');

        obj.Handles.ColorList = uicontrol(...
            'Style', 'popupmenu', ...
            'Parent', mainPanel, ...
            'BackgroundColor', bgColor, ...
            'String', colorNames);


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

    function closeFigure(obj)
        % clean up viewer figure
        
        % close the current fig
        delete(obj.Handles.Figure);
    end
    
end

%% GUI Items Callback
methods
    function onButtonOK(obj, varargin)        
        
        gui = obj.Viewer.Gui;
        
        refDoc = getDocument(gui.App, get(obj.Handles.ImageList1, 'Value'));
        refImg = refDoc.Image;

        binDoc = getDocument(gui.App, get(obj.Handles.ImageList2, 'Value'));
        binImg = binDoc.Image;
        
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
        
        indColor = get(obj.Handles.ColorList, 'Value');
        color = colors(indColor, :);
        
        ovr = overlay(refImg, binImg, color);
        
        % add image to application, and create new display
        newDoc = addImageDocument(gui, ovr, [], 'ovr');
        
        % add history
        string = sprintf('%s = overlay(%s, %s, ''%c'');\n', ...
            newDoc.Tag, refDoc.Tag, binDoc.Tag, colorCodes{indColor});
        addToHistory(obj, string);

        closeFigure(obj);
    end
    
    function onButtonCancel(obj, varargin)
        closeFigure(obj);
    end
    
end

end % end classdef


classdef ImageMorphologicalReconstruction < imagem.actions.CurrentImageAction
% Open a dialog to compute morphological reconstruction on an image.
%
%   Class ImageMorphologicalReconstruction
%
%   Example
%   ImageMorphologicalReconstruction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-11-25,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.


%% Properties
properties
    Handles;
    Viewer;
end % end properties


%% Constructor
methods
    function obj = ImageMorphologicalReconstruction(varargin)
        % Constructor for ImageMorphologicalReconstruction class.

    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSD>
        disp('morphological reconstruction');
        
        obj.Viewer = frame;
        createFigure(obj);
    end

    function hf = createFigure(obj)
        
        % action figure
        hf = figure(...
            'Name', 'Morphological Reconstruction', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', 'Toolbar', 'none');
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = 200;
        set(hf, 'Position', pos);
        
        obj.Handles.Figure = hf;
        
        imageNames = getImageNames(obj.Viewer.Gui.App);
        
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
            'String', 'Marker image:');

        obj.Handles.ImageList1 = uicontrol(...
            'Style', 'popupmenu', ...
            'Parent', mainPanel, ...
            'BackgroundColor', bgColor, ...
            'String', imageNames);

        uicontrol(...
            'Style', 'Text', ...
            'Parent', mainPanel, ...
            'HorizontalAlignment', 'left', ...
            'String', 'Mask image:');

        obj.Handles.ImageList2 = uicontrol(...
            'Style', 'popupmenu', ...
            'Parent', mainPanel, ...
            'BackgroundColor', bgColor, ...
            'String', imageNames);

        uicontrol(...
            'Style', 'Text', ...
            'Parent', mainPanel, ...
            'HorizontalAlignment', 'left', ...
            'String', 'Connectivity:');

        obj.Handles.ConnectivityPopup = uicontrol(...
            'Style', 'popupmenu', ...
            'Parent', mainPanel, ...
            'BackgroundColor', bgColor, ...
            'String', {'4', '8'});

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
        close(obj.Handles.Figure);
    end
    
end % end methods

%% GUI Items Callback
methods
    function onButtonOK(obj, varargin)
        
        app = obj.Viewer.Gui.App;
        
        markerDoc = getDocument(app, get(obj.Handles.ImageList1, 'Value'));
        markerImg = markerDoc.Image;
        
        maskDoc = getDocument(app, get(obj.Handles.ImageList2, 'Value'));
        maskImg = maskDoc.Image;
        
        % check inputs
        if ~isScalarImage(maskImg)
            error('Mask image must be scalar');
        end
        if ndims(markerImg) ~= ndims(maskImg)
            error('Input images must have same dimension');
        end
        if any(size(markerImg) ~= size(maskImg))
            error('Input images must have same size');
        end
        
        switch get(obj.Handles.ConnectivityPopup, 'Value')
            case 1
                conn = 4;
            case 2
                conn = 8;
        end
        
        % compute result image
        imp = reconstruction(markerImg, maskImg, conn);
        
        % add image to application, and create new display
        newDoc = addImageDocument(obj.Viewer, imp);
        
        % add history
        string = sprintf('%s = reconstruction(%s, %s, %d));\n', ...
            newDoc.Tag, markerDoc.Tag, maskDoc.Tag, conn);
        addToHistory(obj.Viewer, string);
        
        closeFigure(obj);
    end
    
    function onButtonCancel(obj, varargin)
        closeFigure(obj);
    end
    
end

end % end classdef


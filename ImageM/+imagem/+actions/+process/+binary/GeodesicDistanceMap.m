classdef GeodesicDistanceMap < imagem.actions.CurrentImageAction
% Propagates distance map from marker contrained to a binary mask.
%
%   Class ImageImposeMinimaAction
%
%   Example
%   ImageImposeMinimaAction
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
    Viewer;
end % end properties


%% Constructor
methods
    function obj = GeodesicDistanceMap()
    end

end % end constructors

methods
    function run(obj, frame) %#ok<INUSD>
        disp('geodesic distance map');
        
        obj.Viewer = frame;
        createFigure(obj);
    end
    
    function hf = createFigure(obj)
        
        % action figure
        hf = figure(...
            'Name', 'Impose Minima', ...
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
            'String', 'Weights:');

        obj.Handles.WeightsPopup = uicontrol(...
            'Style', 'popupmenu', ...
            'Parent', mainPanel, ...
            'BackgroundColor', bgColor, ...
            'String', {'[1 0]', '[1 1]', '[3 4]', '[5 7 11]'}, ...
            'Value', 4);

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
    
end

%% GUI Items Callback
methods
    function onButtonOK(obj, varargin)        
        
        app = obj.Viewer.Gui.App;
        
        markerDoc = getDocument(app, get(obj.Handles.ImageList1, 'Value'));
        markerImg = markerDoc.Image;

        maskDoc = getDocument(app, get(obj.Handles.ImageList2, 'Value'));
        maskImg = maskDoc.Image;
        
        % check inputs
        if ~isBinaryImage(markerImg)
            error('Marker Image must be binary');
        end
        if ~isBinaryImage(maskImg)
            error('Mask Image must be binary');
        end
        if ndims(markerImg) ~= ndims(maskImg)
            error('Input images must have same dimension');
        end
        if any(size(markerImg) ~= size(maskImg))
            error('Input images must have same size');
        end
        
        switch get(obj.Handles.WeightsPopup, 'Value')
            case 1
                weights = [1 0];
            case 2
                weights = [1 1];
            case 3
                weights = [3 4];
            case 4
                weights = [5 7 11];
        end
        
        % compute result image
        dist = geodesicDistanceMap(markerImg, maskImg, weights);
        
        % add image to application, and create new display
        newDoc = addImageDocument(obj.Viewer, dist);
        
        % add history
        pattern = ['[%d' repmat(' %d', 1, length(weights)-1) ']'];
        string = sprintf('%s = geodesicDistanceMap(%s, %s, %s));\n', ...
            newDoc.Tag, markerDoc.Tag, maskDoc.Tag, sprintf(pattern, weights));
        addToHistory(obj.Viewer, string);

        closeFigure(obj);
    end
    
    function onButtonCancel(obj, varargin)
        closeFigure(obj);
    end
    
end

end % end classdef


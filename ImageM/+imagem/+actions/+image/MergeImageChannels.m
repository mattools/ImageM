classdef MergeImageChannels < imagem.gui.Action
% Merge three grayscale images to create a color image.
%
%   Class MergeImageChannels
%
%   Example
%   MergeImageChannels
%
%   See also
%     SplitImageChannels

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-11-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    Handles;
    
    Frame;
        
end % end properties


%% Constructor
methods
    function obj = MergeImageChannels()
    end

end % end constructors

methods
    function run(obj, frame) %#ok<INUSD>
        disp('merge channels');
        
        obj.Frame = frame;
        createFigure(obj, frame);
    end
    
    function hf = createFigure(obj, refFrame)
        
        gui = refFrame.Gui;
        
        % action figure
        hf = figure(...
            'Name', 'Merge Channels', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', 'Toolbar', 'none');
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = 200;
        set(hf, 'Position', pos);
        
        obj.Handles.Figure = hf;
        
        imageNames = getImageNames(gui.App);
        
        % vertical layout
        vb  = uix.VBox('Parent', hf, ...
            'Spacing', 5, 'Padding', 5);
        
        % one panel for value text input
        mainPanel = uix.VBox('Parent', vb);

        % combo box for the first image
        obj.Handles.RedChannelList = addComboBoxLine(gui, mainPanel, ...
            'Red Channel:', imageNames);
        
        % combo box for the first image
        obj.Handles.GreenChannelList = addComboBoxLine(gui, mainPanel, ...
            'Green Channel:', imageNames);
        
        % combo box for the first image
        obj.Handles.BlueChannelList = addComboBoxLine(gui, mainPanel, ...
            'Blue Channel:', imageNames);
        
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
        
        app = obj.Frame.Gui.App;
        
        doc1 = getDocument(app, get(obj.Handles.RedChannelList, 'Value'));
        img1 = doc1.Image;

        doc2 = getDocument(app, get(obj.Handles.GreenChannelList, 'Value'));
        img2 = doc2.Image;
        
        doc3 = getDocument(app, get(obj.Handles.BlueChannelList, 'Value'));
        img3 = doc3.Image;
        
       
        % TODO: should manage case of empty image
        if ndims(img1) ~= ndims(img2) || ndims(img1) ~= ndims(img3)
            error('Input images must have same dimension');
        end
        if any(size(img1) ~= size(img2)) || any(size(img1) ~= size(img3))
            error('Input images must have same size');
        end
        
        
        % compute result image
        res = Image.createRGB(img1, img2, img3);
        
        % add image to application, and create new display
        newDoc = addImageDocument(obj.Frame, res);
        
        % add history
        string = sprintf('%s = Image.createRGB(%s, %s, %s));\n', ...
            newDoc.Tag, doc1.Tag, doc2.Tag, doc3.Tag);
        addToHistory(obj.Frame, string);

        closeFigure(obj);
    end
    
    function onButtonCancel(obj, varargin)
        closeFigure(obj);
    end
    
end

end % end classdef


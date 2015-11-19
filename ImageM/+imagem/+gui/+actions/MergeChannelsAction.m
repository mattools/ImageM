classdef MergeChannelsAction < imagem.gui.ImagemAction
%MERGECHANNELSACTION Merge three images to create a color one
%
%   Class ImageArithmeticAction
%
%   Example
%   ImageArithmeticAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2012-11-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    handles;
    
    opList = {@plus, @minus, @times, @rdivide};
    opNames = {'Plus', 'Minus', 'Times', 'Divides'};
    
end % end properties


%% Constructor
methods
    function this = MergeChannelsAction(viewer)
    % Constructor for MergeChannelsAction class
        this = this@imagem.gui.ImagemAction(viewer, 'mergeChannels');
    end

end % end constructors

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('merge channels');
        
        createFigure(this);
    end
    
    function hf = createFigure(this)
        
        % action figure
        hf = figure(...
            'Name', 'Image Arithmetic', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', 'Toolbar', 'none');
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = 200;
        set(hf, 'Position', pos);
        
        this.handles.figure = hf;
        
        imageNames = getImageNames(this.viewer.gui.app);
        
        % vertical layout
        vb  = uiextras.VBox('Parent', hf, ...
            'Spacing', 5, 'Padding', 5);
        
        gui = this.viewer.gui;
        
        % one panel for value text input
        mainPanel = uiextras.VBox('Parent', vb);

        % combo box for the first image
        this.handles.redChannelList = addComboBoxLine(gui, mainPanel, ...
            'Red Channel:', imageNames);
        
        % combo box for the first image
        this.handles.greenChannelList = addComboBoxLine(gui, mainPanel, ...
            'Green Channel:', imageNames);
        
        % combo box for the first image
        this.handles.blueChannelList = addComboBoxLine(gui, mainPanel, ...
            'Blue Channel:', imageNames);
        
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
        close(this.handles.figure);
    end
    
end

%% GUI Items Callback
methods
    function onButtonOK(this, varargin)        
        
        gui = this.viewer.gui;
        
        doc1 = getDocument(gui.app, get(this.handles.redChannelList, 'Value'));
        img1 = doc1.image;

        doc2 = getDocument(gui.app, get(this.handles.greenChannelList, 'Value'));
        img2 = doc2.image;
        
        doc3 = getDocument(gui.app, get(this.handles.blueChannelList, 'Value'));
        img3 = doc3.image;
        
       
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
        newDoc = addImageDocument(gui, res);
        
        % add history
        string = sprintf('%s = Image.createRGB(%s, %s, %s));\n', ...
            newDoc.tag, doc1.tag, doc2.tag, doc3.tag);
        addToHistory(gui.app, string);

        closeFigure(this);
    end
    
    function onButtonCancel(this, varargin)
        closeFigure(this);
    end
    
end

end % end classdef


classdef ImageMathematicAction < imagem.gui.actions.ScalarImageAction
%IMAGEOVERLAYACTION Open a dialog to compute imposed minima
%
%   Class ImageMathematicAction
%
%   Example
%   ImageMathematicAction
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
    
    opList = {@plus, @minus, @times, @rdivide, @power};
    opNames = {'Plus', 'Minus', 'Times', 'Divides', 'power'};
    
end % end properties


%% Constructor
methods
    function this = ImageMathematicAction(viewer)
    % Constructor for ImageMathematicAction class
        this = this@imagem.gui.actions.ScalarImageAction(viewer, 'imageMathematic');
    end

end % end constructors

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('image mathematic');
        
        createFigure(this);
    end
    
    function hf = createFigure(this)
        
        % action figure
        hf = figure(...
            'Name', 'Image Mathematic', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', 'Toolbar', 'none');
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = 200;
        set(hf, 'Position', pos);
        
        this.handles.figure = hf;
        
        % vertical layout
        vb  = uiextras.VBox('Parent', hf, ...
            'Spacing', 5, 'Padding', 5);
        
        gui = this.viewer.gui;
        
        % one panel for value text input
        mainPanel = uiextras.VBox('Parent', vb);

        % combo box for the operation name
        this.handles.operationList = addComboBoxLine(gui, mainPanel, ...
            'Operation:', this.opNames);
        
        % combo box for the second image
        this.handles.operandInput = addInputTextLine(gui, mainPanel, ...
            'Value', '10');
        
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
        % clean up viewer figure
        
        % close the current fig
        close(this.handles.figure);
    end
    
end

%% GUI Items Callback
methods
    function onButtonOK(this, varargin)        
        
        gui = this.viewer.gui;
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        refDoc = viewer.doc;
        img = viewer.doc.image;
        
        % get operation as function handle
        opIndex = get(this.handles.operationList, 'Value');
        op = this.opList{opIndex};
        opName = char(op);
        
        strValue = get(this.handles.operandInput, 'String');
        value = str2double(strValue);
        if isnan(value)
            error(['Could not parse input value: ' strValue]);
        end
        
        % compute result image
        res = op(img, value);
        
        % add image to application, and create new display
        newDoc = addImageDocument(gui, res);
        
        % add history
        string = sprintf('%s = %s(%s, %s));\n', ...
            newDoc.tag, opName, refDoc.tag, strValue);
        addToHistory(gui.app, string);

        closeFigure(this);
    end
    
    function onButtonCancel(this, varargin)
        closeFigure(this);
    end
    
end

end % end classdef


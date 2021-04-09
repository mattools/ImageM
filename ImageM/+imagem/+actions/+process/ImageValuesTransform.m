classdef ImageValuesTransform < imagem.actions.ScalarImageAction
% Apply a transform to values of image.
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
% e-mail: david.legland@inra.fr
% Created: 2012-11-04,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    Handles;
    Viewer;
    
    % the list of math operation to apply, as function handles
    OpList = {@log, @exp, @sqrt, @sin, @cos, @tan, @round, @floor, @ceil};
    
    % the list of math operation names, to populate widgets
    OpNames = {'log', 'exp', 'sqrt', 'sin', 'cos', 'tan', 'round', 'floor', 'ceil'};
    
end % end properties


%% Constructor
methods
    function obj = ImageValuesTransform()
    end

end % end constructors

methods
    function run(obj, frame) %#ok<INUSD>
        disp('image values transform');

        obj.Viewer = frame;
        createFigure(obj);
    end
    
    function hf = createFigure(obj)
        
        % action figure
        hf = figure(...
            'Name', 'Image Values Tansform', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', 'Toolbar', 'none');
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = [200 160];
        set(hf, 'Position', pos);
        
        obj.Handles.Figure = hf;
        
        % vertical layout
        vb  = uiextras.VBox('Parent', hf, ...
            'Spacing', 5, 'Padding', 5);
        
        gui = obj.Viewer.Gui;
        
        % one panel for value text input
        mainPanel = uix.VBox('Parent', vb);

        % combo box for the operation name
        obj.Handles.OperationList = addComboBoxLine(gui, mainPanel, ...
            'Operation:', obj.OpNames);
        
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
        
        % get handle to current doc
        doc = currentDoc(obj.Viewer);
        
        % get operation as function handle
        opIndex = get(obj.Handles.OperationList, 'Value');
        op = obj.OpList{opIndex};
        opName = char(op);
        
        % compute result data
        data2 = op(doc.Image.Data);
        
        % compute result image
        res = Image('Data', data2, 'Parent', doc.Image);
        
        % add image to application, and create new display
        newDoc = addImageDocument(obj.Viewer, res);
        
        % add history
        string = sprintf('%s = Image(''Data'', %s(%s.Data), ''Parent'', %s);\n', ...
            newDoc.Tag, opName, doc.Tag, doc.Tag);
        addToHistory(obj.Viewer, string);

        closeFigure(obj);
    end
    
    function onButtonCancel(obj, varargin)
        closeFigure(obj);
    end
    
end

end % end classdef


classdef ImageMorphologicalFilter < imagem.actions.CurrentImageAction
% Apply morphological filtering on current image.
%
%   Class ImageMorphologicalFilter
%
%   Example
%   ImageMorphologicalFilter
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    OperationList = {'Dilation', 'Erosion', 'Closing', 'Opening', 'Gradient', 'Black Top Hat', 'White Top Hat'};
    CommandList = {'dilation', 'erosion', 'closing', 'opening', 'morphoGradient', 'blackTopHat', 'whiteTopHat'};
    
    ShapeList = {'Square', 'Diamond', 'Octogon', 'Disk', 'Horizontal Line', 'Vertical Line', 'Line 45°', 'Line 135°'};
    ShapeList3d = {'Cube', 'Ball', 'Line X', 'Line Y', 'Line Z'};
    
    OperationMethodName = '';
    MakeStrelCmd = '';
    
    PreviewImage = [];
    NeedUpdate = true;
    
    Handles;
    Viewer;
end

%% Constructor
methods
    function obj = ImageMorphologicalFilter()
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSD>
        
        % keep handle to viewer frame
        obj.Viewer = frame;
        
        % select options depending on image dimension
        img = currentImage(obj.Viewer);
        nd = ndims(img);
        if nd == 2
            shapeList = obj.ShapeList;
        elseif nd == 3
            shapeList = obj.ShapeList3d;
        end

        % creates a new dialog, and populates it with some fields
        gd = imagem.gui.GenericDialog('Morphological Filter');
        obj.Handles.Dialog = gd;
        
        % add a combo box for the type of operation to perform
        hOperation = addChoice(gd, 'Operation: ', obj.OperationList, ...
            obj.OperationList{1});
        set(hOperation, 'CallBack', @obj.onWidgetUpdated);
        obj.Handles.OperationPopup = hOperation;

        % add a combo box for the shape of structuring element
        hShape = addChoice(gd, 'Shape: ', shapeList, shapeList{1});
        set(hShape, 'CallBack', @obj.onWidgetUpdated);
        obj.Handles.ShapePopup = hShape;
        
        % add a numeric field for the size of structuring element
        hRadius = addNumericField(gd, 'Radius: ', 3, 0);
        set(hRadius, 'CallBack', @obj.onWidgetUpdated);
        set(hRadius, 'KeyPressFcn', @obj.onWidgetUpdated);
        obj.Handles.RadiusTextField = hRadius;
        addMessage(gd, 'Diameter is Radius*2 + 1');

        % add a preview checkbox
        hPreview = addCheckBox(gd, 'Preview', false);
        set(hPreview, 'CallBack', @obj.onPreviewCheckBoxChanged);
        obj.Handles.PreviewCheckBox = hPreview;
        
        % displays the dialog, and waits for user response
        showDialog(gd);
        
        % clear preview of original viewer
        clearPreviewImage(obj.Viewer);
        
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end

        % compute result image
        img2 = recomputePreviewImage(obj);
        
        if isempty(img2)
            return;
        end
        
        % add image to application, and create new display
        [frame2, doc2] = createImageFrame(obj.Viewer, img2); %#ok<ASGLU>
%         addImageDocument(obj.Viewer, img2);
        
        % add history
        addToHistory(obj.Viewer.Gui.App, obj.MakeStrelCmd);
        string = sprintf('%s = %s(%s, se);\n', ...
            doc2.Tag, obj.OperationMethodName, frame.Doc.Tag);
        addToHistory(obj.Viewer.Gui.App, string);
    end
    
    function onWidgetUpdated(obj, varargin)
        % update preview image of the document
        
        obj.NeedUpdate = true;
        
        hPreview = obj.Handles.PreviewCheckBox;
        if get(hPreview, 'Value') == get(hPreview, 'Max')
            preview = recomputePreviewImage(obj);
            updatePreviewImage(obj.Viewer, preview);
        end

    end
    
    function onPreviewCheckBoxChanged(obj, src, event) %#ok<INUSD>
        hPreview = obj.Handles.PreviewCheckBox;
        if get(hPreview, 'Value') == get(hPreview, 'Max')
            if obj.NeedUpdate
                updatePreviewImage(obj.Viewer, recomputePreviewImage(obj));
            end
        else
            clearPreviewImage(obj.Viewer);
        end
    end 
    
    function img2 = recomputePreviewImage(obj)
        % update preview image from dialog options, and toggle update flag
        
        
        % get dialog options
        gd = obj.Handles.Dialog;
        opIndex = getNextChoiceIndex(gd);
        shapeIndex = getNextChoiceIndex(gd);
        radius = getNextNumber(gd);
        if isnan(radius)
            img2 = [];
            return;
        end
        resetCounter(obj.Handles.Dialog);
        
        img = currentImage(obj.Viewer);
        nd = ndims(img);

        if nd == 2
            strelShape = obj.ShapeList{shapeIndex};
            [se, cmd] = createStrel(strelShape, radius);  %#ok<ASGLU>
        else
            strelShape = obj.ShapeList3d{shapeIndex};
            [se, cmd] = createStrel3d(strelShape, radius); %#ok<ASGLU>
        end
        obj.MakeStrelCmd = cmd;
        
        % apply filtering operation
        obj.OperationMethodName = obj.CommandList{opIndex};
        img2 = eval(sprintf('%s(img, se)', obj.OperationMethodName));
        obj.PreviewImage = img2;
        
        % reset state of update
        obj.NeedUpdate = false;
    end
    
end % end methods

end % end classdef

function [se, cmd] = createStrel(strelShape, strelRadius)

diam = 2 * strelRadius + 1;
switch strelShape
    case 'Square'
        se = strel('square', diam);
        cmd = sprintf('se = strel(''square'', %d);\n', diam);
    case 'Diamond'
        se = strel('diamond', strelRadius);
        cmd = sprintf('se = strel(''diamond'', %d);\n', strelRadius);
    case 'Octogon'
        size = round(strelRadius / 3) * 3;
        se = strel('octagon', size);
        cmd = sprintf('se = strel(''octagon'', %d);\n', size);
    case 'Disk'
        se = strel('disk', strelRadius);
        cmd = sprintf('se = strel(''disk'', %d);\n', strelRadius);
    case 'Horizontal Line'
        se = strel('line', diam, 0);
        cmd = sprintf('se = strel(''line'', %d, %d);\n', diam, 0);
    case 'Vertical Line'
        se = strel('line', diam, 90);
        cmd = sprintf('se = strel(''line'', %d, %d);\n', diam, 90);
    case 'Line 45°' 
        se = strel('line', diam, 45);
        cmd = sprintf('se = strel(''line'', %d, %d);\n', diam, 45);
    case 'Line 135°'
        se = strel('line', diam, 135);
        cmd = sprintf('se = strel(''line'', %d, %d);\n', diam, 135);
    otherwise
        error(['Unknown strel shape: ' strelShape]);
end
end


function [se, cmd] = createStrel3d(strelShape, strelRadius)

diam = 2 * strelRadius + 1;
switch strelShape
    case 'Cube'
        se = strel('cube', diam);
        cmd = sprintf('se = strel(''cube'', %d);\n', diam);
    case 'Ball'
        se = strel('sphere', strelRadius);
        cmd = sprintf('se = strel(''sphere'', %d);\n', strelRadius);
    case 'Line X'
        se = strel('arbitrary', ones([1 diam 1]));
        cmd = sprintf('se = strel(''arbitrary'', [1 %d 1]);\n', diam);
    case 'Line Y'
        se = strel('arbitrary', ones([diam 1 1]));
        cmd = sprintf('se = strel(''arbitrary'', [%d 1 1]);\n', diam);
    case 'Line Z'
        se = strel('arbitrary', ones([1 1 diam]));
        cmd = sprintf('se = strel(''arbitrary'', [1 1 %d]);\n', diam);
    otherwise
        error(['Unknown strel shape: ' strelShape]);
end
end

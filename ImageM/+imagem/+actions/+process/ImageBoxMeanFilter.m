classdef ImageBoxMeanFilter < imagem.actions.CurrentImageAction
% Apply a simple box-mean filter on current image.
%
%   Class ImageBoxMeanFilterAction
%
%   Example
%   ImageBoxMeanFilterAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2016-01-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    PreviewImage = [];
    NeedUpdate = true;
    
    % list of handles on the dialog widgets
    Handles;
    Viewer;
end


%% Constructor
methods
    function obj = ImageBoxMeanFilter()
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSD>
        
        % get handle to current doc
        doc = currentDoc(frame);
        obj.Viewer = frame;
        
        % number of spatial dimensions of current image
        img = doc.Image;
        nd = ndims(img);
        
        % creates a new dialog, and populates it with some fields
        gd = imagem.gui.GenericDialog('Box Mean Filter');
        obj.Handles.Dialog = gd;
        
        hWidth = addNumericField(gd, 'Box Size X: ', 3, 0);
        set(hWidth, 'CallBack', @obj.onNumericFieldModified);
        obj.Handles.WidthTextField = hWidth;
        
        hDepth = addNumericField(gd, 'Box Size Y: ', 3, 0);
        set(hDepth, 'CallBack', @obj.onNumericFieldModified);
        obj.Handles.HeightTextField = hDepth;
        
        if nd == 3
            hDepth = addNumericField(gd, 'Box Size Z: ', 3, 0);
            set(hDepth, 'CallBack', @obj.onNumericFieldModified);
            obj.Handles.HeightTextField = hDepth;
        end
        
        hPreview = addCheckBox(gd, 'Preview', false);
        set(hPreview, 'CallBack', @obj.onPreviewCheckBoxChanged);
        obj.Handles.PreviewCheckBox = hPreview;
        
        % displays the dialog, and waits for user
        showDialog(gd);
        
        % refresh display of main figure
        clearPreviewImage(obj.Viewer);
            
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % retrieve user params and create kernel
        sizes = getSizeList(obj);
        
        % apply 'mean' operation
        img2 = computeResultImage(obj);
        
        % add image to application, and create new display
        [newDoc, newViewer] = addImageDocument(obj.Viewer, img2);
        copySettings(newViewer, obj.Viewer);
        updateDisplay(newViewer);

        % add history
        arrPat = ['[%d' repmat(' %d', 1, nd-1) ']'];
        pattern = ['%s = boxFilter(%s, ' arrPat ');\n'];
        string = sprintf(pattern, newDoc.Tag, doc.Tag, sizes);
        addToHistory(obj.Viewer, string);
    end
    
    function onNumericFieldModified(obj, src, event) %#ok<INUSD>
        % update preview image of the document
        
        obj.NeedUpdate = true;
        
        hPreview = obj.Handles.PreviewCheckBox;
        if get(hPreview, 'Value') == get(hPreview, 'Max')
            updatePreviewImage(obj);
            obj.Viewer.Doc.PreviewImage = obj.PreviewImage;
            updateDisplay(obj.Viewer);
        end

    end
    
    function onPreviewCheckBoxChanged(obj, src, event) %#ok<INUSD>
        hPreview = obj.Handles.PreviewCheckBox;
        if get(hPreview, 'Value') == get(hPreview, 'Max')
            if obj.NeedUpdate
                updatePreviewImage(obj);
            end
            obj.Viewer.Doc.PreviewImage = obj.PreviewImage;
        else
            obj.Viewer.Doc.PreviewImage = [];
        end
        
        updateDisplay(obj.Viewer);
    end
    
    function updatePreviewImage(obj)
        % update preview image from dialog options, and toggle update flag

        % apply smoothing operation
        obj.PreviewImage = computeResultImage(obj);
        
        % reset state of update
        obj.NeedUpdate = false;
    end
    
    function res = computeResultImage(obj)
        
        % retrieve user params
        sizes = getSizeList(obj);
        
        % apply smoothing operation on current image
        img = currentImage(obj.Viewer);
        res = boxFilter(img, sizes);
    end
    
    function sizes = getSizeList(obj)
        % Retrieve the 1-by-ND list of box size given by user.
        
        % get current image
        img = currentImage(obj.Viewer);
        
        sizeX = getNextNumber(obj.Handles.Dialog);
        sizeY = getNextNumber(obj.Handles.Dialog);
        sizes = [sizeX sizeY];
        if img.Dimension > 2
            sizeZ = getNextNumber(obj.Handles.Dialog);
            sizes = [sizes sizeZ];
        end
        resetCounter(obj.Handles.Dialog);
    end
    
end % end methods

end % end classdef


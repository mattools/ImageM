classdef ImageMedianFilter < imagem.actions.CurrentImageAction
% Apply median filtering with box neighborhood on current image.
%
%   Class ImageMedianFilterAction
%
%   Example
%   ImageMedianFilterAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-14,    using Matlab 7.9.0.529 (R2009b)
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
    function obj = ImageMedianFilter()
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSD>
%         disp('Compute Image median filter');
        
        % get handle to current doc
        obj.Viewer = frame;
        doc = currentDoc(frame);
        
        % creates a new dialog, and populates it with some fields
        gd = imagem.gui.GenericDialog('Median Filter');
        obj.Handles.Dialog = gd;
        
        hWidth = addNumericField(gd, 'Box Width: ', 3, 0);
        set(hWidth, 'CallBack', @obj.onNumericFieldModified);
        obj.Handles.WidthTextField = hWidth;
        
        hHeight = addNumericField(gd, 'Box Height: ', 3, 0);
        set(hHeight, 'CallBack', @obj.onNumericFieldModified);
        obj.Handles.HeightTextField = hHeight;
        
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
        
        % get dialog options
        width = getNextNumber(gd);
        height = getNextNumber(gd);
        
        % apply 'median' operation
        se = ones(width, height);
        img2 = medianFilter(currentImage(obj.Viewer), se);
        
        % add image to application, and create new display
        [newDoc, newViewer] = addImageDocument(frame, img2);
        copySettings(newViewer, frame);
        updateDisplay(newViewer);

        % add history
        string = sprintf('%s = medianFilter(%s, ones(%d,%d));\n', ...
            newDoc.Tag, doc.Tag, width, height);
        addToHistory(obj.Viewer, string);
    end
    
    function onNumericFieldModified(obj, src, event) %#ok<INUSD>
        % update preview image of the document
        
        obj.NeedUpdate = true;
        
        hPreview = obj.Handles.PreviewCheckBox;
        if get(hPreview, 'Value') == get(hPreview, 'Max')
            recomputePreviewImage(obj);
            updatePreviewImage(obj.Viewer, obj.PreviewImage);
        end

    end
    
    function onPreviewCheckBoxChanged(obj, src, event) %#ok<INUSD>
        hPreview = obj.Handles.PreviewCheckBox;
        if get(hPreview, 'Value') == get(hPreview, 'Max')
            if obj.NeedUpdate
                recomputePreviewImage(obj);
                updatePreviewImage(obj.Viewer, obj.PreviewImage);
            end
        else
            clearPreviewImage(obj.Viewer);
        end
    end
    
    function recomputePreviewImage(obj)
        % update preview image from dialog options, and toggle update flag
        width = getNextNumber(obj.Handles.Dialog);
        height = getNextNumber(obj.Handles.Dialog);
        resetCounter(obj.Handles.Dialog);

        % get current image
        img = currentImage(obj.Viewer);
        
        % apply 'median' operation
        se = ones(width, height);
        obj.PreviewImage = medianFilter(img, se);
        
        % reset state of update
        obj.NeedUpdate = false;
    end

end % end methods

end % end classdef


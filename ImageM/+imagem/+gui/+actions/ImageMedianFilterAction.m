classdef ImageMedianFilterAction < imagem.gui.actions.CurrentImageAction
%IMAGEMEDIANFILTER Apply median filtering with box strel on current image
%
%   Class ImageMedianFilterAction
%
%   Example
%   ImageMedianFilterAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    previewImage = [];
    needUpdate = true;
    
    handles;
end

%% Constructor
methods
    function this = ImageMedianFilterAction(viewer)
    % Constructor for the parent class
        this = this@imagem.gui.actions.CurrentImageAction(viewer, 'medianFilter');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(this, src, event) %#ok<INUSD>
%         disp('Compute Image median filter');
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;
        
        % creates a new dialog, and populates it with some fields
        gd = imagem.gui.GenericDialog('Create Image');
        this.handles.dialog = gd;
        
        hWidth = addNumericField(gd, 'Box Width: ', 3, 0);
        set(hWidth, 'CallBack', @this.onNumericFieldModified);
        this.handles.widthTextField = hWidth;
        
        hHeight = addNumericField(gd, 'Box Height: ', 3, 0);
        set(hHeight, 'CallBack', @this.onNumericFieldModified);
        this.handles.heightTextField = hHeight;
        
        hPreview = addCheckBox(gd, 'Preview', false);
        set(hPreview, 'CallBack', @this.onPreviewCheckBoxChanged);
        this.handles.previewCheckBox = hPreview;
        
        % displays the dialog, and waits for user
        showDialog(gd);
        
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            this.viewer.doc.previewImage = [];
            updateDisplay(this.viewer);
            return;
        end
        
        % get dialog options
        width = getNextNumber(gd);
        height = getNextNumber(gd);
        
        se = ones(width, height);
        
        % apply 'median' operation
        img2 = medianFilter(doc.image, se);
        
        % add image to application, and create new display
        newDoc = addImageDocument(viewer.gui, img2);

        % add history
        string = sprintf('%s = medianFilter(%s, ones(%d,%d));\n', ...
            newDoc.tag, doc.tag, width, height);
        addToHistory(viewer.gui.app, string);
    end
    
    function onNumericFieldModified(this, src, event) %#ok<INUSD>
        % update preview image of the document
        
        this.needUpdate = true;
        
        hPreview = this.handles.previewCheckBox;
        if get(hPreview, 'Value') == get(hPreview, 'Max')
            updatePreviewImage(this);
            this.viewer.doc.previewImage = this.previewImage;
            updateDisplay(this.viewer);
        end

    end
    
    function onPreviewCheckBoxChanged(this, src, event) %#ok<INUSD>
        hPreview = this.handles.previewCheckBox;
        if get(hPreview, 'Value') == get(hPreview, 'Max')
            if this.needUpdate
                updatePreviewImage(this);
            end
            this.viewer.doc.previewImage = this.previewImage;
        else
            this.viewer.doc.previewImage = [];
        end
        
        updateDisplay(this.viewer);
    end
    
    function updatePreviewImage(this)
        % update preview image from dialog options, and toggle update flag
        width = getNextNumber(this.handles.dialog);
        height = getNextNumber(this.handles.dialog);
        resetCounter(this.handles.dialog);

        % apply 'median' operation
        se = ones(width, height);
        this.previewImage = medianFilter(this.viewer.doc.image, se);
        
        % reset state of update
        this.needUpdate = false;
    end

end % end methods

end % end classdef


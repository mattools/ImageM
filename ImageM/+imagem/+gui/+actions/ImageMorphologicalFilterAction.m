classdef ImageMorphologicalFilterAction < imagem.gui.actions.CurrentImageAction
%IMAGEMORPHOLOGICALFILTERACTION Apply morphological filtering on current image
%
%   Class ImageMorphologicalFilterAction
%
%   Example
%   ImageMorphologicalFilterAction
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
    operationList = {'Dilation', 'Erosion', 'Closing', 'Opening'};
    commandList = {'dilation', 'erosion', 'closing', 'opening'};
    
    shapeList = {'Square', 'Diamond', 'Octogon', 'Disk'};
    
    previewImage = [];
    needUpdate = true;
    
    handles;
end

%% Constructor
methods
    function this = ImageMorphologicalFilterAction(viewer)
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
        gd = imagem.gui.GenericDialog('Morphological Filter');
        this.handles.dialog = gd;
        
        hOperation = addChoice(gd, 'Operation: ', this.operationList, ...
            this.operationList{1});
        set(hOperation, 'CallBack', @this.onWidgetUpdated);
        this.handles.operationPopup = hOperation;

        hShape = addChoice(gd, 'Shape: ', this.shapeList, ...
            this.shapeList{1});
        set(hShape, 'CallBack', @this.onWidgetUpdated);
        this.handles.shapePopup = hShape;
        
        hRadius = addNumericField(gd, 'Box Width: ', 3, 0);
        set(hRadius, 'CallBack', @this.onWidgetUpdated);
        this.handles.radiusTextField = hRadius;
        
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
        
        img2 = updatePreviewImage(this);
        
        % add image to application, and create new display
        newDoc = addImageDocument(viewer.gui, img2);
        
%         % add history
%         string = sprintf('%s = medianFilter(%s, ones(%d,%d));\n', ...
%             newDoc.tag, doc.tag, width, height);
%         addToHistory(viewer.gui.app, string);
    end
    
    function onWidgetUpdated(this, src, event) %#ok<INUSD>
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
    
    function img2 = updatePreviewImage(this)
        % update preview image from dialog options, and toggle update flag
        
        % get dialog options
        gd = this.handles.dialog;
        opIndex = getNextChoiceIndex(gd);
        shapeIndex = getNextChoiceIndex(gd);
        radius = getNextNumber(gd);
        resetCounter(this.handles.dialog);
        
        diam = 2 * radius + 1;
        se = ones(diam, diam);
        
        % apply filtering operation
        command = this.commandList{opIndex};
        img = this.viewer.doc.image;
        img2 = eval(sprintf('%s(img,se)', command));
        this.previewImage = img2;
        
        % reset state of update
        this.needUpdate = false;
    end

end % end methods

end % end classdef


classdef ImageGaussianFilterAction < imagem.gui.actions.CurrentImageAction
%IMAGEGAUSSIANFILTERACTION  Apply gaussian filter on current image
%
%   Class ImageGaussianFilterAction
%
%   Example
%   ImageGaussianFilterAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2016-01-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    previewImage = [];
    needUpdate = true;
    
    % list of handles on the dialog widgets
    handles;
end


%% Constructor
methods
    function this = ImageGaussianFilterAction(viewer)
    % Constructor for ImageGaussianFilterAction class
        this = this@imagem.gui.actions.CurrentImageAction(viewer, 'gaussianFilter');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(this, src, event) %#ok<INUSD>
%         disp('Compute Image box mean filter');
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;
        
        % creates a new dialog, and populates it with some fields
        gd = imagem.gui.GenericDialog('Gaussian Filter');
        this.handles.dialog = gd;
        
        hWidth = addNumericField(gd, 'Sigma X: ', 3, 0);
        set(hWidth, 'CallBack', @this.onNumericFieldModified);
        this.handles.widthTextField = hWidth;
        
        hHeight = addNumericField(gd, 'Sigma Y: ', 3, 0);
        set(hHeight, 'CallBack', @this.onNumericFieldModified);
        this.handles.heightTextField = hHeight;
        
        hPreview = addCheckBox(gd, 'Preview', false);
        set(hPreview, 'CallBack', @this.onPreviewCheckBoxChanged);
        this.handles.previewCheckBox = hPreview;
        
        % displays the dialog, and waits for user
        showDialog(gd);
        
        % refresh display of main figure
        this.viewer.doc.previewImage = [];
        updateDisplay(this.viewer);
            
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % get dialog options
        sigmaX = getNextNumber(gd);
        sigmaY = getNextNumber(gd);
        
        % apply 'mean' operation
        sigma = [sigmaX sigmaY];
        size = 2 * round(sigma * 1.25) + 1;
        img2 = gaussianFilter(doc.image, size, sigma);
        
        % add image to application, and create new display
        newDoc = addImageDocument(viewer.gui, img2);

        % add history
        string = sprintf('%s = gaussianFilter(%s, [%g %g], [%g %g]);\n', ...
            newDoc.tag, doc.tag, size, sigma);
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
        sigmaX = getNextNumber(this.handles.dialog);
        sigmaY = getNextNumber(this.handles.dialog);
        resetCounter(this.handles.dialog);
        
        % apply 'mean' operation
        sigma = [sigmaX sigmaY];
        size = 2 * round(sigma * 1.25) + 1;
        this.previewImage = gaussianFilter(this.viewer.doc.image, size, sigma);
        
        % reset state of update
        this.needUpdate = false;
    end

end % end methods

end % end classdef


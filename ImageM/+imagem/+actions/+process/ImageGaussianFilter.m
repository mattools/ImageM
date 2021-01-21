classdef ImageGaussianFilter < imagem.actions.CurrentImageAction
% Apply gaussian filter on current image.
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
    function obj = ImageGaussianFilter()
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSD>
%         disp('Compute Image box mean filter');
        
        % get handle to current doc
        obj.Viewer = frame;
        doc = frame.Doc;
        
        % creates a new dialog, and populates it with some fields
        gd = imagem.gui.GenericDialog('Gaussian Filter');
        obj.Handles.Dialog = gd;
        
        hWidth = addNumericField(gd, 'Sigma X: ', 3, 0);
        set(hWidth, 'CallBack', @obj.onNumericFieldModified);
        obj.Handles.WidthTextField = hWidth;
        
        hHeight = addNumericField(gd, 'Sigma Y: ', 3, 0);
        set(hHeight, 'CallBack', @obj.onNumericFieldModified);
        obj.Handles.HeightTextField = hHeight;
        
        hPreview = addCheckBox(gd, 'Preview', false);
        set(hPreview, 'CallBack', @obj.onPreviewCheckBoxChanged);
        obj.Handles.PreviewCheckBox = hPreview;
        
        % displays the dialog, and waits for user
        showDialog(gd);
        
        % refresh display of main figure
        doc.PreviewImage = [];
        updateDisplay(obj.Viewer);
            
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
        img2 = gaussianFilter(doc.Image, size, sigma);
        
        % add image to application, and create new display
        [~, newDoc] = createImageFrame(obj.Viewer, img2);

        % add history
        string = sprintf('%s = gaussianFilter(%s, [%g %g], [%g %g]);\n', ...
            newDoc.Tag, doc.Tag, size, sigma);
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
        sigmaX = getNextNumber(obj.Handles.Dialog);
        sigmaY = getNextNumber(obj.Handles.Dialog);
        resetCounter(obj.Handles.Dialog);
        
        % get current image
        img = currentImage(obj.Viewer);
        
        % apply filter operation
        sigma = [sigmaX sigmaY];
        size = 2 * round(sigma * 1.25) + 1;
        obj.PreviewImage = gaussianFilter(img, size, sigma);
        
        % reset state of update
        obj.NeedUpdate = false;
    end

end % end methods

end % end classdef


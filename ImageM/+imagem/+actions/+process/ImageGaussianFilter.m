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
        
        % get handle to current doc
        obj.Viewer = frame;
        doc = frame.Doc;
        
        % number of spatial dimensions of current image
        img = doc.Image;
        nd = ndims(img);
        
        % creates a new dialog, and populates it with some fields
        gd = imagem.gui.GenericDialog('Gaussian Filter');
        obj.Handles.Dialog = gd;
        
        hWidth = addNumericField(gd, 'Sigma X: ', 3, 0);
        set(hWidth, 'CallBack', @obj.onNumericFieldModified);
        obj.Handles.WidthTextField = hWidth;
        
        hHeight = addNumericField(gd, 'Sigma Y: ', 3, 0);
        set(hHeight, 'CallBack', @obj.onNumericFieldModified);
        obj.Handles.HeightTextField = hHeight;
        
        if nd == 3
            hDepth = addNumericField(gd, 'Sigma Z: ', 3, 0);
            set(hDepth, 'CallBack', @obj.onNumericFieldModified);
            obj.Handles.HeightTextField = hDepth;
        end
        
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
        
        % apply smoothing operation
        img2 = computeResultImage(obj);
        
        % add image to application, and create new display
        [~, newDoc] = createImageFrame(obj.Viewer, img2);

        % retrieve parameters
        sigmas = getSigmaList(obj);
        sizes = 2 * round(sigmas * 1.25) + 1;

        % add history
        pat1 = ['[%d' repmat(' %d', 1, nd-1) ']'];
        pat2 = ['[%g' repmat(' %g', 1, nd-1) ']'];
        pattern = ['%s = gaussianFilter(%s, ' pat1 ', ' pat2 ');\n'];
        string = sprintf(pattern, newDoc.Tag, doc.Tag, sizes, sigmas);
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

        % apply filter operation
        obj.PreviewImage = computeResultImage(obj);
        
        % reset state of update
        obj.NeedUpdate = false;
    end
    
    function res = computeResultImage(obj)
        
        % retrieve parameters
        sigmas = getSigmaList(obj);
        sizes = 2 * round(sigmas * 1.25) + 1;
        
        % apply smoothing operation on current image
        img = currentImage(obj.Viewer);
        res = gaussianFilter(img, sizes, sigmas);
    end
    
    function sigma = getSigmaList(obj)
        % Retrieve the 1-by-ND list of sigma given by user.
        
        % get current image
        img = currentImage(obj.Viewer);
        
        sigmaX = getNextNumber(obj.Handles.Dialog);
        sigmaY = getNextNumber(obj.Handles.Dialog);
        sigma = [sigmaX sigmaY];
        if img.Dimension > 2
            sigmaZ = getNextNumber(obj.Handles.Dialog);
            sigma = [sigma sigmaZ];
        end
        resetCounter(obj.Handles.Dialog);
    end
    
end % end methods

end % end classdef


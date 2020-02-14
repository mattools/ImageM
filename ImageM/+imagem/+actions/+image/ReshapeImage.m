classdef ReshapeImage < imagem.actions.CurrentImageAction
% Reshape current image.
%
%   Class ReshapeImageAction
%
%   Example
%   ReshapeImageAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-05-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = ReshapeImage()
        % Constructor for the ReshapeImage action.
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL,INUSD>
         
        % get current image
        doc = currentDoc(frame);
        img = doc.Image;
        
        dims = size(img, 1:5);
        ZCT = prod(dims(3:5));
        newDims = dims;
        
        while true
            % create dialog
            gd = imagem.gui.GenericDialog('Reshape Image');
            addNumericField(gd, 'Size X:',  newDims(1), 0);
            addNumericField(gd, 'Size Y:',  newDims(2), 0);
            addNumericField(gd, 'Size Z:',  newDims(3), 0);
            addNumericField(gd, 'Channels (C):', newDims(4), 0);
            addNumericField(gd, 'Frames (T):',  newDims(5), 0);
            addMessage(gd, sprintf('ZxCxT must equal %d', ZCT));

            showDialog(gd);
            if wasCanceled(gd)
                return;
            end

            % parse dialog options
            newDims = zeros([1 5]);
            newDims(1) = getNextNumber(gd);
            newDims(2) = getNextNumber(gd);
            newDims(3) = getNextNumber(gd);
            newDims(4) = getNextNumber(gd);
            newDims(5) = getNextNumber(gd);
            
            if prod(newDims) == prod(dims)
                break;
            end
        end
        
        res = reshape(img, newDims);
        
        % add image to application, and create new display
        [newFrame, newDoc] = createImageFrame(frame.Gui, res); %#ok<ASGLU>
        
        % add history
        newShapeString = sprintf('[%d %d %d %d %d]', newDims);
        string = sprintf('%s = reshape(%s, %s);\n', ...
             newDoc.Tag, doc.Tag, newShapeString);
        addToHistory(frame, string);
    end
end

end % end classdef


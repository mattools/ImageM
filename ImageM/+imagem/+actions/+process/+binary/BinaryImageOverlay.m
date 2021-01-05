classdef BinaryImageOverlay < imagem.gui.Action
% Apply binary overlay over current image.
%
%   Class ImageOverlayAction
%
%   Example
%   ImageOverlayAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2011-12-15,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = BinaryImageOverlay()
    end

end % end constructors

methods
    function run(obj, frame) %#ok<INUSL>
        
        app = frame.Gui.App;
        imageNames = getImageNames(app);
        colorNames = imagem.util.enums.BasicColors.allLabels;
        
        % Creates the Dialog for choosing options
        gd = imagem.gui.GenericDialog('Binary Overlay');
        addChoice(gd, 'Reference Image:', imageNames, imageNames{1});
        addChoice(gd, 'Binary Image:', imageNames, imageNames{1});
        addChoice(gd, 'Overlay Color:', colorNames, colorNames{1});
        
        % displays the dialog, and waits for user
        showDialog(gd);
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % parse user inputs
        refDoc = getDocument(app, getNextString(gd));
        binDoc = getDocument(app, getNextString(gd));
        colorItem = imagem.util.enums.BasicColors.fromLabel(getNextString(gd));
        color = colorItem.RGB;
        
        % retrieve images
        refImg = refDoc.Image;
        binImg = binDoc.Image;
        
        % check inputs
        if ~isBinaryImage(binImg)
            error('Overlay Image must be binary');
        end
        if ndims(refImg) ~= ndims(binImg)
            error('Input images must have same dimension');
        end
        if any(size(refImg) ~= size(binImg))
            error('Input images must have same size');
        end
        
        ovr = overlay(refImg, binImg, color);
        name = 'NoName-ovr';
        if ~isempty(refImg.Name)
            name = [refImg.Name '-ovr'];
        end
        ovr.Name = name;
        
        % add image to application, and create new display
        newDoc = addImageDocument(frame, ovr);
        
        % add history
        string = sprintf('%s = overlay(%s, %s, [%g %g %g]);\n', ...
            newDoc.Tag, refDoc.Tag, binDoc.Tag, color);
        addToHistory(frame, string);
    end
    
end

end % end classdef


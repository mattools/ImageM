classdef KeepLargestRegion < imagem.actions.CurrentImageAction
% Keep the largest region within a binary image.
%
%   Class keepLargestRegionAction
%
%   Example
%   keepLargestRegionAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-05-25,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = KeepLargestRegion()
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        
        % get handle to viewer figure, and current doc
        doc = currentDoc(frame);
        
        % compute Image skeleton
        img2 = largestRegion(doc.Image);
        
        % add image to application, and create new display
        newDoc = addImageDocument(frame, img2);
        
        % history
        string = sprintf('%s = largestRegion(%s);\n', newDoc.Tag, doc.Tag);
        addToHistory(frame, string);
    end
end % end methods

methods
    function b = isActivable(obj)
        b = isActivable@imagem.gui.actions.CurrentImageAction(obj);
        if b
            img = currentImage(obj);
            binFlag = isBinaryImage(img);
            lblFlag = isLabelImage(img);
            b = b && (binFlag || lblFlag);
        end
    end
end

end % end classdef


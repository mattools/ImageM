classdef KillImageBorders < imagem.actions.CurrentImageAction
% Kill borders of a binary image.
%
%   Class KillImageBordersAction
%
%   Example
%   KillImageBordersAction
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
    function obj = KillImageBorders()
    end

end % end constructors


%% Methods
methods
    function run(obj, frame)  %#ok<INUSL>
        
        % get handle to  current doc
        doc = currentDoc(frame);
        img = currentImage(frame);
        
        % compute Image skeleton
        img2 = killBorders(img);
        
        % add image to application, and create new display
        newDoc = addImageDocument(frame, img2);
        
        % history
        string = sprintf('%s = killBorders(%s);\n', newDoc.Tag, doc.Tag);
        addToHistory(frame, string);
    end
end % end methods

methods
    function b = isActivable(obj, frame)
        b = isActivable@imagem.actions.CurrentImageAction(obj, frame);
        if b
            img = currentImage(frame);
            binFlag = isBinaryImage(img);
            lblFlag = isLabelImage(img);
            b = b && (binFlag || lblFlag);
        end
    end
end

end % end classdef


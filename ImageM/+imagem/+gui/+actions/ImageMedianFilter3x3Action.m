classdef ImageMedianFilter3x3Action < imagem.gui.actions.CurrentImageAction
% Apply a simple filter on current image.
%
%   Class ImageMedianFilter3x3Action
%
%   Example
%   ImageMedianFilter3x3Action
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Constructor
methods
    function obj = ImageMedianFilter3x3Action(viewer)
    % Constructor for the parent class
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, 'medianFilter3x3');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        disp('Compute Image median filter');
        
        % get handle to viewer figure, and current doc
        doc = currentDoc(obj);
        
        % apply 'median' operation
        se = ones(3, 3);
        img2 = medianFilter(doc.Image, se);
        
        % add image to application, and create new display
        newDoc = addImageDocument(obj, img2);

        % add history
        string = sprintf('%s = medianFilter(%s, ones(3,3));\n', ...
            newDoc.Tag, doc.Tag);
        addToHistory(obj, string);
    end
end % end methods

end % end classdef


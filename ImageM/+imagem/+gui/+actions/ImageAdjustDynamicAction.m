classdef ImageAdjustDynamicAction < imagem.gui.actions.ScalarImageAction
% Adjust dynamic of current image.
%
%   output = ImageAdjustDynamicAction(input)
%
%   Example
%   ImageAdjustDynamicAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-08,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function obj = ImageAdjustDynamicAction(viewer, varargin)
        % calls the viewer constructor
        obj = obj@imagem.gui.actions.ScalarImageAction(viewer, 'adjustDynamic');
    end
end

methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        disp('Adjust image dynamic');
        
        % apply 'norm' operation
        img2 = adjustDynamic(currentImage(obj));
        
        % add image to application, and create new display
        addImageDocument(obj, img2);
    end
end

end
classdef AdjustImageDynamic < imagem.actions.ScalarImageAction
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
    function obj = AdjustImageDynamic()
    end
end

methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        disp('Adjust image dynamic');
        
        % apply 'norm' operation
        img2 = adjustDynamic(currentImage(frame));
        
        % add image to application, and create new display
        addImageDocument(frame, img2);
    end
end

end
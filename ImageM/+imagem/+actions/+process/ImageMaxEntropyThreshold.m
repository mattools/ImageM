classdef ImageMaxEntropyThreshold < imagem.actions.ScalarImageAction
% Threshold a grayscale image using max entropy method.
%
%   output = ImageMaxEntropyThresholdAction(input)
%
%   Example
%   ImageMaxEntropyThresholdAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-04-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function obj = ImageMaxEntropyThreshold(varargin)
        % calls the parent constructor
        obj = obj@imagem.actions.ScalarImageAction(varargin{:});
    end
end

methods
    function run(obj, frame) %#ok<INUSL,INUSD>

        % get handle to current doc and image
        doc = currentDoc(frame);
        img = doc.Image;
        
        % apply 'threshold' operation
        bin = maxEntropyThreshold(img);
        
        % add image to application, and create new display
        [frame2, newDoc] = createImageFrame(frame, bin); %#ok<ASGLU>

        % add history
        string = sprintf('%s = maxEntropyThreshold(%s);\n', newDoc.Tag, doc.Tag);
        addToHistory(frame, string);

    end
end

end
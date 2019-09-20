classdef ShowImageHistogram < imagem.actions.CurrentImageAction
% Display histogram of current image.
%
%   output = ShowImageHistogramAction(input)
%
%   Example
%   ShowImageHistogramAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-11-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function obj = ShowImageHistogram()
    end
end

methods
    function run(obj, frame) %#ok<INUSL>
        disp('Show image histogram');
        
        % open figure to display histogram
        figure;
        histogram(currentImage(frame));
    end
end

end
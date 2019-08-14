classdef ShowImageHistogramAction < imagem.gui.actions.CurrentImageAction
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
    function obj = ShowImageHistogramAction(viewer, varargin)
        % calls the parent constructor
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, 'showImageHistogram');
    end
end

methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        disp('Show image histogram');
        
        % open figure to display histogram
        figure;
        histogram(currentImage(obj));
    end
end

end
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
% e-mail: david.legland@inrae.fr
% Created: 2011-11-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function obj = ShowImageHistogram()
    end
end

methods
    function run(obj, frame) %#ok<INUSL>
        disp('Show image histogram');
        
        img = currentImage(frame);
        
        % if selection exists, use it as roi
        roi = [];
        if isprop(frame, 'Selection') && ~isempty(frame.Selection)
            
            selection = frame.Selection;
            type = selection.Type;
            
            if strcmpi(type, 'Polygon')
                poly = selection.Data;
                roi = roipoly(img.Data(:,:,1,1,1), poly(:,2), poly(:,1));
            elseif strcmp(type, 'box')
                box = selection.Data;
                poly = boxToPolygon(box);
                roi = roipoly(img.Data(:,:,1,1,1), poly(:,2), poly(:,1));
            else
                warning('Can not use ROI with type %s forhistogram, compute whole histogram', type);
            end
        end
        
        % open figure to display histogram
        figure;
        histogram(img, frame.DisplayRange, roi);
    end
end

end
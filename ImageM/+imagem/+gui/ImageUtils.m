classdef ImageUtils < handle
% Utility methods for Image class management.
%
%   The ImageUtils class contains only static methods.
%
%   Example
%   ImageUtils
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2016-03-28,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2016 INRA - BIA-BIBS.


%% Methods
methods (Static)
    function cdata = computeDisplayImage(image)
        % Computes a matlab image for display using inner image data
        %
        % usage
        % CDATA = imagem.ImageUtils.computeDisplayImage(IMG);
        % 
        
        % extract or compute display data
        if isGrayscaleImage(image) || isColorImage(image)
            cdata = permute(image.Data, [2 1 4 3]);
             
        elseif isLabelImage(image)
            % label image will be replaced by RGB image
            rgb = label2rgb(image);
            cdata = permute(rgb.Data, [2 1 4 3]);
        
        elseif isVectorImage(image)
            % in case of vector images, display the norm
            imgNorm = norm(image);
            cdata = permute(imgNorm.Data, [2 1 4 3]);
            
        else
            % intensity or unknown type
            cdata = permute(image.Data, [2 1 4 3]);
            
        end
    end
    
    function [mini, maxi] = computeDisplayRange(image)
        % compute best display range for an image according to its type
        
        % extract or compute display data
        if isGrayscaleImage(image) || isColorImage(image)
            cdata = permute(image.Data, [2 1 4 3]);
            mini = 0;
            if islogical(cdata)
                maxi = 1;
            elseif isinteger(cdata)
                maxi = intmax(class(cdata));
            else
                warning('ImageM:Display', ...
                    'Try to display a grayscale image with float data');
                maxi = max(cdata(:));
            end
            
        elseif isLabelImage(image)
            % label image will be replaced by RGB image
            maxi = 255;
            mini = 0;
        
        elseif isVectorImage(image)
            % in case of vector images, display the norm
            imgNorm = norm(image);
            cdata = permute(imgNorm.Data, [2 1 4 3]);
            mini = min(cdata(:));
            maxi = max(cdata(:));

        else
            % intensity or unknown type
            cdata = permute(image.Data, [2 1 4 3]);
            mini = min(cdata(:));
            maxi = max(cdata(:));
            
        end

        % ensure maxi > mini
        if maxi <= mini
            maxi = mini + 1;
        end
        
        if nargout == 1
            mini = [mini maxi];
        end
    end
end % end methods

end % end classdef


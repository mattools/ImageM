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
    function cdata = computeDisplayImage(image, varargin)
        % Computes a matlab image for display using inner image data.
        %
        % Usage:
        % CDATA = imagem.ImageUtils.computeDisplayImage(IMG);
        % CDATA = imagem.ImageUtils.computeDisplayImage(IMG, LUT, BOUNDS, BGCOLOR);
        % 
        
        % extract or compute display data
        if isGrayscaleImage(image) || isColorImage(image)
            cdata = permute(image.Data, [2 1 4 3]);
             
        elseif isLabelImage(image)
            % label image will be replaced by RGB image
            if length(varargin) == 3
                options = varargin([1 3]);
            else
                options = {};
            end
            rgb = label2rgb(image, options{:});
            cdata = permute(rgb.Data, [2 1 4 3]);
        
        elseif isVectorImage(image)
            % in case of vector images, display the norm
            imgNorm = norm(image);
            cdata = permute(imgNorm.Data, [2 1 4 3]);
            
        elseif isScalarImage(image)
            % intensity -> convert to RGB to manage NaN values coloration
            rgb = double2rgb(image, varargin{:});
            cdata = permute(rgb.Data, [2 1 4 3]);
            
        else
            % unknown type
            cdata = permute(image.Data, [2 1 4 3]);
            
        end
    end
    
    function [mini, maxi] = computeDisplayRange(image)
        % Compute best display range for an image according to its type.
        
        % extract or compute display data
        if isBinaryImage(image)
            mini = 0;
            maxi = 1;
        elseif isGrayscaleImage(image)
            mini = 0;
            if isa(image.Data, 'uint8')
                maxi = 255;
            elseif isinteger(image.Data)
                maxi = max(image.Data(:));
            else
                warning('ImageM:Display', ...
                    'Try to display a grayscale image with non-integer data');
                maxi = max(image.Data(:));
            end
            
        elseif isColorImage(image)
            mini = 0;
            if isinteger(image.Data)
                maxi = intmax(class(image.Data));
            else
                % RGB using floating-point values
                maxi = 1;
            end
            
        elseif isLabelImage(image)
            % label image will be replaced by RGB image
            mini = 0;
            maxi = 255;
        
        elseif isVectorImage(image)
            % in case of vector images, display the norm
            imgNorm = norm(image);
            mini = min(imgNorm.Data(:));
            maxi = max(imgNorm.Data(:));

        else
            % intensity or unknown type
            mini = min(image.Data(:));
            maxi = max(image.Data(:));
            
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


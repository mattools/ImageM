classdef ImageDoc < imagem.app.ImagemDoc
% ImageM Document class that contains one image and the associated data.
%
%   Class ImageDoc
%
%   Example
%   ImageDoc
%
%   See also
%     imagem.app.ImagemDoc, imagem.app.TableDoc

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-10-22,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    % The reference image (an instance of Image class).
    Image;
    
    % An image used for preview when an action is running, or empty.
    PreviewImage = [];

    % Display range info are managed within the ImageViewer class.
    
    % Look-up table (colormap) used for displaying the image. 
    % Uses 256 values for grayscale/intensity images, and label number for
    % label images.
    % If empty -> no lut
    ColorMap = [];
    
    % Name of the current lookup table (used for display in menus).
    ColorMapName = '';
    
    % The color associated to background, as a 1-by-3 vector of RGB values
    % within the [0 1] interval. Default is white.
    % For label images, corresponds to the label "0".
    % For intensity images, corresponds to the value "NaN".
    BackgroundColor = [1 1 1];
        
    % Specifies the preferred way for displaying channels.
    % Can be one of: {'Curve'}, 'Bar', 'Stem'.
    ChannelDisplayType = 'Curve';
    
    % A set of annotations.
    % stored as an array of structures with fields type, data, style.
    Shapes = {};
        
end % end properties


%% Constructor
methods
    function obj = ImageDoc(img)
        % Constructor for ImagemDoc class.
        % Requires an image as input.

        if nargin ~= 1
            error('An image must be provided as input');
        end
        if ~isa(img, 'Image')
            error('Input argument must be an instance of Image class');
        end
        
        obj.Image = img;
        
        
%         poly = circleToPolygon([50 50 40], 120);
%         shape = struct(...
%             'type', 'polygon', 'data', poly, ...
%             'style', {{'-m', 'LineWidth', 2}});
%         
%         obj.Shapes = {shape};
    end

end % end constructors

%% Methods for image management
methods
    function name = imageNameForDisplay(obj)
        % return the name of the image, or a default name is name is empty
        
        name = obj.Image.Name;
        if isempty(name)
            name = 'Unknown Image';
        end
    end
end


%% Methods for shapes management

methods
    function addShape(obj, s)
        obj.Shapes = [obj.Shapes {s}];
    end
    
    function removeShape(obj, s)
        ind = -1;
        for i = 1:length(obj.Shapes)
            if obj.Shapes{i} == s
                ind = i;
                break;
            end
        end
        
        if ind == -1
            error('could not find the shape to remove');
        end
        
        obj.Shapes(ind) = [];
    end
    
    function s = getShapes(obj)
        s = obj.Shapes;
    end
    
    function clearShapes(obj)
        obj.Shapes = {};
    end
    
end % end methods

end % end classdef


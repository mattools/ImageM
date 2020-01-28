classdef ImageDoc < imagem.app.ImagemDoc
% ImageM Document class that contains one image and the associated data.
%
%   Class ImagemDoc
%
%   Example
%   ImagemDoc
%
%   See also
%

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
    
%     % a row vector of two values indicating minimal and maximal displayable
%     % values for grayscale and intensity images.
%     % (for the moment, this is managed in the PlanarImageViewer class)
%     displayRange = [];
    
    % Look-up table (colormap) used for displaying the image. 
    % If empty -> no lut
    Lut = [];
    
    % Name of the current lookup table (used for display in menus).
    LutName = '';
    
    % Background color used for display of label images.
    BackgroundColor = 'w';
    
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
        if ~isempty(obj.Image.FilePath)
            [path, name, ext] = fileparts(obj.Image.FilePath);  %#ok<ASGLU>
            name = [name ext];
        end
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
    
end % end methods

end % end classdef


classdef ImagemDoc < handle
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
    % the reference image (an instance of Image class)
    Image;
    
    % the name used to identify image on command-line arguments
    Tag;
    
    % an image used for preview when an action is running, or empty
    PreviewImage = [];
    
%     % a row vector of two values indicating minimal and maximal displayable
%     % values for grayscale and intensity images.
%     % (for the moment, obj is managed in the PlanarImageViewer class)
%     displayRange = [];
    
    % look-up table (colormap) used for displaying the image. 
    % If empty -> no lut
    Lut = [];
    
    % name of the current lookup table (used for display in menus)
    LutName = '';
    
    % background color used for display of label images
    BackgroundColor = 'w';
    
    % a set of annotations, stored as an array of
    % structures with fields type, data, style.
    Shapes = {};
    
    
    % a set of views attached to obj doc. Can be image viewer, profiles...
    Views = {};
    
    % a flag of modification
    Modified = false;
    
end % end properties


%% Constructor
methods
    function obj = ImagemDoc(img)
    % Constructor for ImagemDoc class
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

%% Methods for view management
methods
    function addView(obj, v)
        obj.Views = [obj.Views {v}];
    end
    
    function removeView(obj, v)
        ind = -1;
        for i = 1:length(obj.Views)
            if obj.Views{i} == v
                ind = i;
                break;
            end
        end
        
        if ind == -1
            error('could not find the view');
        end
        
        obj.Views(ind) = [];
    end
    
    function v = getViews(obj)
        v = obj.Views;
    end
    
end % end methods


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


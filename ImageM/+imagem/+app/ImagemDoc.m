classdef ImagemDoc < handle
%IMAGEMDOC ImageM Document class: contains one image and associated data
%
%   Class ImagemDoc
%
%   Example
%   ImagemDoc
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-10-22,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    % the reference image (an instance of Image class)
    image;
    
    % the name used to identify image on command-line arguments
    tag;
    
    % an image used for preview when an action is running, or empty
    previewImage = [];
    
    % look-up table (colormap) used for displaying the image. 
    % If empty -> no lut
    lut = [];
    
    % name of the current lookup table (used for display in menus)
    lutName = '';
    
    
    % a set of annotations, stored as an array of
    % structures with fields type, data, style.
    shapes = {};
    
    
    % a set of views attached to this doc. Can be image viewer, profiles...
    views = {};
    
    % a flag of modification
    modified = false;
    
end % end properties


%% Constructor
methods
    function this = ImagemDoc(img)
    % Constructor for ImagemDoc class
    % Requires an image as input.

        if nargin ~= 1
            error('An image must be provided as input');
        end
        if ~isa(img, 'Image')
            error('Input argument must be an instance of Image class');
        end
        
        this.image = img;
        
        
%         poly = circleToPolygon([50 50 40], 120);
%         shape = struct(...
%             'type', 'polygon', 'data', poly, ...
%             'style', {{'-m', 'LineWidth', 2}});
%         
%         this.shapes = {shape};
    end

end % end constructors


%% Methods for view management
methods
    function addView(this, v)
        this.views = [this.views {v}];
    end
    
    function removeView(this, v)
        ind = -1;
        for i = 1:length(this.views)
            if this.views{i} == v
                ind = i;
                break;
            end
        end
        
        if ind == -1
            error('could not find the view');
        end
        
        this.views(ind) = [];
    end
    
    function v = getViews(this)
        v = this.views;
    end
    
end % end methods


%% Methods for shapes management

methods
    function addShape(this, s)
        this.shapes = [this.shapes {s}];
    end
    
    function removeShape(this, s)
        ind = -1;
        for i = 1:length(this.shapes)
            if this.shapes{i} == s
                ind = i;
                break;
            end
        end
        
        if ind == -1
            error('could not find the shape to remove');
        end
        
        this.shapes(ind) = [];
    end
    
    function s = getShapes(this)
        s = this.shapes;
    end
    
end % end methods

end % end classdef


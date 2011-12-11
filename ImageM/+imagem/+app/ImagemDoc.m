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
    % the reference image
    image;
    
    % look-up table used for displaying the image. if empty, no lut
    lut = [];
    
    % name of the current lookup table (used for display in menus)
    lutName = '';
    
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
        
        this.image = img;
    end

end % end constructors


%% Methods
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

end % end classdef


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
   
    % other properties later...
    
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
end % end methods

end % end classdef


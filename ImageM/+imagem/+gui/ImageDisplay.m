classdef ImageDisplay < handle
%IMAGEDISPLAY Display an image on a Panel
%
%   Class ImageDisplay
%
%   Example
%   ImageDisplay
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-10-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    panel;
    image;
end % end properties


%% Constructor
methods
    function this = ImageDisplay(panel, image)
    % Constructor for ImageDisplay class
        this.panel = panel;
        this.image = image;

    end

end % end constructors


%% Methods
methods
    function refreshDisplay(varargin)
    end
end % end methods

end % end classdef


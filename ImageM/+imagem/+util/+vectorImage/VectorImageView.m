classdef VectorImageView < handle
% An interface for representing a multi-channel image as scalar or RGB.
%
%   Class VectorImageView
%
%   Example
%   VectorImageView
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-01-04,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = VectorImageView(varargin)
        % Constructor for VectorImageView class.

    end

end % end constructors


%% Methods
methods (Abstract)
    res = convert(obj, img);
end % end methods

end % end classdef


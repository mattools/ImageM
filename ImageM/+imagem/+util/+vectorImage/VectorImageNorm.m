classdef VectorImageNorm < imagem.util.vectorImage.VectorImageView
% One-line description here, please.
%
%   Class VectorImageNorm
%
%   Example
%   VectorImageNorm
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
    function obj = VectorImageNorm(varargin)
        % Constructor for VectorImageNorm class.

    end

end % end constructors


%% Implementation of VectorImageView
methods
    function res = convert(obj, img) %#ok<INUSL>
        res = norm(img);
    end
end % end methods


end % end classdef


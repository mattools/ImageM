classdef VectorImageMaxChannel < imagem.util.vectorImage.VectorImageView
% One-line description here, please.
%
%   Class VectorImageMaxChannel
%
%   Example
%   VectorImageMaxChannel
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
    function obj = VectorImageMaxChannel(varargin)
        % Constructor for VectorImageMaxChannel class.

    end

end % end constructors


%% Implementation of VectorImageView
methods
    function res = convert(obj, img) %#ok<INUSL>
        data = max(img.Data, [], 4);
        res = Image('Data', data, 'Parent', img);
    end
end % end methods


end % end classdef


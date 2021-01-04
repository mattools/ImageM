classdef VectorImageSingleChannel < imagem.util.vectorImage.VectorImageView
% One-line description here, please.
%
%   Class VectorImageSingleChannel
%
%   Example
%   VectorImageSingleChannel
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
    ChannelIndex = 1;
end % end properties


%% Constructor
methods
    function obj = VectorImageSingleChannel(varargin)
        % Constructor for VectorImageSingleChannel class.
        if ~isempty(varargin)
            obj.ChannelIndex = varargin{1};
        end

    end

end % end constructors


%% Implementation of VectorImageView
methods
    function res = convert(obj, img)
        data = img.Data(:,:,:, obj.ChannelIndex,:);
        res = Image('Data', data, 'Parent', img);
    end
end % end methods


end % end classdef


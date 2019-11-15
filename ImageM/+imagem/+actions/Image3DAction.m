classdef Image3DAction < imagem.actions.CurrentImageAction
% Superclass for actions that require a 3D image.
%
%   Class Image3DAction
%
%   Example
%   Image3DAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-11-15,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = Image3DAction(varargin)
    % Constructor for Image3DAction class
    obj = obj@imagem.actions.CurrentImageAction(varargin{:});
    end

end % end constructors


%% Methods
methods
    function b = isActivable(obj, frame)
        b = isActivable@imagem.actions.CurrentImageAction(obj, frame);
        if b
            b = is3dImage(currentImage(frame));
        end
    end
end % end methods

end % end classdef


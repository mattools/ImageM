classdef TimeLapseImageAction < imagem.actions.CurrentImageAction
% Superclass for actions that require a time-lapse image.
%
%   Class TimeLapseImageAction
%
%   Example
%   TimeLapseImageAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-02-20,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRAE - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = TimeLapseImageAction(varargin)
        % Constructor for TimeLapseImageAction class
        obj = obj@imagem.actions.CurrentImageAction(varargin{:});
    end

end % end constructors


%% Methods
methods
    function b = isActivable(obj, frame)
        b = isActivable@imagem.actions.CurrentImageAction(obj, frame);
        if b
            b = isTimeLapseImage(currentImage(frame));
        end
    end
end % end methods

end % end classdef


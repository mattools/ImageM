classdef ImageDisplayListener < handle
% Listener for changes of image display.
%
%   Class ImageDisplayListener
%
%   Example
%   ImageDisplayListener
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-11-18,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = ImageDisplayListener(varargin)
    % Constructor for ImageDislayListener class

    end

end % end constructors


%% Methods
methods
    onDisplayRangeChanged(obj, source, event)
    onCurrentSliceChanged(obj, source, event)
    onCurrentChannelChanged(obj, source, event)
end % end methods

end % end classdef


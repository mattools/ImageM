classdef Action < handle
% Base class for ImageM action classes.
%
%   output = Action(input)
%
%   Example
%   Action
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2019-09-18,    using Matlab 9.6.0.1072779 (R2019a)
% Copyright 2019 INRA - Cepia Software Platform.


%% Methods to overload
methods (Abstract)
    run(obj, frame)
end

%% Methods that can be overloaded
methods
    function b = isActivable(obj, viewer)
        b = true;
    end
end

end
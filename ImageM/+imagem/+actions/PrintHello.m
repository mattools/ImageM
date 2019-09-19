classdef PrintHello < imagem.gui.Action
% Simple demo action.
%
%   Simple class for demonstrating the use of action classes.
%
%   Example
%   SayHelloAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-03-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function this = PrintHello()
    end
end

methods
    function run(this, frame) %#ok<INUSD>
        disp('Hello!');
    end
end

end
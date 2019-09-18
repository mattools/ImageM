classdef Exit < imagem.gui.Action
% Close the application.
%
%   output = ExitAction(input)
%
%   Example
%   ExitAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-03-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function run(obj, frame) %#ok<INUSD>
        disp('quit...');
        exit(frame.Gui);
    end
end

end
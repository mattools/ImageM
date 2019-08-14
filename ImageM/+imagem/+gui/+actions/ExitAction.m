classdef ExitAction < imagem.gui.ImagemAction
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
    function obj = ExitAction(viewer, varargin)
        % calls the viewer constructor
        obj = obj@imagem.gui.ImagemAction(viewer, 'quit');
    end
end

methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        disp('quit...');
        exit(obj.Viewer.Gui);
    end
end

end
classdef SayHelloAction < imagem.gui.ImagemAction
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
    function this = SayHelloAction(viewer, varargin)
        % calls the parent constructor
        this = this@imagem.gui.ImagemAction(viewer, 'sayHello');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('Hello !');
    end
end

end
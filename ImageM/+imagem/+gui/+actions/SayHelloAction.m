classdef SayHelloAction < imagem.gui.ImagemAction
%SAYHELLOACTION  One-line description here, please.
%
%   Simple class for demonstrating the use of action classes.
%
%   Example
%   SayHelloAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-03-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function this = SayHelloAction(parent, varargin)
        % calls the parent constructor
        this = this@imagem.gui.ImagemAction(parent, 'sayHello');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD,MANU>
        disp('Hello !');
    end
end

end
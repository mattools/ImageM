classdef ExitAction < imagem.gui.ImagemAction
%EXITACTION Close the application
%
%   output = ExitAction(input)
%
%   Example
%   ExitAction
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
    function this = ExitAction(varargin)
        % calls the parent constructor
        this = this@imagem.gui.ImagemAction(varargin{:});
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('quit...');
        this.parent.gui.exit();
    end
end

end
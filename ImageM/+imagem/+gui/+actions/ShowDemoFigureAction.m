classdef ShowDemoFigureAction < imagem.gui.ImagemAction
%SHOWDEMOFIGUREACTION Show a demo image
%
%   output = ShowDemoFigureAction(input)
%
%   Example
%   ShowDemoFigureAction
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
    function this = ShowDemoFigureAction(parent, varargin)
        % calls the parent constructor
        this = this@imagem.gui.ImagemAction(parent, 'showCameraman');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        imagem.gui.ImagemImageFigure(this.parent.gui);
    end
end

end
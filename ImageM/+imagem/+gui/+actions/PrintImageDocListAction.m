classdef PrintImageDocListAction < imagem.gui.ImagemAction
%PRINTIMAGEDOCLISTACTION  One-line description here, please.
%
%   output = PrintImageDocListAction(input)
%
%   Example
%   PrintImageDocListAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-11-07,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.
 
methods
    function this = PrintImageDocListAction(varargin)
        % calls the parent constructor
        this = this@imagem.gui.ImagemAction(varargin{:});
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('print image list');
        
        % get handle to parent figure, and current doc
        viewer = this.parent;
        gui = viewer.gui;
        app = gui.app;

        docList = documentList(app);
        for i = 1:length(docList)
            doc = docList{i};
            disp(doc.image.name);
        end
    end
end

end
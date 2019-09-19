classdef PrintImageDocListAction < imagem.gui.ImagemAction
% Print the list of open documents.
%
%   output = PrintImageDocListAction(input)
%
%   Example
%   PrintImageDocListAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-11-07,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.
 
methods
    function obj = PrintImageDocListAction(viewer, varargin)
        % calls the parent constructor
        obj = obj@imagem.gui.ImagemAction(viewer, 'printImageDocList');
    end
end

methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        disp('print image list');
        
        % get handle to viewer figure, and current doc
        app = obj.Viewer.Gui.App;

        docList = getDocuments(app);
        for i = 1:length(docList)
            doc = docList{i};
            if ~isempty(doc.Image)
                disp(doc.Image.Name);
            end
        end
    end
end

end
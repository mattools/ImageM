classdef InvertImageAction < imagem.gui.ImagemAction
%INVERTIMAGEACTION  Invert the current image
%
%   output = InvertImageAction(input)
%
%   Example
%   InvertImageAction
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
    function this = InvertImageAction(varargin)
        % calls the parent constructor
        this = this@imagem.gui.ImagemAction(varargin{:});
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('Inverts the image');
        
        % get handle to figure
        h = src;
        while ~strcmp(get(h, 'type'), 'figure')
            h = get(h, 'parent');
        end
        
        % get gui and current doc
        viewer = get(h, 'userData');
        doc = viewer.doc;
        
        img2 = invert(doc.image);
        
        newDoc = imagem.app.ImagemDoc(img2);
        
        addDocument(this.gui.app, newDoc);
        imagem.gui.PlanarImageViewer(this.gui, newDoc);
    end
end

end
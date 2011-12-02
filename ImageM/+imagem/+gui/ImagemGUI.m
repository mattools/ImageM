classdef ImagemGUI < handle
%IMAGEMGUI GUI manager for the ImageM application
%
%   output = ImagemGUI(input)
%
%   Example
%   ImagemGUI
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-03-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

%% Properties
properties
    % application
    app;
    
end 

%% Constructor
methods
    function this = ImagemGUI(appli, varargin)
        % IMAGEM constructor
        %
        % IM = ImageM(APP)
        % where APP is an instance of ImagemApp
        %
        
        this.app = appli;
        
    end % constructor 

end % construction function


%% General methods
methods
    function addImageDocument(this, image)
        % Create a new document from image, add it to app, and display img
        
        % creates new instance of ImageDoc
        doc = imagem.app.ImagemDoc(image);
        
        % add ImageDoc to the application
        addDocument(this.app, doc);
        
        % creates a display for the new image
        view = imagem.gui.PlanarImageViewer(this, doc);
        addView(doc, view);
        
    end
    
    function exit(this)
        % EXIT Close all viewers
        
%         disp('calling ImagemGUI.exit() method');
           
        docList = getDocuments(this.app);
        for d = 1:length(docList)
            doc = docList{d};
%             disp(['closing doc: ' doc.image.name]);
            
            views = getViews(doc);
            for v = 1:length(views)
                view = views{v};
                removeView(doc, view);
                close(view);
            end
        
        end
    end
    
end % general methods

end % classdef

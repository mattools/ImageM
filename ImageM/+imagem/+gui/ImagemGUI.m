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
        newDoc = imagem.app.ImagemDoc(image);
        
        % add ImageDoc to the application
        addDocument(this.app, newDoc);
        
        % creates a display for the new image
        imagem.gui.PlanarImageViewer(this, newDoc);
        
    end
    
    function exit(this)
        % EXIT Close all frame
    end
    
end % general methods

end % classdef

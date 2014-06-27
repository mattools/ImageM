classdef OpenDemoImageAction < imagem.gui.ImagemAction
%OPENDEMOIMAGEACTION Open and display one of the demo images
%
%   Class OpenDemoImageAction
%
%   Example
%   OpenDemoImageAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-11-07,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    imageName;
end % end properties


%% Constructor
methods
    function this = OpenDemoImageAction(viewer, name, imageName)
    % Constructor for OpenDemoImageAction class
        
        % calls the parent constructor
        this = this@imagem.gui.ImagemAction(viewer, name);
        
        % initialize image name
        this.imageName = imageName;
    end

end % end constructors


%% Methods
methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        gui = viewer.gui;
        
        % read the demo image
        img = Image.read(this.imageName);
        
        % add image to application, and create new display
        doc = addImageDocument(gui, img);
        
        tag = doc.tag;
                
        % history
        string = sprintf('%s = Image.read(''%s'');\n', tag, this.imageName);
        addToHistory(gui.app, string);        
    end
end % end methods

end % end classdef


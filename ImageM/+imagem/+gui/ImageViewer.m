classdef ImageViewer < handle
% Base class for all viewers (figures) containing images.
%
%   Class ImageViewer
%
%   Usage
%   % in sub-class constructor:
%   obj = obj@imagem.gui.ImageViewer(gui, doc);
%
%   Example
%     classdef PlanarImageViewer < imagem.gui.ImageViewer
%     methods
%         function obj = PlanarImageViewer(gui, doc)
%             % create new viewer by calling ImageViewer constructor
%             obj = obj@imagem.gui.ImageViewer(gui, doc);
%         end
%     end % end methods
%     end % end classdef
%
%   See also
%     PlanarImageViewer
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-08-21,    using Matlab 9.6.0.1072779 (R2019a)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    % Reference to the main GUI.
    Gui;
   
    % List of handles to the various gui items.
    Handles;
    
    % The image document.
    Doc;
    
end % end properties

%% Abstract methods
methods (Abstract)
    % Refresh display of current image.
    updateDisplay(obj);
    
    % Set up title of the figure, depending on image info.
    updateTitle(obj);
end

%% Constructor
methods
    function obj = ImageViewer(gui, doc)
    % Constructor for ImageViewer class
    %
    %  Usage
    %  % call constructor of super class
    %  obj = obj@imagem.gui.ImageViewer(gui, doc);
    %
        obj.Gui = gui;
        obj.Doc = doc;
        obj.Handles = struct();
    end

end % end constructors


%% Methods
methods
end % end methods

end % end classdef


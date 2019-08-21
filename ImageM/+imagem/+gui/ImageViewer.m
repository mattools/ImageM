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

    function updateTitle(obj)
        % Set up title of the figure, depending on image size and type.
        
        % small checkup, because function can be called before figure was
        % initialised
        if ~isfield(obj.Handles, 'Figure')
            return;
        end
        
        if isempty(obj.Doc) || isempty(obj.Doc.Image)
            return;
        end
        
        % setup name to display
        imgName = imageNameForDisplay(obj.Doc);
    
        % determine the type to display:
        % * data type for intensity / grayscale image
        % * type of image otherwise
        switch obj.Doc.Image.Type
            case 'grayscale'
                type = class(obj.Doc.Image.Data);
            case 'color'
                type = 'color';
            otherwise
                type = obj.Doc.Image.Type;
        end
        
        % compute image zoom
        zoom = currentZoomLevel(obj);
        
        % compute new title string
        nd = ndims(obj.Doc.Image);
        sizePattern = ['%d' repmat(' x %d', 1, nd-1)];
        sizeString = sprintf(sizePattern, size(obj.Doc.Image));
        zoomString = sprintf('%g:%g', max(1, zoom), max(1, 1/zoom));
        titlePattern = '%s [%s %s] - %s - ImageM';
        titleString = sprintf(titlePattern, imgName, sizeString, type, zoomString);
%         titlePattern = 'ImageM - %s [%d x %d %s] - %g:%g';
%         titleString = sprintf(titlePattern, imgName, ...
%             size(obj.Doc.Image), type, max(1, zoom), max(1, 1/zoom));
%         % compute new title string 
%         titlePattern = 'ImageM - %s [%d x %d x %d %s] - %g:%g';
%         titleString = sprintf(titlePattern, imgName, ...
%             size(obj.Doc.Image), type, max(1, zoom), max(1, 1/zoom));

        % display new title
        set(obj.Handles.Figure, 'Name', titleString);
    end
    
    function z = currentZoomLevel(obj) %#ok<MANU>
        % Default method for returning zoom level (default value is 1).
        z = 1;
    end
end % end methods

end % end classdef


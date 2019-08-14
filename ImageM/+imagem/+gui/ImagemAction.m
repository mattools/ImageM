classdef ImagemAction < handle
% Base class for ImageM action classes.
%
%   output = ImagemAction(input)
%
%   Example
%    ImagemAction
%
%   See also
%     imagem.gui.ImagemTool
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-03-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties definition

properties
    % the parent GUI, that can be ImageViewer, TableViewer...
    Viewer;
    
    % the name of obj action, that should be unique for all actions
    Name;
end


%% Constructor

methods
    function obj = ImagemAction(viewer, name)
        obj.Viewer = viewer;
        obj.Name = name;
    end
end


%% Methods to be overlaid

methods (Abstract)
    actionPerformed(obj, src, event)
end

methods
    function b = isActivable(obj) %#ok<MANU>
        b = true;
    end
end


%% Utility methods
%
% Some of them are simply shortcuts that dispatch the processing to other
% classes.

methods
    function varargout = addImageDocument(obj, image, varargin)
        % Create a new frame for the image based on the current viewer.
        if nargin <= 1
            doc = addImageDocument(obj.Viewer.Gui, image, varargin{:});
            varargout = {doc};
        else
            [doc, viewer] = addImageDocument(obj.Viewer.Gui, image, varargin{:});
            varargout = {doc, viewer};
        end
    end
    
    function addToHistory(obj, string)
        addToHistory(obj.Viewer.Gui.App, string);
    end
end

end
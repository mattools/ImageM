classdef CurrentImageAction < imagem.gui.actions.CurrentDocAction
% Superclass for actions that require a current image.
%
%   output = CurrentImageAction(input)
%
%   Example
%   CurrentImageAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Constructors
methods
    function obj = CurrentImageAction(viewer, varargin)
        % calls the parent constructor
        obj = obj@imagem.gui.actions.CurrentDocAction(viewer, varargin{:});
    end
end


%% New methods
methods
    function img = currentImage(obj)
        % Return the current image (may be empty)
        
        img = [];
        doc = obj.Viewer.Doc;
        if ~isempty(doc)
            img = doc.Image;
        end
    end
    
    function updatePreviewImage(obj, image)
        % Update preview image of document and refresh display
        
        doc = currentDoc(obj);
        doc.PreviewImage = image;
        updateDisplay(obj.Viewer);
    end
    
    function clearPreviewImage(obj)
        % Clear preview image of document and refresh display
        
        doc = currentDoc(obj);
        doc.PreviewImage = [];
        updateDisplay(obj.Viewer);
    end
end


%% Specialisation of ImageMAction superclass
methods
    function b = isActivable(obj)
        b = isActivable@imagem.gui.actions.CurrentDocAction(obj);
        if b
            b = ~isempty(currentImage(obj));
        end
    end
end

end
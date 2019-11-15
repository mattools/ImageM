classdef Tool < imagem.gui.events.MouseListener
% Base class for interactive (mouse management) tools.
%
%   ImagemTool is an abstract class that serves as basis for developping
%   more sophisticated classes. It encapsulates functions for interpreting
%   mouse button events and mouse motion events.
%
%   An ImageM Tool depends on a display, usually an ImageViewer.
%
%   Most ImageM Tool are also defined by their current "state". The state
%   will change the way the mouse events are processed.
%
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-11-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

%% Properties
properties
    % the parent GUI, that can be ImageViewer or other type of frame
    Viewer;
    
    % the name of obj tool, that should be unique for all actions
    Name;
end

%% Constructor
methods
    function obj = Tool(viewer, name)
        % Creates a new tool using parent viewer and a name
        obj.Viewer = viewer;
        obj.Name = name;
    end % constructor 

end % construction function

%% General methods
methods
    function select(obj) %#ok<*MANU>
    end
    
    function deselect(obj)
    end
    
    function onMouseButtonPressed(obj, hObject, eventdata) %#ok<INUSD>
    end
    
    function onMouseButtonReleased(obj, hObject, eventdata) %#ok<INUSD>
    end
    
    function onMouseMoved(obj, hObject, eventdata) %#ok<INUSD>
    end
    
end % general methods

methods
    function b = isActivable(obj)
        doc = currentDoc(obj.Viewer);
        b = ~isempty(doc) && ~isempty(doc.Image);
    end
end


%% Utility methods
methods
    function doc = currentDoc(obj)
        doc = obj.Viewer.Doc;
    end
end

end % classdef

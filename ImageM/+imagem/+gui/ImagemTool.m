classdef ImagemTool < imagem.gui.events.MouseListener
%IMAGEMTOOL Base class for interactive (mouse management) tools
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
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-11-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

%% Properties
properties
    % the parent GUI, that can be ImageDisplay, TableDisplay...
    parent;
    
    % the name of this tool, that should be unique for all actions
    name;
end

%% Constructor
methods
    function this = ImagemTool(parent, name)
        % Creates a new tool using parent gui and a name
        this.parent = parent;
        this.name = name;
    end % constructor 

end % construction function

%% General methods
methods
    function select(this) %#ok<*MANU>
    end
    
    function deselect(this)
    end
    
    function onMouseButtonPressed(this, hObject, eventdata) %#ok<INUSD>
    end
    
    function onMouseButtonReleased(this, hObject, eventdata) %#ok<INUSD>
    end
    
    function onMouseMoved(this, hObject, eventdata) %#ok<INUSD>
    end
    
end % general methods


methods
    function b = isActivable(this)
        b = true;
    end
end

end % classdef

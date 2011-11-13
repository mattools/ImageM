classdef ImagemTool < imagem.gui.events.MouseListener
%IMAGEMTOOL Base class for interactive (mouse management) tools
%
%   output = ImagemTool(input)
%
%   Example
%   ImagemTool
%
%   See also
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

end % classdef

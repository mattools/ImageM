classdef PrintCurrentPointTool < imagem.gui.ImagemTool
%PRINTCURRENTPOINTTOOL  One-line description here, please.
%
%   output = PrintCurrentPointTool(input)
%
%   Example
%   PrintCurrentPointTool
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-11-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Constructor
methods
    function this = PrintCurrentPointTool(viewer, varargin)
        % Creates a new tool using parent gui and a name
         this = this@imagem.gui.ImagemTool(viewer, 'printCurrentPoint');
    end % constructor 

end % construction function

%% General methods
methods
    function select(this) %#ok<*MANU>
    end
    
    function deselect(this)
    end
    
    function onMouseButtonPressed(this, hObject, eventdata) %#ok<INUSD>
        pos = get(this.viewer.handles.imageAxis, 'CurrentPoint');
        fprintf('%f %f\n', pos(1, 1:2));
    end
    
    function onMouseButtonReleased(this, hObject, eventdata) %#ok<INUSD>
    end
    
    function onMouseMoved(this, hObject, eventdata) %#ok<INUSD>
    end
    
end % general methods

end
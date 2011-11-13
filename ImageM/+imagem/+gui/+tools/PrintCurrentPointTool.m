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
    function this = PrintCurrentPointTool(varargin)
        % Creates a new tool using parent gui and a name
         this = this@imagem.gui.ImagemTool(varargin{:});
    end % constructor 

end % construction function

% % Static constructor
% methods (Static)
%     function res = create(parent)
%         res = imagem.gui.tools.PrintCurrentPointTool(parent, 'printCurrentPoint');
%     end
% end

%% General methods
methods
    function select(this) %#ok<*MANU>
%         disp('select tool PrintCurrentPoint');
    end
    
    function deselect(this)
%         disp('de-select tool PrintCurrentPoint');
    end
    
    function onMouseButtonPressed(this, hObject, eventdata) %#ok<INUSD>
%         disp('PrintCurrentPoint: mouse button pressed');
        pos = get(this.parent.handles.imageAxis, 'CurrentPoint');
        fprintf('%f %f\n', pos(1, 1:2));
    end
    
    function onMouseButtonReleased(this, hObject, eventdata) %#ok<INUSD>
%         disp('PrintCurrentPoint: mouse button released');
    end
    
    function onMouseMoved(this, hObject, eventdata) %#ok<INUSD>
%         disp('PrintCurrentPoint: mouse moved');
    end
    
end % general methods

end
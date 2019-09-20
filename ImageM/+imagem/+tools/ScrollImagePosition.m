classdef ScrollImagePosition < imagem.gui.Tool
% Move the position of the viewbox.
%
%   Class SelectLineSegmentTool
%
%   Example
%   SelectLineSegmentTool
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    Pos0;
    
    LineHandle;
        
end % end properties


%% Constructor
methods
    function obj = ScrollImagePosition(viewer, varargin)
        % Constructor for SelectLineSegmentTool class
        obj = obj@imagem.gui.Tool(viewer, 'scrollImagePosition');
    end

end % end constructors


%% ImagemTool Methods
methods
    function select(obj) %#ok<*MANU>
%         disp('scrool image position');
        obj.Pos0 = [];
    end
    
    function deselect(obj)
    end
    
    function onMouseButtonPressed(obj, hObject, eventdata) %#ok<INUSD>
        
%         disp('click!');
        
        % get position of current point
        ax = obj.Viewer.Handles.ImageAxis;
        pos = get(ax, 'CurrentPoint');
        pos = pos(1,:);

        obj.Pos0 = pos;
    end

    function onMouseButtonReleased(obj, hObject, eventdata) %#ok<INUSD>
        
        % clear position -> stop dragging
        obj.Pos0 = [];
    end

    function onMouseMoved(obj, hObject, eventdata) %#ok<INUSD>
        
        if isempty(obj.Pos0)
            return;
        end

        % determine the line current end point
        ax = obj.Viewer.Handles.ImageAxis;
        pos = get(ax, 'CurrentPoint');
        pos = pos(1,:);
        
        shift = obj.Pos0 - pos;
        if sum(shift == 0) == 2
            return;
        end
%         fprintf('shift: %f, %f\n', shift(1), shift(2));
        
        api = iptgetapi(obj.Viewer.Handles.ScrollPanel);
        loc0 = api.getVisibleLocation();
        newLoc = loc0 + shift(1:2);
        api.setVisibleLocation(newLoc);
        
        obj.Pos0 = pos;
        
    end
    
    
end % end methods

end % end classdef


classdef ScrollImagePositionTool < imagem.gui.ImagemTool
%LINEPROFILETOOL  Move the position of the viewbox
%
%   Class SelectLineSegmentTool
%
%   Example
%   SelectLineSegmentTool
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-03-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    pos0;
    
    lineHandle;
        
end % end properties


%% Constructor
methods
    function this = ScrollImagePositionTool(viewer, varargin)
        % Constructor for SelectLineSegmentTool class
        this = this@imagem.gui.ImagemTool(viewer, 'scrollImagePosition');
    end

end % end constructors


%% ImagemTool Methods
methods
    function select(this) %#ok<*MANU>
        disp('scrool image position');
        this.pos0 = [];
    end
    
    function deselect(this)
    end
    
    function onMouseButtonPressed(this, hObject, eventdata) %#ok<INUSD>
        
        disp('click!');
        
        % get position of current point
        ax = this.viewer.handles.imageAxis;
        pos = get(ax, 'CurrentPoint');
        pos = pos(1,:);

        this.pos0 = pos;
    end

    function onMouseButtonReleased(this, hObject, eventdata) %#ok<INUSD>
        
        % clear position -> stop dragging
        this.pos0 = [];
    end

    function onMouseMoved(this, hObject, eventdata) %#ok<INUSD>
        
        if isempty(this.pos0)
            return;
        end

        % determine the line current end point
        ax = this.viewer.handles.imageAxis;
        pos = get(ax, 'CurrentPoint');
        pos = pos(1,:);
        
        shift = pos - this.pos0;
%         fprintf('shift: %f, %f\n', shift(1), shift(2));
        
        api = iptgetapi(this.viewer.handles.scrollPanel);
        loc0 = api.getVisibleLocation();
        newLoc = loc0 + shift(1:2);
        api.setVisibleLocation(newLoc);
        
        this.pos0 = pos;
        
    end
    
    
end % end methods

end % end classdef


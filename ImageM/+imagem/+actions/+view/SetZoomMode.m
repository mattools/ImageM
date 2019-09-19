classdef SetZoomMode < imagem.actions.CurrentImageAction
% Set the zoom mode for current frame (fixed or adjust)
%
%   output = ZoomSetModeAction(input)
%
%   Example
%   ZoomSetModeAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    ZoomMode = 'adjust';
    
    MenuItem;
    ActionGroup;
end

methods
    function obj = SetZoomMode(mode)
        obj.ZoomMode = mode;
    end
end

methods
    function run(obj, frame) %#ok<INUSD>
        
        % set up new zoom value
        setZoomMode(frame, obj.ZoomMode);
        
        if ~isempty(obj.ActionGroup)
            for iAction = 1:length(obj.ActionGroup)
                action = obj.ActionGroup(iAction);
                uncheckMenuItem(action);
            end
        end
        
        if ~isempty(obj.MenuItem)
            set(obj.MenuItem, 'Checked', 'On');
        end
    end
    
    
    function setMenuItem(obj, item)
        obj.MenuItem = item;
    end
    
    function setActionGroup(obj, group)
        obj.ActionGroup = group;
    end
    
    function uncheckMenuItem(obj)
        if ~isempty(obj.MenuItem)
            set(obj.MenuItem, 'Checked', 'Off');
        end
    end
end

end
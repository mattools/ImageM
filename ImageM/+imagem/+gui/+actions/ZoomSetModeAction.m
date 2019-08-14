classdef ZoomSetModeAction < imagem.gui.actions.CurrentImageAction
% Zoom in the current figure.
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
    function obj = ZoomSetModeAction(viewer, mode)
        % calls the parent constructor
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, 'zoomSetMode');
        obj.ZoomMode = mode;
    end
end

methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        
        % get handle to viewer figure
        viewer = obj.Viewer;
        
        % set up new zoom value
        setZoomMode(viewer, obj.ZoomMode);
        
        if ~isempty(obj.ActionGroup)
            for iAction = 1:length(obj.ActionGroup)
                action = obj.ActionGroup(iAction);
                uncheckMenuItem(action);
            end
        end
        
        if ~isempty(obj.MenuItem)
            set(obj.MenuItem, 'Checked', 'on');
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
            set(obj.MenuItem, 'Checked', 'off');
        end
    end
end

end
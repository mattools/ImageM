classdef ZoomSetModeAction < imagem.gui.actions.CurrentImageAction
%ZoomSetModeAction Zoom in the current figure
%
%   output = ZoomSetModeAction(input)
%
%   Example
%   ZoomSetModeAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    zoomMode = 'adjust';
    
    menuItem;
    actionGroup;
end

methods
    function this = ZoomSetModeAction(viewer, mode)
        % calls the parent constructor
        this = this@imagem.gui.actions.CurrentImageAction(viewer, 'zoomSetMode');
        this.zoomMode = mode;
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        
        % get handle to viewer figure
        viewer = this.viewer;
        
        % set up new zoom value
        setZoomMode(viewer, this.zoomMode);
        
        if ~isempty(this.actionGroup)
            for iAction = 1:length(this.actionGroup)
                action = this.actionGroup(iAction);
                uncheckMenuItem(action);
            end
        end
        
        if ~isempty(this.menuItem)
            set(this.menuItem, 'Checked', 'on');
        end
    end
    
    
    function setMenuItem(this, item)
        this.menuItem = item;
    end
    
    function setActionGroup(this, group)
        this.actionGroup = group;
    end
    
    function uncheckMenuItem(this)
        if ~isempty(this.menuItem)
            set(this.menuItem, 'Checked', 'off');
        end
    end
end

end
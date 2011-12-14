classdef SelectToolAction < imagem.gui.ImagemAction
%SELECTTOOLACTION  One-line description here, please.
%
%   output = SelectToolAction(input)
%
%   Example
%   SelectToolAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-11-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    % the tool to select
    tool;
end

methods
    function this = SelectToolAction(parent, tool)
        % calls the parent constructor
        name = ['selectTool-' tool.name];
        this = this@imagem.gui.ImagemAction(parent, name);
        this.tool = tool;
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp(['select another tool: ' this.tool.name]);
        
        this.tool.parent = this.parent;
        
        if ~isempty(this.parent.currentTool)
            deselect(this.parent.currentTool);
            removeMouseListener(this.parent, this.parent.currentTool);
        end
        
        this.parent.currentTool = this.tool;
        
        if ~isempty(this.tool)
            select(this.tool);
            addMouseListener(this.parent, this.tool);
        end
    end
end

methods
    function b = isActivable(this)
        b = isActivable(this.tool);
    end
end

end
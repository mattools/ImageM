classdef ImagemAction < handle
%IMAGEMACTION  One-line description here, please.
%
%   output = ImagemAction(input)
%
%   Example
%   ImagemAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-03-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    % the parent GUI, that can be ImageViewer, TableViewer...
    viewer;
    
    % the name of this action, that should be unique for all actions
    name;
end

methods
    function this = ImagemAction(viewer, name)
        this.viewer = viewer;
        this.name = name;
    end
end

methods (Abstract)
    actionPerformed(this, src, event)
end

methods
    function b = isActivable(this) %#ok<MANU>
        b = true;
    end
end

end
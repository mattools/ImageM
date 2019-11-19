classdef CurrentTableAction < imagem.gui.Action
% Superclass for actions that require a current table.
%
%   output = CurrentTableAction(input)
%
%   Example
%   CurrentImageAction
%
%   See also
%     ImgemAction, CurrentImageAction
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Constructors
methods
    function obj = CurrentTableAction()
    end
end

%% Specialisation of ImageMAction superclass
methods
    function b = isActivable(obj, frame) %#ok<INUSL>
        b = ~isempty(frame.Doc);
        if b
            b = isa(frame.Doc, 'imagem.app.TableDoc');
        end
    end
end

end
classdef CurrentImageAction < imagem.actions.CurrentDocAction
% Superclass for actions that require a current image.
%
%   output = CurrentImageAction(input)
%
%   Example
%   CurrentImageAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Constructors
methods
    function obj = CurrentImageAction()
    end
end


%% New methods
methods
end


%% Specialisation of ImageMAction superclass
methods
    function b = isActivable(obj, frame)
        b = isActivable@imagem.actions.CurrentDocAction(obj, frame);
        if b
            b = isa(frame.Doc, 'imagem.app.ImageDoc');
        end
        if b
            b = ~isempty(currentImage(frame));
        end
    end
end

end
classdef FlipImage < imagem.actions.CurrentImageAction
% Flip current image.
%
%   Class FlipImageAction
%
%   Example
%   FlipImageAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-05-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
    Axis = 3;
end % end properties


%% Constructor
methods
    function obj = FlipImage(axis)
        if nargin > 0
            obj.Axis = axis;
        end
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSD>
         
        % flip image
        doc = currentDoc(frame);
        res = flip(doc.Image, obj.Axis);
        
        % add image to application, and create new display
        newDoc = addImageDocument(frame, res);
        
        % add history
        string = sprintf('%s = flip(%s, %d);\n', ...
             newDoc.Tag, doc.Tag, obj.Axis);
        addToHistory(frame, string);
    end
end

end % end classdef


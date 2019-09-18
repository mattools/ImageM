classdef RotateImage90 < imagem.actions.CurrentImageAction
% Rotate current image by 90 degrees.
%
%   Class RotateImage90
%
%   Example
%   RotateImage90
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
    Number = 1;
end % end properties


%% Constructor
methods
    function obj = RotateImage90(varargin)
        if ~isempty(varargin)
            obj.Number = varargin{1};
        end
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSD>
        
        % get handle to current doc
        doc = currentDoc(frame);
        
        % flip image
        res = rotate90(doc.Image, obj.Number);
        
        % add image to application, and create new display
        newDoc = addImageDocument(frame, res);
        
        % history
        string = sprintf('%s = rotate90(%s, %d);\n', ...
            newDoc.Tag, doc.Tag, obj.Number);
        addToHistory(frame, string);
    end
end

end % end classdef


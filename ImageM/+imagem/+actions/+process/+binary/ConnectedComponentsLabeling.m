classdef ConnectedComponentsLabeling < imagem.actions.BinaryImageAction
% Connected Components Labeling of a binary image.
%
%   Class ConnectedComponentsLabeling
%
%   Example
%   ConnectedComponentsLabeling
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = ConnectedComponentsLabeling()
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        
        % get handle to current doc
        doc = currentDoc(frame);
        
        lbl = componentLabeling(doc.Image);
        
        newDoc = addImageDocument(frame, lbl);
        
        % history
        string = sprintf('%s = componentLabeling(%s);\n', newDoc.Tag, doc.Tag);
        addToHistory(frame, string);
    end
    
end % end methods

end % end classdef


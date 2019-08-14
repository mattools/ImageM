classdef LabelBinaryImageAction < imagem.gui.actions.BinaryImageAction
% Connected Components Labeling of binary image
%
%   Class LabelBinaryImageAction
%
%   Example
%   LabelBinaryImageAction
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
    function obj = LabelBinaryImageAction(viewer)
    % Constructor for LabelBinaryImageAction class
        obj = obj@imagem.gui.actions.BinaryImageAction(viewer, 'labelBinaryImage');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        
        % get handle to current doc
        doc = currentDoc(obj);
        
        lbl = labeling(doc.Image);
        
        newDoc = addImageDocument(obj, lbl);
        
        % history
        string = sprintf('%s = labeling(%s);\n', newDoc.Tag, doc.Tag);
        addToHistory(obj, string);
    end
    
end % end methods

end % end classdef


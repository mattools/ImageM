classdef LabelBinaryImageAction < imagem.gui.actions.CurrentImageAction
%LABELBINARYIMAGEACTION  One-line description here, please.
%
%   Class LabelBinaryImageAction
%
%   Example
%   LabelBinaryImageAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function this = LabelBinaryImageAction(parent)
    % Constructor for LabelBinaryImageAction class
        this = this@imagem.gui.actions.CurrentImageAction(parent, 'labelBinaryImage');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('apply labelling to current image');
        
        % get handle to parent figure, and current doc
        viewer = this.parent;
        doc = viewer.doc;
        
        lbl = labeling(doc.image);
        
        addImageDocument(viewer.gui, lbl);
    end
    
end % end methods

methods
    function b = isActivable(this)
        doc = this.parent.doc;
        b = ~isempty(doc.image) && isBinaryImage(doc.image);
    end
end

end % end classdef


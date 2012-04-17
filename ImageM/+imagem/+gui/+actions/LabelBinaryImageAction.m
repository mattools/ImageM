classdef LabelBinaryImageAction < imagem.gui.actions.BinaryImageAction
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
    function this = LabelBinaryImageAction(viewer)
    % Constructor for LabelBinaryImageAction class
        this = this@imagem.gui.actions.BinaryImageAction(viewer, 'labelBinaryImage');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('apply labelling to current image');
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;
        
        lbl = labeling(doc.image);
        
        addImageDocument(viewer.gui, lbl);
    end
    
end % end methods

end % end classdef


classdef ImageThresholdAction < imagem.gui.ImagemAction
%IMAGETHRESHOLDACTION Apply a threshold operation to current image
%
%   output = ImageThresholdAction(input)
%
%   Example
%   ImageThresholdAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-11-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function this = ImageThresholdAction(varargin)
        % calls the parent constructor
        this = this@imagem.gui.ImagemAction(varargin{:});
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('apply Threshold to current image');
        
        % get handle to parent figure, and current doc
        viewer = this.parent;
        doc = viewer.doc;
        
        if ~isScalar(doc.image)
            warning('ImageM:WrongImageType', ...
                'Threshold can be applied only on scalar images');
            return;
        end
        
        prompt = {'Enter image threshold:'};
        dlg_title = 'Image Threshold';
        num_lines = 1;
        def = {'50'};
        answer = inputdlg(prompt, dlg_title, num_lines, def);
        
        if isempty(answer)
            return;
        end

        value = str2double(answer{1});
        if ~isfinite(value)
            return;
        end
        
        % apply 'gradient' operation
        img2 = doc.image > value;
        
        % add image to application, and create new display
        addImageDocument(viewer.gui, img2);
    end
end

end
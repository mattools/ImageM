classdef ChangeImageLutAction < imagem.gui.actions.CurrentImageAction
%CHANGEIMAGELUTACTION  Change color palette of current image document
%
%   output = ChangeImageLutAction(input)
%
%   Example
%   ChangeImageLutAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    lut = [];
    lutName;
end

methods
    function this = ChangeImageLutAction(viewer, lutName, lutValues)
        % calls the parent constructor
        this = this@imagem.gui.actions.CurrentImageAction(viewer, 'changeImageLut');
        this.lutName = lutName;
        if nargin > 2
            this.lut = lutValues;
        end
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp(['Change Image LUT to ' this.lutName]);
        
        % get handle to viewer figure, and current doc
        viewer = this.viewer;
        doc = viewer.doc;

        if strcmp(this.lutName, 'none')
            doc.lut = [];
        else
            if isempty(this.lut)
                this.lut = computeLutFromName(this);
            end
            doc.lut = this.lut;
        end
        
        doc.lutName = this.lutName;
        doc.modified = true;
        
        updateDisplay(this.viewer);
    end
    
    function lut = computeLutFromName(this)
        
        % get LUT name
        name = this.lutName;
        
        % compute number of grayscale levels. 256 by default, but use label
        % number for label images
        nGrays = 256;
        img = this.viewer.doc.image;
        if isLabelImage(img)
            nGrays = double(round(max(img)));
        end
        
        % create the appropriate LUT array depending on LUT name and on
        % number of levels
        if strcmp(name, 'inverted')
            lut = repmat(((nGrays-1):-1:0)', 1, 3) / (nGrays-1);
            
        elseif strcmp(name, 'blue-gray-red')
            lut = gray(nGrays);
            lut(1,:) = [0 0 1];
            lut(end,:) = [1 0 0];
            
        elseif strcmp(name, 'colorcube')
            map = colorcube(double(nGrays) + 2);
            lut = [0 0 0; map(sum(map==0, 2)~=3 & sum(map==1, 2)~=3, :)];
            
        elseif strcmp(name, 'red')
            lut = gray(nGrays);
            lut(:, 2:3) = 0;
            
        elseif strcmp(name, 'green')
            lut = gray(nGrays);
            lut(:, [1 3]) = 0;
            
        elseif strcmp(name, 'blue')
            lut = gray(nGrays);
            lut(:, 1:2) = 0;
            
        elseif strcmp(name, 'yellow')
            lut = gray(nGrays);
            lut(:, 3) = 0;
            
        elseif strcmp(name, 'cyan')
            lut = gray(nGrays);
            lut(:, 1) = 0;
            
        elseif strcmp(name, 'magenta')
            lut = gray(nGrays);
            lut(:, 2) = 0;
            
        else
            lut = feval(name, nGrays);
        end

    end
end

methods
    function b = isActivable(this)
        doc = this.viewer.doc;
        b = ~isempty(doc) && ~isempty(doc.image) && ~isColorImage(doc.image);
    end
end

end

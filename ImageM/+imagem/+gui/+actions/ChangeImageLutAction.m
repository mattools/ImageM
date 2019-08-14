classdef ChangeImageLutAction < imagem.gui.actions.CurrentImageAction
% Change Look-Up Table of current image document.
%
%   output = ChangeImageLutAction(input)
%
%   Example
%   ChangeImageLutAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    Lut = [];
    LutName;
end

methods
    function obj = ChangeImageLutAction(viewer, lutName, lutValues)
        % calls the parent constructor
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, 'changeImageLut');
        obj.LutName = lutName;
        if nargin > 2
            obj.Lut = lutValues;
        end
    end
end

methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        disp(['Change Image LUT to ' obj.LutName]);
        
        % get handle to viewer figure, and current doc
        viewer = obj.Viewer;
        doc = viewer.Doc;

        if strcmp(obj.LutName, 'none')
            doc.Lut = [];
        else
            if isempty(obj.Lut)
                obj.Lut = computeLutFromName(obj);
            end
            doc.Lut = obj.Lut;
        end
        
        doc.LutName = obj.LutName;
        doc.Modified = true;
        
        updateDisplay(obj.Viewer);
    end
    
    function lut = computeLutFromName(obj)
        
        % get LUT name
        name = obj.LutName;
        
        % compute number of grayscale levels. 256 by default, but use label
        % number for label images
        nGrays = 256;
        img = obj.Viewer.Doc.Image;
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
    function b = isActivable(obj)
        doc = obj.Viewer.Doc;
        b = ~isempty(doc) && ~isempty(doc.Image) && ~isColorImage(doc.Image);
    end
end

end

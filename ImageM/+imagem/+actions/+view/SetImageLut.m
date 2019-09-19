classdef SetImageLut < imagem.actions.CurrentImageAction
% Change Look-Up Table of current image document.
%
%   output = SetImageLut(input)
%
%   Example
%   SetImageLut
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

properties
    LutName;
    Lut = [];
end

methods
    function obj = SetImageLut(lutName, lutValues)
        % calls the parent constructor
        obj = obj@imagem.actions.CurrentImageAction();

        obj.LutName = lutName;
        if nargin > 2
            obj.Lut = lutValues;
        end
    end
end

methods
    function run(obj, frame) %#ok<INUSD>
        disp(['Change Image LUT to ' obj.LutName]);
        
        % get handle to current doc
        doc = frame.Doc;

        % compute number of grayscale levels. 256 by default, but use label
        % number for label images
        nValues = 256;
        img = doc.Image;
        if isLabelImage(img)
            nValues = double(round(max(img)));
        end
        
        
        if strcmp(obj.LutName, 'none')
            doc.Lut = [];
        else
            if isempty(obj.Lut)
                obj.Lut = computeLutFromName(obj, nValues);
            end
            doc.Lut = obj.Lut;
        end
        
        doc.LutName = obj.LutName;
        doc.Modified = true;
        
        updateDisplay(frame);
    end
    
    function lut = computeLutFromName(obj, nValues)
        
        % get LUT name
        name = obj.LutName;
        
        % create the appropriate LUT array depending on LUT name and on
        % number of levels
        if strcmp(name, 'inverted')
            lut = repmat(((nValues-1):-1:0)', 1, 3) / (nValues-1);
            
        elseif strcmp(name, 'blue-gray-red')
            lut = gray(nValues);
            lut(1,:) = [0 0 1];
            lut(end,:) = [1 0 0];
            
        elseif strcmp(name, 'colorcube')
            map = colorcube(double(nValues) + 2);
            lut = [0 0 0; map(sum(map==0, 2)~=3 & sum(map==1, 2)~=3, :)];
            
        elseif strcmp(name, 'red')
            lut = gray(nValues);
            lut(:, 2:3) = 0;
            
        elseif strcmp(name, 'green')
            lut = gray(nValues);
            lut(:, [1 3]) = 0;
            
        elseif strcmp(name, 'blue')
            lut = gray(nValues);
            lut(:, 1:2) = 0;
            
        elseif strcmp(name, 'yellow')
            lut = gray(nValues);
            lut(:, 3) = 0;
            
        elseif strcmp(name, 'cyan')
            lut = gray(nValues);
            lut(:, 1) = 0;
            
        elseif strcmp(name, 'magenta')
            lut = gray(nValues);
            lut(:, 2) = 0;
            
        else
            lut = feval(name, nValues);
        end

    end
end

methods
    function b = isActivable(obj, frame) %#ok<INUSL>
        doc = frame.Doc;
        b = ~isempty(doc) && ~isempty(doc.Image) && ~isColorImage(doc.Image);
    end
end

end

classdef ShowCursorPositionTool < imagem.gui.ImagemTool
%SHOWCURSORPOSITIONTOOL  One-line description here, please.
%
%   output = ShowCursorPositionTool(input)
%
%   Example
%   ShowCursorPositionTool
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-11-21,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Constructor
methods
    function this = ShowCursorPositionTool(parent, varargin)
        % Creates a new tool using parent gui and a name
         this = this@imagem.gui.ImagemTool(parent, 'showCursorPosition');
    end % constructor 

end % construction function

%% General methods
methods
    function onMouseMoved(this, hObject, eventdata) %#ok<INUSD>

        point = get(this.parent.handles.imageAxis, 'CurrentPoint');
        coord = round(pointToIndex(this, point(1, 1:2)));
        
        doc = this.parent.doc;
        img = doc.image;
        
        % control on bounds of image
        if any(coord < 1) || any(coord > size(img, [1 2]))
            set(this.parent.handles.infoPanel, 'string', '');
            return;
        end
        
        % Display coordinates of clicked point
        if isCalibrated(img)
            % Display pixel + physical position
            locString = sprintf('(x,y) = (%d,%d) px = (%5.2f,%5.2f) %s', ...
                coord(1), coord(2), point(1), point(2), ...
                img.unitName);
        else
            % Display only pixel position
            locString = sprintf('(x,y) = (%d,%d) px', coord(1), coord(2));
        end
        
        % Display value of selected pixel
        if strcmp(img.type, 'color')
            % case of color pixel: values are red, green and blue
            rgb = img(coord(1), coord(2), :);
            valueString = sprintf('  RGB = (%d %d %d)', ...
                rgb(1), rgb(2), rgb(3));
            
        elseif strcmp(img.type, 'vector')
            % case of vector image: compute norm of the pixel
            values  = this.parent.doc.image(coord(1), coord(2), :);
            norm    = sqrt(sum(double(values(:)) .^ 2));
            valueString = sprintf('  value = %g', norm);
            
        else
            % case of a gray-scale pixel
            value = img(coord(1), coord(2));
            if ~isfloat(value)
                valueString = sprintf('  value = %3d', value);
            else
                valueString = sprintf('  value = %g', value);
            end
        end
        
        set(this.parent.handles.infoPanel, ...
            'string', [locString '  ' valueString]);
    end
    
    function index = pointToIndex(this, point)
        % Converts coordinates of a point in physical dimension to image index
        % First element is column index, second element is row index, both are
        % given in floating point and no rounding is performed.
        spacing = this.parent.doc.image.spacing(1:2);
        origin  = this.parent.doc.image.origin(1:2);
        index   = (point - origin) ./ spacing + 1;
    end
    
end % general methods

end
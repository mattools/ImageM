classdef ShowCursorPosition < imagem.gui.Tool
% Show position of mouse cursor in status bar.
%
%   output = ShowCursorPositionTool(input)
%
%   Example
%   ShowCursorPositionTool
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-11-21,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Constructor
methods
    function obj = ShowCursorPosition(viewer, varargin)
        % Creates a new tool using parent gui and a name
         obj = obj@imagem.gui.Tool(viewer, 'showCursorPosition');
    end % constructor 

end % construction function

%% General methods
methods
    function onMouseMoved(obj, hObject, eventdata) %#ok<INUSD>

        point = get(obj.Viewer.Handles.ImageAxis, 'CurrentPoint');
        point = point(1, 1:2);
        coord = round(pointToIndex(obj, point));
        
        doc = currentDoc(obj);
        img = doc.Image;
        
        % control on bounds of image
        if any(coord < 1) || any(coord > size(img, [1 2]))
            set(obj.Viewer.Handles.InfoPanel, 'string', '');
            return;
        end
        
        % Display coordinates of clicked point
        if isCalibrated(img)
            % Display pixel + physical position
            locString = sprintf('(x,y) = (%d,%d) px = (%5.2f,%5.2f) %s', ...
                coord(1), coord(2), point(1), point(2), ...
                img.UnitName);
        else
            % Display only pixel position
            locString = sprintf('(x,y) = (%d,%d) px', coord(1), coord(2));
        end
        
        if size(img, 3) > 1
            locString = [locString sprintf(' z=%d', obj.Viewer.SliceIndex)];
            img = slice(img, obj.Viewer.SliceIndex);
        end
        if size(img, 5) > 1
            locString = [locString sprintf(' t=%d', obj.Viewer.FrameIndex)];
            img = frame(img, obj.Viewer.FrameIndex);
        end
        
        % Display value of selected pixel
        if strcmp(img.Type, 'color')
            % case of color pixel: values are red, green and blue
            rgb = img(coord(1), coord(2), :);
            valueString = sprintf('  RGB = (%d %d %d)', ...
                rgb(1), rgb(2), rgb(3));
            
        elseif strcmp(img.Type, 'vector')
            % case of vector image: compute norm of the pixel
            values  = obj.Viewer.Doc.Image(coord(1), coord(2), :);
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
        
        set(obj.Viewer.Handles.InfoPanel, ...
            'string', [locString '  ' valueString]);
    end
    
    function index = pointToIndex(obj, point)
        % Converts coordinates of a point in physical dimension to image index
        % First element is column index, second element is row index, both are
        % given in floating point and no rounding is performed.
        doc = currentDoc(obj);
        img = doc.Image;
        spacing = img.Spacing(1:2);
        origin  = img.Origin(1:2);
        index   = (point - origin) ./ spacing + 1;
    end
    
end % general methods

end
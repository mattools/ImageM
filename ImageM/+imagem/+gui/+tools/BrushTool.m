classdef BrushTool < imagem.gui.ImagemTool
% Draw on current image using current brush and 'color'.
%
%   output = BrushTool(input)
%
%   Example
%   BrushTool
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-11-21,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

%% Properties
properties
    ButtonPressed = false;
    
    % the current drawing 'color', initialized to white
    Color = 255;
    
    PreviousPoint;
end

%% Constructor
methods
    function obj = BrushTool(parent, varargin)
        % Creates a new tool using parent gui and a name
         obj = obj@imagem.gui.ImagemTool(parent, 'brush');
    end % constructor 

end % construction function

%% General methods
methods
    function onMouseButtonPressed(obj, hObject, eventdata) %#ok<INUSD>
        processCurrentPosition(obj);
        obj.ButtonPressed = true;
    end
    
    function onMouseButtonReleased(obj, hObject, eventdata) %#ok<INUSD>
        obj.PreviousPoint = [];
        obj.ButtonPressed = false;
    end
    
    function onMouseMoved(obj, hObject, eventdata) %#ok<INUSD>
        if ~obj.ButtonPressed
            return;
        end
        processCurrentPosition(obj);
   end
   
   function processCurrentPosition(obj)
        doc = obj.Viewer.Doc;
        img = doc.Image;
        
        if ~isGrayscaleImage(img)
            return;
        end
        
        point = get(obj.Viewer.Handles.ImageAxis, 'CurrentPoint');
        coord = round(pointToIndex(obj, point(1, 1:2)));
        
        % control on bounds of image
        dim = size(img);
        if any(coord < 1) || any(coord > dim([1 2]))
            return;
        end

        if ~isempty(obj.PreviousPoint)
            % mouse moved from a previous position
            drawBrushLine(obj, coord, obj.PreviousPoint);
        else
            % respond to mouse button pressed, mouse hasn't moved yet
            drawBrush(obj, coord);
        end
        
        obj.PreviousPoint = coord;
        
        doc.Modified = true;
        
        updateDisplay(obj.Viewer);
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
   
   function drawBrushLine(obj, coord1, coord2)
       [x, y] = imagem.gui.tools.BrushTool.intline(coord1(1), coord1(2), coord2(1), coord2(2));
       
       % iterate on current line
       for i = 1 : length(x)
           drawBrush(obj, [x(i) y(i)]);
       end
   end
   
   function drawBrush(obj, coord)
       doc  = obj.Viewer.Doc;
       
       % brush size in each direction
       bs = obj.Viewer.Gui.App.BrushSize;
       bs1 = floor((bs-1) / 2);
       bs2 = ceil((bs-1) / 2);
       
       % compute bounds
       dim = size(doc.Image);
       x1 = max(coord(1)-bs1, 1);
       y1 = max(coord(2)-bs1, 1);
       x2 = min(coord(1)+bs2, dim(1));
       y2 = min(coord(2)+bs2, dim(2));
       
       % iterate on brush pixels
       for i = x1:x2
           for j = y1:y2
               doc.Image(i, j) = obj.Color;
           end
       end
   end
end % methods

methods (Static, Access = private)
    function [x, y] = intline(x1, y1, x2, y2)
        %INTLINE Integer-coordinate line drawing algorithm.
        %   [X, Y] = INTLINE(X1, X2, Y1, Y2) computes an
        %   approximation to the line segment joining (X1, Y1) and
        %   (X2, Y2) with integer coordinates.  X1, X2, Y1, and Y2
        %   should be integers.  INTLINE is reversible; that is,
        %   INTLINE(X1, X2, Y1, Y2) produces the same results as
        %   FLIPUD(INTLINE(X2, X1, Y2, Y1)).
        %
        %   Function adapted from the 'strel' function of matlab.
        %
        
        dx = abs(x2 - x1);
        dy = abs(y2 - y1);
        
        % Check for degenerate case
        if dx == 0 && dy == 0
            x = x1;
            y = y1;
            return;
        end
        
        flip = 0;
        if dx >= dy
            if x1 > x2
                % swap coordinates to draw from left to right.
                t = x1; x1 = x2; x2 = t;
                t = y1; y1 = y2; y2 = t;
                flip = 1;
            end
            
            % compute line slope, and y from x
            slope = (y2 - y1) / (x2 - x1);
            x = (x1:x2).';
            y = round(y1 + slope * (x - x1));
            
        else
            if y1 > y2
                % swap coordinates to draw from bottom to top.
                t = x1; x1 = x2; x2 = t;
                t = y1; y1 = y2; y2 = t;
                flip = 1;
            end
            
            % compute line slope, and x from y
            slope = (x2 - x1) / (y2 - y1);
            y = (y1:y2).';
            x = round(x1 + slope * (y - y1));
        end
        
        if flip
            x = flipud(x);
            y = flipud(y);
        end
    end
end

methods
    function b = isActivable(obj)
        doc = obj.Viewer.Doc;
        b = ~isempty(doc) && ~isempty(doc.Image) && isScalarImage(doc.Image);
    end
end

end % classdef
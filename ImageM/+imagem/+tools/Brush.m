classdef Brush < imagem.gui.Tool
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
% e-mail: david.legland@inrae.fr
% Created: 2011-11-21,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRAE - Cepia Software Platform.

%% Properties
properties
    ButtonPressed = false;

    PreviousPoint;
end

%% Constructor
methods
    function obj = Brush(parent, varargin)
        % Creates a new tool using parent gui and a name
         obj = obj@imagem.gui.Tool(parent, 'brush');
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
                
        point = get(obj.Viewer.Handles.ImageAxis, 'CurrentPoint');
        coord = round(pointToIndex(obj, point(1, 1:2)));
        
        % control on bounds of image
        dim = size(img);
        if any(coord < 1) || any(coord > dim([1 2]))
            return;
        end
        
        % indices of Z, C and T dimensions
        iz = 1;
        if isa(obj.Viewer, 'imagem.gui.Image3DSliceViewer')
            iz = obj.Viewer.SliceIndex;
        end
        ic = 1:channelNumber(img);
        it = 1; % not managed for the moment

        if ~isempty(obj.PreviousPoint)
            % mouse moved from a previous position
            if isScalarImage(img)
                drawBrushLine(obj, coord, obj.PreviousPoint, iz, ic, it);
            else
                drawColorBrushLine(obj, coord, obj.PreviousPoint, iz, it);
            end
        else
            % respond to mouse button pressed, mouse hasn't moved yet
            if isScalarImage(img)
                drawBrush(obj, coord, iz, ic, it);
            else
                drawColorBrush(obj, coord, iz, it);
            end
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
   
   function drawBrushLine(obj, coord1, coord2, iz, ic, it)
       [x, y] = imagem.tools.Brush.intline(coord1(1), coord1(2), coord2(1), coord2(2));
       
       % iterate on current line
       for i = 1 : length(x)
           drawBrush(obj, [x(i) y(i)], iz, ic, it);
       end
   end
   
   function drawColorBrushLine(obj, coord1, coord2, iz, it)
       [x, y] = imagem.tools.Brush.intline(coord1(1), coord1(2), coord2(1), coord2(2));
       
       % iterate on current line
       for i = 1 : length(x)
           drawColorBrush(obj, [x(i) y(i)], iz, it);
       end
   end
   
   function drawBrush(obj, coord, iz, ic, it)
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
       for ix = x1:x2
           for iy = y1:y2
               doc.Image.Data(ix, iy, iz, ic, it) = obj.Viewer.Gui.App.BrushValue;
           end
       end
   end
   
   function drawColorBrush(obj, coord, iz, it)
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
       for ix = x1:x2
           for iy = y1:y2
               doc.Image.Data(ix, iy, iz, :, it) = obj.Viewer.Gui.App.BrushColor;
           end
       end
   end
end % methods

methods (Static, Access = private)
    function [x, y] = intline(x1, y1, x2, y2)
        % Integer-coordinate line drawing algorithm.
        %
        %   [X, Y] = intline(X1, X2, Y1, Y2) computes an
        %   approximation to the line segment joining (X1, Y1) and
        %   (X2, Y2) with integer coordinates.  X1, X2, Y1, and Y2
        %   should be integers.  intline is reversible; that is,
        %   intline(X1, X2, Y1, Y2) produces the same results as
        %   FLIPUD(intline(X2, X1, Y2, Y1)).
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
        b = ~isempty(doc) && ~isempty(doc.Image);
    end
end

end % classdef
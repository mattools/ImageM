classdef BrushTool < imagem.gui.ImagemTool
%BRUSHTOOL Draw on current image using current brush and 'color'
%
%   output = BrushTool(input)
%
%   Example
%   BrushTool
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-11-21,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

%% Properties
properties
    buttonPressed = false;
    
    % the current drawing 'color', initialized to white
    color = 255;
    
    previousPoint;
end

%% Constructor
methods
    function this = BrushTool(parent, varargin)
        % Creates a new tool using parent gui and a name
         this = this@imagem.gui.ImagemTool(parent, 'brush');
    end % constructor 

end % construction function

%% General methods
methods
    function onMouseButtonPressed(this, hObject, eventdata) %#ok<INUSD>
        processCurrentPosition(this);
        this.buttonPressed = true;
    end
    
    function onMouseButtonReleased(this, hObject, eventdata) %#ok<INUSD>
        this.previousPoint = [];
        this.buttonPressed = false;
    end
    
    function onMouseMoved(this, hObject, eventdata) %#ok<INUSD>
        if ~this.buttonPressed
            return;
        end
        processCurrentPosition(this);
   end
   
   function processCurrentPosition(this)
        doc = this.viewer.doc;
        img = doc.image;
        
        if ~isGrayscaleImage(img)
            return;
        end
        
        point = get(this.viewer.handles.imageAxis, 'CurrentPoint');
        coord = round(pointToIndex(this, point(1, 1:2)));
        
        % control on bounds of image
        dim = size(img);
        if any(coord < 1) || any(coord > dim([1 2]))
            return;
        end

        if ~isempty(this.previousPoint)
            % mouse moved from a previous position
            drawBrushLine(this, coord, this.previousPoint);
        else
            % respond to mouse button pressed, mouse hasn't moved yet
            drawBrush(this, coord);
        end
        
        this.previousPoint = coord;
        
        doc.modified = true;
        
        updateDisplay(this.viewer);
   end
   
   function index = pointToIndex(this, point)
       % Converts coordinates of a point in physical dimension to image index
       % First element is column index, second element is row index, both are
       % given in floating point and no rounding is performed.
       spacing = this.viewer.doc.image.spacing(1:2);
       origin  = this.viewer.doc.image.origin(1:2);
       index   = (point - origin) ./ spacing + 1;
   end
   
   function drawBrushLine(this, coord1, coord2)
       [x, y] = imagem.gui.tools.BrushTool.intline(coord1(1), coord1(2), coord2(1), coord2(2));
       
       % iterate on current line
       for i = 1 : length(x)
           drawBrush(this, [x(i) y(i)]);
       end
   end
   
   function drawBrush(this, coord)
       doc  = this.viewer.doc;
       
       % brush size in each direction
       bs = this.viewer.gui.app.brushSize;
       bs1 = floor((bs-1) / 2);
       bs2 = ceil((bs-1) / 2);
       
       % compute bounds
       dim = size(doc.image);
       x1 = max(coord(1)-bs1, 1);
       y1 = max(coord(2)-bs1, 1);
       x2 = min(coord(1)+bs2, dim(1));
       y2 = min(coord(2)+bs2, dim(2));
       
       % iterate on brush pixels
       for i = x1:x2
           for j = y1:y2
               doc.image(i, j) = this.color;
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
    function b = isActivable(this)
        doc = this.viewer.doc;
        b = ~isempty(doc) && ~isempty(doc.image) && isScalarImage(doc.image);
    end
end

end % classdef
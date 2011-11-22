classdef SetPixelToWhiteTool < imagem.gui.ImagemTool
%SETPIXELTOWHITETOOL  One-line description here, please.
%
%   output = SetPixelToWhiteTool(input)
%
%   Example
%   SetPixelToWhiteTool
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
end

%% Constructor
methods
    function this = SetPixelToWhiteTool(varargin)
        % Creates a new tool using parent gui and a name
         this = this@imagem.gui.ImagemTool(varargin{:});
    end % constructor 

end % construction function

%% General methods
methods
    function onMouseButtonPressed(this, hObject, eventdata) %#ok<INUSD>
        processCurrentPosition(this);
        this.buttonPressed = true;
    end
    
    function onMouseButtonReleased(this, hObject, eventdata) %#ok<INUSD>
        this.buttonPressed = false;
    end
    
    function onMouseMoved(this, hObject, eventdata) %#ok<INUSD>
        if ~this.buttonPressed
            return;
        end
        processCurrentPosition(this);
   end
   
   function processCurrentPosition(this)
        doc = this.parent.doc;
        img = doc.image;
        
        if ~strcmp(img.type, 'grayscale')
            return;
        end
        
        point = get(this.parent.handles.imageAxis, 'CurrentPoint');
        coord = round(pointToIndex(this, point(1, 1:2)));
        
        % control on bounds of image
        if any(coord < 1) || any(coord > size(img, [1 2]))
            return;
        end
        
        doc.image(coord(1), coord(2)) = 255;
        
        updateDisplay(this.parent);
   end
   
   function index = pointToIndex(this, point)
       % Converts coordinates of a point in physical dimension to image index
       % First element is column index, second element is row index, both are
       % given in floating point and no rounding is performed.
       spacing = this.parent.doc.image.spacing(1:2);
       origin  = this.parent.doc.image.origin(1:2);
       index   = (point - origin) ./ spacing + 1;
   end
   
end % methods

end % classdef
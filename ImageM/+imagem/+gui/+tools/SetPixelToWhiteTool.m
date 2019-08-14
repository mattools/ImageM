classdef SetPixelToWhiteTool < imagem.gui.ImagemTool
% Set pixel color to white
%
%   output = SetPixelToWhiteTool(input)
%
%   Example
%   SetPixelToWhiteTool
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
end

%% Constructor
methods
    function obj = SetPixelToWhiteTool(viewer, varargin)
        % Creates a new tool using parent gui and a name
         obj = obj@imagem.gui.ImagemTool(viewer, 'setPixelToWhite');
    end % constructor 

end % construction function

%% General methods
methods
    function onMouseButtonPressed(obj, hObject, eventdata) %#ok<INUSD>
        processCurrentPosition(obj);
        obj.ButtonPressed = true;
    end
    
    function onMouseButtonReleased(obj, hObject, eventdata) %#ok<INUSD>
        obj.ButtonPressed = false;
    end
    
    function onMouseMoved(obj, hObject, eventdata) %#ok<INUSD>
        if ~obj.ButtonPressed
            return;
        end
        processCurrentPosition(obj);
   end
   
   function processCurrentPosition(obj)
        doc = currentDoc(obj);
        img = doc.Image;
        
        if ~isGrayscaleImage(img)
            return;
        end
        
        point = get(obj.viewer.handles.ImageAxis, 'CurrentPoint');
        coord = round(pointToIndex(obj, point(1, 1:2)));
        
        % control on bounds of image
        if any(coord < 1) || any(coord > size(img, [1 2]))
            return;
        end
        
        doc.Image(coord(1), coord(2)) = 255;
        
        updateDisplay(obj.viewer);
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
   
end % methods

end % classdef
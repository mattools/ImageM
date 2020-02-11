classdef PickValueOrColor < imagem.gui.Tool
% Pick the new value or color for brush or flood-fill.
%
%   Class PickValueOrColor
%
%   Example
%   PickValueOrColor
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-02-11,    using Matlab 9.7.0.1247435 (R2019b) Update 2
% Copyright 2020 INRAE - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = PickValueOrColor(parent, varargin)
        % Constructor for PickValueOrColor class
        obj = obj@imagem.gui.Tool(parent, 'pickValueOrColor');
    end

end % end constructors


%% Methods
methods
    function onMouseButtonPressed(obj, hObject, eventdata) %#ok<INUSD>
        doc = currentDoc(obj);
        img = doc.Image;
        
        if ~isScalarImage(img)
            return;
        end
        
        point = get(obj.Viewer.Handles.ImageAxis, 'CurrentPoint');
        coord = round(pointToIndex(obj, point(1, 1:2)));
        
        pos = [num2cell(coord), {1, ':'}];
        if isa(obj.Viewer, 'Image3DSliceViewer')
            pos{3} = obj.Viewer.SliceIndex;
        end
        
        if isScalarImage(img)
            obj.Viewer.Gui.App.BrushValue = img.Data(pos{:});
        else
            values = img.Data(pos{:});
            obj.Viewer.Gui.App.BrushColor = values(:)';
        end
        
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

end % end methods

end % end classdef


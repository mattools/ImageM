classdef SetBrushSizeAction < imagem.gui.ImagemAction
% Changes the size of the brush.
%
%   Class SetBrushSizeAction
%
%   Example
%   SetBrushSizeAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-15,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    Handles;
    
    Conn2d;
    Conn3d;
    
    Conn2dValues = [4 8];
    Conn3dValues = [6 26];
    
end % end properties


%% Constructor
methods
    function obj = SetBrushSizeAction(viewer)
    % Constructor for SetBrushSizeAction class
        obj = obj@imagem.gui.ImagemAction(viewer, 'setBrushSize');
    end

end % end constructors


methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        disp('set brush size');

        answer = inputdlg(...
            'Enter the brush size (in pixels):', ...
            'Input Brush size', ...
            1, {num2str(obj.Viewer.Gui.App.BrushSize)});
        
        if isempty(answer)
            return;
        end
        
        size = str2double(answer{1});
        if isnan(size)
            errordlg('Could not understand brush size');
        end
        
        obj.Viewer.Gui.App.BrushSize = size;
        
    end
    
end

end % end classdef


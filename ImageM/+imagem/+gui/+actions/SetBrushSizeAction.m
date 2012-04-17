classdef SetBrushSizeAction < imagem.gui.ImagemAction
%CREATEIMAGEACTION  Changes defualt connectivity in App
%
%   Class SetBrushSizeAction
%
%   Example
%   SetBrushSizeAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-12-15,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    handles;
    
    conn2d;
    conn3d;
    
    conn2dValues = [4 8];
    conn3dValues = [6 26];
    
end % end properties


%% Constructor
methods
    function this = SetBrushSizeAction(viewer)
    % Constructor for SetBrushSizeAction class
        this = this@imagem.gui.ImagemAction(viewer, 'setBrushSize');
    end

end % end constructors


methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('set brush size');

        answer = inputdlg(...
            'Enter the brush size (in pixels):', ...
            'Input Brush size', ...
            1, {num2str(this.viewer.gui.app.brushSize)});
        
        if isempty(answer)
            return;
        end
        
        size = str2double(answer{1});
        if isnan(size)
            errordlg('Could not understand brush size');
        end
        
        this.viewer.gui.app.brushSize = size;
        
    end
    
end

end % end classdef


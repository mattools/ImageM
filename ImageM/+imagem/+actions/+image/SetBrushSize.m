classdef SetBrushSize < imagem.gui.Action
% Change the size of the brush.
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
end % end properties


%% Constructor
methods
    function obj = SetBrushSize()
    end

end % end constructors


methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        disp('set brush size');

        answer = inputdlg(...
            'Enter the brush size (in pixels):', ...
            'Input Brush size', ...
            1, {num2str(frame.Gui.App.BrushSize)});
        
        if isempty(answer)
            return;
        end
        
        size = str2double(answer{1});
        if isnan(size)
            errordlg('Could not understand brush size');
        end
        
        frame.Gui.App.BrushSize = size;
    end
    
end

end % end classdef


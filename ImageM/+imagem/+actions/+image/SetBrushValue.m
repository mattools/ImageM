classdef SetBrushValue < imagem.gui.Action
% Change the value of the brush.
%
%   Class SetBrushValue
%
%   Example
%   SetBrushValue
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-01-30,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = SetBrushValue()
    end

end % end constructors


methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        disp('set brush value');

        answer = inputdlg(...
            'Enter the brush value:', ...
            'Input Brush size', ...
            1, {num2str(frame.Gui.App.BrushValue)});
        
        if isempty(answer)
            return;
        end
        
        size = str2double(answer{1});
        if isnan(size)
            errordlg('Could not understand brush value');
        end
        
        frame.Gui.App.BrushValue = size;
    end
    
end

end % end classdef


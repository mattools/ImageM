classdef CreateImageAction < imagem.gui.ImagemAction
% Open a dialog to create a new image.
%
%   Class CreateImageAction
%
%   Example
%   CreateImageAction
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
    function obj = CreateImageAction(viewer)
    % Constructor for CreateImageAction class
        obj = obj@imagem.gui.ImagemAction(viewer, 'createImage');
    end

end % end constructors


methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        disp('create a new image');
        

        prompt = {'Size X:', 'Size Y:', 'Data type:', 'Fill with:'};
        name = 'Create a new image';
        numLines = 1;
        defaultAnswer = {'256', '256', 'uint8', '0'};
        
        ok = false;
        while ~ok
            answer = inputdlg(prompt, name, numLines, defaultAnswer);
            if isempty(answer)
                return;
            end
            
            defaultAnswer = answer;
            
            dimX = str2double(answer{1});
            if isnan(dimX)
                errordlg(['Could not interpret input for dim X: ' answer{1}]);
            end
            
            dimY = str2double(answer{2});
            if isnan(dimY)
                errordlg(['Could not interpret input for dim Y: ' answer{2}]);
            end
            
            dataType = answer{3};
            
            fillValue = str2double(answer{4});
            if isnan(fillValue)
                errordlg(['Could not interpret input for fill Value: ' answer{4}]);
            end
            
            ok = true;
        end
        
        img = Image.create([dimX dimY], dataType);
        img(:) = fillValue;
        
        addImageDocument(obj, img);
    end
    
    
    
end


end % end classdef


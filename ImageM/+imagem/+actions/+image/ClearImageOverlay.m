classdef ClearImageOverlay < imagem.actions.CurrentImageAction
% Remove all overlays of an image document.
%
%   Class ClearImageOverlay
%
%   Example
%   ClearImageOverlay
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-01-12,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = ClearImageOverlay(varargin)
        % Constructor for ClearImageOverlay class.

    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        
        disp('% clear overlay');
        
        doc = currentDoc(frame);
        
        clearShapes(doc);
        
        updateDisplay(frame);
    end
    
end % end methods

end % end classdef


classdef ClearSpatialCalibration < imagem.actions.CurrentImageAction
% Reset spatial calibration of current image to default values.
%
%   Class ClearSpatialCalibration
%
%   Example
%   ClearSpatialCalibration
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2020-01-08,    using Matlab 9.7.0.1247435 (R2019b) Update 2
% Copyright 2020 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = ClearSpatialCalibration(varargin)
    % Constructor for ClearSpatialCalibration class

    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        
        img = currentImage(frame);
        
        clearCalibration(img);
        
        updateDisplay(frame);
    end
    
end % end methods

end % end classdef


classdef EditSpatialCalibration < imagem.actions.CurrentImageAction
% Edit spatial calibration info of current image.
%
%   Class EditSpatialCalibration
%
%   Example
%   EditSpatialCalibration
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
    function obj = EditSpatialCalibration(varargin)
    % Constructor for EditSpatialCalibration class

    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        
        img = currentImage(frame);
        
        nd = ndims(img);
        
        % create a new Dialog and populate with some fields
        gd = imagem.gui.GenericDialog('Spatial Calibration');
        for i = 1:nd
            addNumericField(gd, sprintf('Spacing %d:', i), img.Spacing(i), 3);
        end
        for i = 1:nd
            addNumericField(gd, sprintf('Origin %d:', i), img.Origin(i), 3);
        end
        addTextField(gd, 'Unit Name:', img.UnitName);
        
        % displays the dialog, and waits for user
        showDialog(gd);
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % parse user input
        sp = zeros(1, nd);
        or = zeros(1, nd);
        for i = 1:nd
            sp(i) = getNextNumber(gd);
        end
        for i = 1:nd
            or(i) = getNextNumber(gd);
        end
        unit = getNextString(gd);
        
        img.Spacing = sp;
        img.Origin  = or;
        img.UnitName = unit;
        
        updateDisplay(frame);
    end

end % end methods

end % end classdef


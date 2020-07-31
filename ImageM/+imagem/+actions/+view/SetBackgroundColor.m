classdef SetBackgroundColor < imagem.actions.CurrentImageAction
% Set the color associated to background pixels/voxels of an image.
%
%   Class SetBackgroundColor
%
%   Example
%   SetBackgroundColor
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-07-31,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = SetBackgroundColor(varargin)
        % Constructor for SetBackgroundColor class.
        obj = obj@imagem.actions.CurrentImageAction();
    end
end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        disp('Change Image Background Color');
        
        % get handle to current doc
        doc = frame.Doc;
        
        % get current BG color, and convert to 0-255 scalar values.
        bgColor = doc.BackgroundColor;
        bgR8 = bgColor(1) * 255;
        bgG8 = bgColor(2) * 255;
        bgB8 = bgColor(3) * 255;
        
        gd = imagem.gui.GenericDialog('Set Background Color');
        addNumericField(gd, 'Red: ',   bgR8, 0);
        addNumericField(gd, 'Green: ', bgG8, 0);
        addNumericField(gd, 'Blue: ',  bgB8, 0);
        
        % displays the dialog, and waits for user
        showDialog(gd);
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % gets the user inputs
        bgR8 = getNextNumber(gd);
        bgG8 = getNextNumber(gd);
        bgB8 = getNextNumber(gd);
        bgColor = max(min([bgR8 bgG8 bgB8], 255), 0) / 255;
        
        doc.BackgroundColor = bgColor;
        doc.Modified = true;
        
        updateDisplay(frame);
    end
    
    function b = isActivable(obj, frame) %#ok<INUSL>
        % Check if current doc contains either a label or intensity image.
        doc = frame.Doc;
        b = ~isempty(doc) && ~isempty(doc.Image);
        if b
            img = doc.Image;
            b = isLabelImage(img) || isIntensityImage(img);
        end
    end
end % end methods

end % end classdef


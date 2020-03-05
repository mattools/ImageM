classdef Image3DIsosurface < imagem.actions.Image3DAction
% Diplay isosurface of a 3D image.
%
%   Class Image3DIsosurface
%
%   Example
%   Image3DIsosurface 
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-03-05,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2020 INRAE - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = Image3DIsosurface(varargin)
    % Constructor for Image3DIsosurface class.

    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        
        % get handle to current doc
        doc = currentDoc(frame);
        
        % check image size
        img = doc.Image;
        if size(img, 3) == 1
            return;
        end
        
        % creates a new dialog, and populates it with some fields
        gd = imagem.gui.GenericDialog('3D Isosurface');
        
        addNumericField(gd, 'Isosurface Value', 50, 2);
        addNumericField(gd, 'Smoothing Radius (voxels)', 2, 0);
        addCheckBox(gd, 'Reverse Z-axis', false);
        addCheckBox(gd, 'Rotate Ox', false);
        addCheckBox(gd, 'Show Axis Labels', false);
        
        % displays the dialog, and waits for user
        showDialog(gd);
        if wasCanceled(gd)
            return;
        end
        
        isosurfaceValue = getNextNumber(gd);
        smoothRadius    = getNextNumber(gd);
        reverseZAxis    = getNextBoolean(gd);
        rotateXAxis     = getNextBoolean(gd);
        showAxesLabel   = getNextBoolean(gd);
        
        % eventually rotate image around X-axis
        if rotateXAxis
            img = rotate90(img, 'x', 1);
        end

        if smoothRadius > 0
            disp('% smoothing...');
            siz = floor(smoothRadius * 2) + 1;
            img = gaussianFilter(img, siz, smoothRadius);
        end

        
        % eventually rotate image around X-axis
        if rotateXAxis
            img = flip(rotate90(img, 'x', 1), 2);
        end
        
        % create figure 
        hf = figure(); hold on;
        set(hf, 'renderer', 'opengl');
        isosurface(img, isosurfaceValue);
        
        % setup display
        axis equal;
        axis(physicalExtent(img));
        axis('vis3d'); view(3);
        light;
         
        if rotateXAxis || reverseZAxis
            set(gca, 'zdir', 'reverse');
        end

        % annotate axis
        if showAxesLabel
            xlabel('X axis');
            if rotateXAxis
                ylabel('Z Axis');
                zlabel('Y Axis');
            else
                ylabel('Y Axis');
                zlabel('Z Axis');
            end
        end
        
        % add history
%         string = sprintf('showOrthoSlices(%s, [%d %d %d]);\n', doc.Tag, pos);
        string = sprintf('isosurface(%s, %g);\n', doc.Tag, isosurfaceValue);
        addToHistory(frame, string);
    end
    
end % end methods

end % end classdef


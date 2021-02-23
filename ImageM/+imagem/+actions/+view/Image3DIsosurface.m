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
        img = doc.Image;
        
        % check image size
        if size(img, 3) == 1
            return;
        end
        
        % creates a new dialog, and populates it with some fields
        gd = imagem.gui.GenericDialog('3D Isosurface');
        
        if ~isLabelImage(img)
            addNumericField(gd, 'Isosurface Value', 50, 2);
        end
        addNumericField(gd, 'Smoothing Radius (voxels)', 2, 0);
        addCheckBox(gd, 'Reverse Z-axis', false);
        addCheckBox(gd, 'Rotate Ox', false);
        addCheckBox(gd, 'Show Axis Labels', false);
        
        % displays the dialog, and waits for user
        showDialog(gd);
        if wasCanceled(gd)
            return;
        end
        
        % parse user inputs
        if ~isLabelImage(img)
            isosurfaceValue = getNextNumber(gd);
        end
        smoothRadius    = getNextNumber(gd);
        reverseZAxis    = getNextBoolean(gd);
        rotateXAxis     = getNextBoolean(gd);
        showAxesLabel   = getNextBoolean(gd);
        
        % eventually rotate image around X-axis
        if rotateXAxis
            img = rotate90(img, 'x', 1);
        end

        % create figure
        hf = figure(); hold on;
        set(hf, 'renderer', 'opengl');

        if ~isLabelImage(img)
            % smooth grayscale / intensities
            if smoothRadius > 0
                disp('% smoothing...');
                siz = floor(smoothRadius * 2) + 1;
                img = gaussianFilter(img, siz, smoothRadius);
            end
            
            % compute isosurface of grayscale/intensity values
            isosurface(img, isosurfaceValue);
            
        else
            % For label images, call the specific regionIsosurfaces
            [meshes, labels] = regionIsosurfaces(img, 'smoothRadius', smoothRadius);
            
            % display each mesh with color specified by colormap of doc
            colors = doc.ColorMap;
            for iLabel = 1:length(meshes)
                label = labels(iLabel);
                p = patch(meshes{iLabel});
                color = colors(label, :);
                set(p, 'FaceColor', color, 'LineStyle', 'none');
            end
        end
        
        % setup display
        axis equal;
        axis(physicalExtent(img));
        axis('vis3d'); view(3);
        set(hf, 'Name', sprintf('%s-isosurface', img.Name));
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
        if ~isLabelImage(img)
            string = sprintf('isosurface(%s, %g);\n', doc.Tag, isosurfaceValue);
        else
            string = sprintf('regionIsosurfaces(%s);\n', doc.Tag);
        end
        addToHistory(frame, string);
    end
    
end % end methods

end % end classdef


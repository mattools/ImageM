classdef ShowImage3DOrthoSlices < imagem.actions.Image3DAction
% Diplay three orthogonal 3D slices in a new figure.
%
%   Class ConvertImage3DToVectorImage
%
%   Example
%   ConvertImage3DToVectorImage
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-11-15,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = ShowImage3DOrthoSlices(varargin)
    % Constructor for ShowImage3DOrthoSlices class.

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
        gd = imagem.gui.GenericDialog('3D OrthoSlices');
        
        addCheckBox(gd, 'Rotate Ox', false);
%         addCheckBox(gd, 'Convert to RGB', false);
        addCheckBox(gd, 'Show Axis Labels', false);
        
        % displays the dialog, and waits for user
        showDialog(gd);
        if wasCanceled(gd)
            return;
        end
        
        rotateXAxis = getNextBoolean(gd);
%         convertToRGB = getNextBoolean(gd);
        showAxesLabel = getNextBoolean(gd);
        
        if isLabelImage(img)
            % choose the colormap
            cmap = frame.Doc.ColorMap;
            if isempty(cmap)
                cmap = jet(256);
            end
        
            % if colormap has 256 entries, we need only a subset
            % otherwise, we assume colormap has as many rows as the number
            % of labels.
            nLabels = max(img.Data(:));
            if size(cmap, 1) == 256
                inds = round(linspace(2, 256, nLabels));
                cmap = cmap(inds, :);
            end
            
            % convert inner image data
            img = label2rgb(img, cmap, frame.Doc.BackgroundColor, 'shuffle');
        end
        
        % eventually rotate image around X-axis
        if rotateXAxis
            img = flip(rotate90(img, 'x', 1), 2);
        end
        
        % compute display settings
        pos = ceil(size(img) / 2);
        
        % determine the color map to use (default is empty)
        cmap = [];
        if ~isColorImage(img) && ~isempty(frame.Doc.ColorMap)
            cmap = frame.Doc.ColorMap;
        end
        
        % create figure with 3 orthogonal slices in 3D
        figure();
        showOrthoSlices(img, pos, ...
            'DisplayRange', frame.DisplayRange, 'ColorMap', cmap);
        
        % setup display
        axis equal;
        axis(physicalExtent(img));
        view(3);
        
        if rotateXAxis
            set(gca, 'zdir', 'reverse');
        end
        
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
        string = sprintf('showOrthoSlices(%s, [%d %d %d]);\n', doc.Tag, pos);
        addToHistory(frame, string);
    end
    
end % end methods

end % end classdef


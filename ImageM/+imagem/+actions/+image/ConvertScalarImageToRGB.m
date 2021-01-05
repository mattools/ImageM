classdef ConvertScalarImageToRGB < imagem.actions.CurrentImageAction
% Convert an intensity or grayscale image to color RGB.
%
%   Class ConvertScalarImageToRGB
%
%   Example
%   ConvertScalarImageToRGB
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-03-02,    using Matlab 9.7.0.1247435 (R2019b) Update 2
% Copyright 2020 INRAE - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = ConvertScalarImageToRGB(varargin)
        % Constructor for convertScalarImageToRGB class
        
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        
        % get handle to current doc
        doc = currentDoc(frame);
        
        img = doc.Image;
        if ~isIntensityImage(img) && ~isGrayscaleImage(img)
            warning('require intensity or grayscale image');
        end
        
        colormapNames = imagem.util.enums.ColorMaps.allLabels;
        range = [min(img) max(img)];
        colorNames = imagem.util.enums.BasicColors.allLabels;
        
        % Creates the Dialog for choosing options
        gd = imagem.gui.GenericDialog('Binary Overlay');
        addChoice(gd, 'Color Map:', colormapNames, colormapNames{1});
        addNumericField(gd, 'Min Value:', range(1));
        addNumericField(gd, 'Max Value:', range(2));
        addChoice(gd, 'Background Color:', colorNames, colorNames{1});
        
        % displays the dialog, and waits for user
        showDialog(gd);
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % parse user inputs
        colorMapItem = imagem.util.enums.ColorMaps.fromLabel(getNextString(gd));
        cmap = createColorMap(colorMapItem, 256);
        vmin = getNextNumber(gd);
        vmax = getNextNumber(gd);
        colorItem = imagem.util.enums.BasicColors.fromLabel(getNextString(gd));
        bgColor = colorItem.RGB;
        
        rgb = double2rgb(img, cmap, [vmin vmax], bgColor);

        name = 'NoName-rgb';
        if ~isempty(img.Name)
            name = [img.Name '-rgb'];
        end
        rgb.Name = name;
        
        % add image to application, and create new display
        newDoc = addImageDocument(frame, rgb);
        
        % add history
        string = sprintf('cmap = createColorMap(imagem.util.enums.BasicColors.%s, 256);\n', ...
            colorItem.Name);
        addToHistory(frame, string);
        string = sprintf('%s = double2rgb(%s, %s, [%g %g], [%g %g %g]);\n', ...
            newDoc.Tag, doc.Tag, 'cmap', vmin, vmax, bgColor);
        addToHistory(frame, string);
    end
    
    function b = isActivable(obj, frame)
        b = isActivable@imagem.actions.CurrentImageAction(obj, frame);
        if ~b 
            return;
        end
        
        img = currentImage(frame);
        b = isIntensityImage(img) || isGrayscaleImage(img);
    end
end % end methods


end % end classdef


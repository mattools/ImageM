classdef ImportImageFromBinaryFile < imagem.gui.Action
% One-line description here, please.
%
%   Class ImportImageFromBinaryFile
%
%   Example
%   ImportImageFromBinaryFile
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-12-23,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = ImportImageFromBinaryFile(varargin)
        % Constructor for ImportImageFromBinaryFile class.

    end

end % end constructors

%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        disp('% Open image from raw file');
        
        % get handle to parent GUI
        gui = frame.Gui;
        
        [fileName, pathName] = uigetfile( ...
            {'*.raw;*.bin;*.tif;*.vol',   'All Binary Files (*.raw, *.bin, *.tif, *.vol)'; ...
            '*.tif,'                'Tif Files (*.tif)'; ...
            '*.raw,'                'Raw Files (*.raw)'; ...
            '*.vol,'                'Vol Files (*.vol)'; ...
            '*.*',                  'All Files (*.*)'}, ...
            'Choose binary data file:');
        
        if isequal(fileName,0) || isequal(pathName,0)
            return;
        end
        
        % determine file options
        filePath = fullfile(pathName, fileName);
        [~, imageName] = fileparts(fileName);
        
        % creates a new dialog, and populates it with some fields
        dataTypes = {'uint8', 'uint16', 'int16', 'single', 'double'};
        gd = imagem.gui.GenericDialog('Import Image');
%         addNumericField(gd, 'Offset: ', 0);
        addNumericField(gd, 'Size X: ', 512);
        addNumericField(gd, 'Size Y: ', 512);
        addNumericField(gd, 'Size Z: ', 100);
        addChoice(gd, 'Type: ', dataTypes, dataTypes{1});
        addCheckBox(gd, 'Little-endian', true);
        
        % displays the dialog, and waits for user
        showDialog(gd);
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % parse the user inputs
        sizeX = getNextNumber(gd);
        sizeY = getNextNumber(gd);
        sizeZ = getNextNumber(gd);
        type = getNextString(gd);
        if getNextBoolean(gd)
            byteOrder = 'ieee-le';
        else
            byteOrder = 'ieee-be';
        end
        
        % read the image
        img = Image.importRaw(filePath, ...
            [sizeX sizeY sizeZ], ...
            type, 'byteOrder', byteOrder);
        img.Name = imageName;
        
        % add image to application, and create new display
        [frame, doc] = createImageFrame(gui, img);
        
        % add history
        string = sprintf('%s = Image.importRaw(''%s'', [%d %d %d], ''%s'', ''byteOrder'', ''%s'');\n', ...
            doc.Tag, filePath, sizeX, sizeY, sizeZ, type, 'byteOrder', byteOrder);
        addToHistory(frame, string);
    end
end % end methods

end % end classdef


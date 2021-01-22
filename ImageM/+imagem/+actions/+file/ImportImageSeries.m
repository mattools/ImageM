classdef ImportImageSeries < imagem.gui.Action
% One-line description here, please.
%
%   Class ImportImageSeries
%
%   Example
%   ImportImageSeries
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-12-28,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = ImportImageSeries(varargin)
        % Constructor for ImportImageSeries class.

    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        disp('% Open Image Series');
        
        % get handle to parent GUI
        gui = frame.Gui;
        
        [fileName, pathName] = uigetfile( ...
            {'*.gif;*.jpg;*.jpeg;*.bmp;*.png;*.tif;*.tiff;*.hdr;*.dcm;*.mhd;*.vgi', ...
            'All Image Files (*.tif, *.bmp, *.png, *.hdr, *.dcm, *.mhd...)'; ...
            '*.tif;*.tiff',             'TIF Files (*.tif, *.tiff)'; ...
            '*.jpg',                    'JPG Files (*.jpg)'; ...
            '*.bmp',                    'BMP Files (*.bmp)'; ...
            '*.png',                    'PNG Files (*.png)'; ...
            '*.hdr',                    'Mayo Analyze Files (*.hdr)'; ...
            '*.dcm',                    'DICOM Files (*.dcm)'; ...
            '*.mhd;*.mha',              'MetaImage data files (*.mha, *.mhd)'; ...
            '*.vgi',                    'VGStudio Max files (*.vgi)'; ...
            '*.*',                      'All Files (*.*)'}, ...
            'Choose an image from the series:');
        
        if isequal(fileName,0) || isequal(pathName,0)
            return;
        end
        
        % default pattern
        [~, ~, ext] = fileparts(fileName);
        pattern = ['*' ext];
        fileList = dir(fullfile(pathName, pattern));
        nFiles = length(fileList);
        
        % creates a new dialog, and populates it with some fields
        gd = imagem.gui.GenericDialog('Import Image Series');
        addMessage(gd, 'Base Name: ');
        addMessage(gd, fileName);
        addTextField(gd, 'File Name Pattern: ', pattern);
        addNumericField(gd, 'Number of images: ', nFiles);
        addNumericField(gd, 'Starting index: ', 1);
        addChoice(gd, 'Series Type: ', {'Z-stack', 'Channels', 'Time-lapse'}, 'Z-stack');
        
        % displays the dialog, and waits for user
        showDialog(gd);
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % parse the user inputs
        pattern = getNextString(gd);
        nImages = getNextNumber(gd);
        index0 = getNextNumber(gd);
        typeIndex = getNextChoiceIndex(gd);
        % the dimension for concatenation
        dim = typeIndex + 2;
        
        % read first image
        fileList = dir(fullfile(pathName, pattern));
        img0 = Image.read(fullfile(pathName, fileList(index0).name));
        
        % checkup on inputs
        if size(img0, 4) > 1 && typeIndex == 2
            errordlg('Can not import channels series of non scalar images', 'Import Error');
            return;
        end
        
        img = Image.readSeries(fullfile(pathName, pattern), ...
            index0:nImages, ...
            'dim', dim);
   
        % add image to application, and create new display
        [frame, doc] = createImageFrame(gui, img);
        
        % add history
        string = sprintf(...
            '%s = Image.readSeries(fullfile(''%s'',''%s'', %d:%d, ''dim'', %d);\n', ...
            doc.Tag, pathName, pattern, index0, nImages, dim);
            
        addToHistory(frame, string);
    end
end % end methods

end % end classdef


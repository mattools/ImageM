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
        disp('% Open Image sequence ');
        
        % get handle to parent GUI
        gui = frame.Gui;
        
        [fileName, pathName] = uigetfile( ...
            {'*.raw;*.bin;*.tif;*.vol',   'All Binary Files (*.raw, *.bin, *.tif, *.vol)'; ...
            '*.tif,'                'Tif Files (*.tif)'; ...
            '*.raw,'                'Raw Files (*.raw)'; ...
            '*.vol,'                'Vol Files (*.vol)'; ...
            '*.*',                  'All Files (*.*)'}, ...
            'Choose an image from sequence:');
        
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
        
        % read first image
        fileList = dir(fullfile(pathName, pattern));
        img0 = Image.read(fullfile(pathName, fileList(index0).name));
        
        % allocte memory for full series
        sizeX = size(img0, 1);
        sizeY = size(img0, 2);
        img = Image.create([sizeX sizeY nImages], class(img0.Data));
        img.Data(:,:,1,:) = img0.Data;
        
        % read the remaining images
        fileList = dir(fullfile(pathName, pattern));
        for i = 1:nImages
            index = index0 + i - 1;
            img_i = Image.read(fullfile(pathName, fileList(index).name));
            img.Data(:,:,i,:) = img_i.Data;
        end
       
        img.Name = pattern;
        
        % add image to application, and create new display
        [frame, doc] = createImageFrame(gui, img);
        
        % add history
        string = sprintf('%s = Image.importSequence;\n', doc.Tag);
            
        addToHistory(frame, string);
    end
end % end methods

end % end classdef


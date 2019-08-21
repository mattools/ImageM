classdef OpenImageAction < imagem.gui.ImagemAction
% Open an image from a file.
%
%   Class OpenImageAction
%
%   Example
%   OpenImageAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-11-07,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.



%% Constructor
methods
    function obj = OpenImageAction(viewer)
    % Constructor for OpenImageAction class
        
        % calls the parent constructor
        obj = obj@imagem.gui.ImagemAction(viewer, 'openImage');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        disp('Open new Image ');
        
        [fileName, pathName] = uigetfile( ...
            {'*.gif;*.jpg;*.jpeg;*.bmp;*.png;*.tif;*.tiff;*.hdr;*.dcm;*.mhd;*.vgi', ...
            'All Image Files (*.tif, *.bmp, *.png, *.hdr, *.dcm, *.mhd...)'; ...
            '*.tif;*.tiff',             'TIF Files (*.tif, *.tiff)'; ...
            '*.bmp',                    'BMP Files (*.bmp)'; ...
            '*.png',                    'PNG Files (*.png)'; ...
            '*.hdr',                    'Mayo Analyze Files (*.hdr)'; ...
            '*.dcm',                    'DICOM Files (*.dcm)'; ...
            '*.mhd;*.mha',              'MetaImage data files (*.mha, *.mhd)'; ...
            '*.vgi',                    'VGStudio Max files (*.vgi)'; ...
            '*.*',                      'All Files (*.*)'}, ...
            'Choose a stack or the first slice of a series:');
        
        if isequal(fileName,0) || isequal(pathName,0)
            return;
        end

        % read the selected file
        imagePath = fullfile(pathName, fileName);
        img = Image.read(imagePath);
        
        % add image to application, and create new display
        doc = addImageDocument(obj, img);

        % history
        tag = doc.Tag;
        string = sprintf('%s = Image.read(''%s'');\n', tag, imagePath);
        addToHistory(obj, string);
    end
end % end methods

end % end classdef


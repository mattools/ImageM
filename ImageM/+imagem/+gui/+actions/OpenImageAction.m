classdef OpenImageAction < imagem.gui.ImagemAction
%OPENIMAGEACTION Open an image from a file
%
%   Class OpenImageAction
%
%   Example
%   OpenImageAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-11-07,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function this = OpenImageAction(parent)
    % Constructor for OpenImageAction class
        
        % calls the parent constructor
        this = this@imagem.gui.ImagemAction(parent, 'openImage');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('Open new Image ');
        
        % get handle to parent figure, and current doc
        viewer = this.parent;
        gui = viewer.gui;
        
        [fileName, pathName] = uigetfile( ...
            {'*.gif;*.jpg;*.jpeg;*.tif;*.tiff;*.bmp;*.hdr;*.dcm;*.mhd', ...
            'All Image Files (*.tif, *.hdr, *.dcm, *.mhd, *.bmp, *.jpg)'; ...
            '*.tif;*.tiff',             'TIF Files (*.tif, *.tiff)'; ...
            '*.bmp',                    'BMP Files (*.bmp)'; ...
            '*.hdr',                    'Mayo Analyze Files (*.hdr)'; ...
            '*.dcm',                    'DICOM Files (*.dcm)'; ...
            '*.mhd;*.mha',              'MetaImage data files (*.mha, *.mhd)'; ...
            '*.*',                      'All Files (*.*)'}, ...
            'Choose a stack or the first slice of a series:');
        
        if isequal(fileName,0) || isequal(pathName,0)
            return;
        end


        % read the demo image
        img = Image.read(fullfile(pathName, fileName));
        
        % add image to application, and create new display
        addImageDocument(gui, img);
    end
end % end methods

end % end classdef


classdef SaveImageAction < imagem.gui.actions.CurrentImageAction
%OPENIMAGEACTION Open an image from a file
%
%   Class SaveImageAction
%
%   Example
%   SaveImageAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-03-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function this = SaveImageAction(parent)
    % Constructor for SaveImageAction class
        
        % calls the parent constructor
        this = this@imagem.gui.actions.CurrentImageAction(parent, 'saveImage');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('Save current image');
        
        % Open dialog to save image
        [fileName, pathName] = uiputfile( ...
            {'*.gif;*.jpg;*.jpeg;*.tif;*.tiff;*.bmp;*.hdr;*.dcm;*.mhd', ...
            'All Image Files (*.tif, *.hdr, *.dcm, *.mhd, *.bmp, *.jpg)'; ...
            '*.tif;*.tiff',             'TIF Files (*.tif, *.tiff)'; ...
            '*.bmp',                    'BMP Files (*.bmp)'; ...
            '*.hdr',                    'Mayo Analyze Files (*.hdr)'; ...
            '*.dcm',                    'DICOM Files (*.dcm)'; ...
            '*.mhd;*.mha',              'MetaImage data files (*.mha, *.mhd)'; ...
            '*.*',                      'All Files (*.*)'}, ...
            'Save Image');
        
        if isequal(fileName,0) || isequal(pathName,0)
            return;
        end


        % try to save the current image
        img = this.parent.doc.image;
        try
            write(img, fullfile(pathName, fileName));
        catch ex
            errordlg(ex.message, 'Image Writing Error', 'modal');
            return;
        end
        
    end % end actionPerformed
    
end % end methods

end % end classdef


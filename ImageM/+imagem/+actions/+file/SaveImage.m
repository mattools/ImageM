classdef SaveImage < imagem.actions.CurrentImageAction
% Save the current image into a file.
%
%   Class SaveImage
%
%   Example
%   SaveImage
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-13,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = SaveImage()
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL,INUSD>
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
        doc = currentDoc(frame);
        img = doc.Image;
        try
            write(img, fullfile(pathName, fileName));
        catch ex
            errordlg(ex.message, 'Image Writing Error', 'modal');
            error(ex.message);
        end
        
        % add history
        string = sprintf('write(%s, ''%s'');\n', ...
            doc.Tag, fullfile(pathName, fileName));
        addToHistory(frame, string);
        
    end % end actionPerformed
    
end % end methods

end % end classdef


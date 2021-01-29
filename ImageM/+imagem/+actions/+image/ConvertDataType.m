classdef ConvertDataType < imagem.actions.ScalarImageAction
% Convert data type of a scalar image.
%
%   Class ConvertDataType
%
%   Example
%   ConvertDataType
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-01-29,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.


%% Properties
properties
    % The type of the data to convert to.
    % Can be one of {'uint8', 'uint16', 'float'};
    TargetType = 'uint8';
    
end % end properties


%% Constructor
methods
    function obj = ConvertDataType(targetType)
        % Constructor for ConvertDataType class.
        obj.TargetType = targetType;

    end

end % end constructors


%% Methods
methods
    function run(obj, frame)
        
        % retrieve data
        doc = currentDoc(frame);
        img = doc.Image;
        
        % process
        switch obj.TargetType
            case 'uint8'
                newType = 'grayscale';
                img2 = Image('Data', uint8(img.Data), 'Parent', img, 'Type', newType);
            case 'uint16'
                newType = 'grayscale';
                img2 = Image('Data', uint16(img.Data), 'Parent', img, 'Type', newType);
            case 'single'
                newType = 'intensity';
                img2 = Image('Data', single(img.Data), 'Parent', img, 'Type', newType);
            otherwise
                error('Unknown type to convert: %s', obj.TargetType);
        end
        
        % add image to application, and create new display
        [newFrame, newDoc] = createImageFrame(frame, img2);
        newFrame.DisplayRange = frame.DisplayRange;
        
        % additional setup for 3D images
        if isa(frame, 'imagem.gui.Image3DSliceViewer') && isa(newFrame, 'imagem.gui.Image3DSliceViewer')
            updateSliceIndex(viewer, frame.SliceIndex);
        end
        
        % add history
        string = sprintf('%s = Image(''Data'', %s(%s.Data), ''Parent'', %s, ''Type'', ''%s'');\n', ...
            newDoc.Tag, obj.TargetType, doc.Tag, doc.Tag, newType);
        addToHistory(frame, string);
    end
end % end methods

end % end classdef


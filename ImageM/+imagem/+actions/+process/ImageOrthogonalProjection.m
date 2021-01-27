classdef ImageOrthogonalProjection < imagem.actions.ScalarImageAction
% Project image intensities along one of the main directions.
%
%   Class ImageOrthogonalProjection
%
%   Example
%   ImageOrthogonalProjection
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-01-27,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = ImageOrthogonalProjection(varargin)
        % Constructor for ImageOrthogonalProjection class.

    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        
        % open dialog
        gd = imagem.gui.GenericDialog('Orthogonal Projection');
        addNumericField(gd, 'Proj. Direction: ', 3, 0);
        addChoice(gd, 'Operation: ', {'Max.', 'Min.', 'Mean'}, 'Max.');
        
        % displays the dialog, and waits for user
        showDialog(gd);
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % parse user input
        dirIndex = getNextNumber(gd);
        if dirIndex < 1 || dirIndex > 5
            error('Projection Direction must be comprised between 1 and 5');
        end
        projTypeIndex = getNextChoiceIndex(gd);
        opNameList = {'max', 'min', 'mean'};
        opName = opNameList{projTypeIndex};
        
        % retrieve data
        doc = frame.Doc;
        img = doc.Image;
        
        % compute projection
        proj = squeeze(orthogonalProjection(img, dirIndex, opName));
        
        [newFrame, newDoc] = createImageFrame(frame, proj); %#ok<ASGLU>
        
        % add history
        string = sprintf('%s = squeeze(orthogonalProjection(%s, %d, ''%s''));\n', ...
            newDoc.Tag, doc.Tag, dirIndex, opName);
        addToHistory(frame, string);

    end
end % end methods

end % end classdef


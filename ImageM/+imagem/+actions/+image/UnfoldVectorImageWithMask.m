classdef UnfoldVectorImageWithMask < imagem.actions.VectorImageAction
%UNFOLDVECTORIMAGE Transform a vector image into a Table.
%
%   Class UnfoldVectorImageWithMask
%
%
%   Example
%   UnfoldVectorImageWithMask
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-11-17,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = UnfoldVectorImageWithMask(varargin)
        % calls the parent constructor
        obj = obj@imagem.actions.VectorImageAction(varargin{:});
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        
        % get handle to current doc
        doc = currentDoc(frame);
        img = doc.Image;

        if ~isVectorImage(img)
            return;
        end
        
       
        % choose a binary image to use as mask
        gui = frame.Gui;
        imageNames = getImageNames(gui.App);
        
        gd = imagem.gui.GenericDialog();
        addChoice(gd, 'Mask Image: ', imageNames, imageNames{1});

        % displays the dialog, and waits for user
        showDialog(gd);
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % gets the user inputs
        maskImageName = getNextString(gd);
        doc = getDocument(gui.App, maskImageName);
        maskImage = doc.Image;
        if ~isBinaryImage(maskImage)
            warning('Requires a binary image as mask');
            return;
        end
        if size(maskImage, 1) ~= size(img, 1) || size(maskImage, 2) ~= size(img, 2)
            warning('Input and mask image must have same size');
            return;
        end
              
        % create sampling grid (iterating over x first)
        lx = 1:size(img, 1);
        ly = 1:size(img, 2);
        [y, x] = meshgrid(ly, lx);
        coords = [reshape(x, [numel(x) 1]), reshape(y, [numel(x) 1])];
        
        % sample elements inside mask
        coords = coords(maskImage.Data, :);
        
        % size of the table
        nr = size(coords, 1);
        nc = channelNumber(img);

        % create row names
        rowNames = cell(nr, 1);
        for i = 1:nr
            rowNames{i} = sprintf('x%03d-y%03d', coords(i,:));
        end
        
        colNames = cell(1, nc);
        for i = 1:nc
            colNames{i} = sprintf('Ch%02d', i);
        end
        
        % unfold selected pixels
        data = zeros(nr, nc);
        for j = 1:nc
            slice = img.Data(:,:,:,j);
            data(:,j) = slice(maskImage.Data);
        end
        tab = Table(data, colNames);

        coordsTable = Table(coords, {'x', 'y'}, rowNames);
        createTableFrame(frame.Gui, coordsTable);
        
        createTableFrame(frame.Gui, tab);
        
%         % create a new doc
%         newDoc = addImageDocument(frame, res);
%         
%         % add history
%         string = sprintf('%s = squeeze(slice(%s, 3, %d));\n', ...
%             newDoc.Tag, doc.Tag, sliceIndex);
%         addToHistory(frame, string);
    end
    
end % end methods

end % end classdef


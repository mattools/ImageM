classdef UnfoldVectorImage < imagem.actions.VectorImageAction
%UNFOLDVECTORIMAGE Transform a vector image into a Table.
%
%   Class UnfoldVectorImage
%
%
%   Example
%   UnfoldVectorImage
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
    function obj = UnfoldVectorImage(varargin)
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
        
        % size of the table
        nr = elementNumber(img);
        nc = channelNumber(img);
        
        lx = 1:size(img, 1);
        ly = 1:size(img, 2);
        [x, y] = meshgrid(lx, ly);
        coords = [reshape(x', [numel(x) 1]) , reshape(y',[numel(x) 1])];
        
        rowNames = cell(nr, 1);
        for i = 1:nr
            rowNames{i} = sprintf('x%03d-y%03d', coords(i,:));
        end
        
        colNames = cell(1, nc);
        for i = 1:nc
            colNames{i} = sprintf('Ch%02d', i);
        end
        
        data = reshape(img.Data, [nr nc]);
        tab = Table(data, colNames, rowNames);
        

        show(tab);
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


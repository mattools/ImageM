classdef ConvertVectorImageToImage3D < imagem.actions.CurrentImageAction
% One-line description here, please.
%
%   Class ConvertVectorImageToImage3D
%
%   Example
%   ConvertVectorImageToImage3D
%
%   See also
%     ConvertImage3DToVectorImage

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2019-11-15,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = ConvertVectorImageToImage3D(varargin)
    % Constructor for ConvertVectorImageToImage3D class

    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        
        % get handle to current doc
        doc = currentDoc(frame);
        
        % apply the conversion operation
        res = permute(doc.Image, [1 2 4 3 5]);
        
        % create a new doc
        newDoc = addImageDocument(frame, res);
        
        % add history
        string = sprintf('%s = permute(%s, [1 2 4 3 5]);\n', ...
            newDoc.Tag, doc.Tag);
        addToHistory(frame, string);
    end

    
    function b = isActivable(obj, frame)
        b = isActivable@imagem.actions.CurrentImageAction(obj, frame);
        if b
            b = isVectorImage(currentImage(frame));
        end
    end
    
end % end methods

end % end classdef


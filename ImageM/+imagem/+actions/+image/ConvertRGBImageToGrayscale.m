classdef ConvertRGBImageToGrayscale < imagem.actions.CurrentImageAction
% One-line description here, please.
%
%   Class ConvertRGBImageToGrayscale
%
%   Example
%   ConvertRGBImageToGrayscale
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-04-08,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = ConvertRGBImageToGrayscale(varargin)
        % Constructor for ConvertRGBImageToGrayscale class.

    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        
        % get handle to current doc
        doc = frame.Doc;
        
        % check image type
        if ~isColorImage(doc.Image)
            errordlg('Requires a Color image', 'Image Format Error');
            return;
        end
        
        % convert RGB image to grayscale image with uint8 data
        res = rgb2gray(doc.Image);
        
        % add new image to application, and create new display
        [frame2, doc2] = createImageFrame(frame, res); %#ok<ASGLU>
        
        % add history
        string = sprintf('%s = rgb2gray(%s);\n', ...
            doc2.Tag, doc.Tag);
        addToHistory(frame, string);
    end
    
    
    function b = isActivable(obj, frame) %#ok<INUSL>
        doc = frame.Doc;
        b = ~isempty(doc) && ~isempty(doc.Image) && isColorImage(doc.Image);
    end
    
end % end methods

end % end classdef


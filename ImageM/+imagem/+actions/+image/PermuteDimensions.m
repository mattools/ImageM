classdef PermuteDimensions < imagem.actions.CurrentImageAction
% Re-order the dimensions of an image.
%
%   Class PermuteDimensions
%
%   Example
%   PermuteDimensions
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-02-14,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2020 INRAE - BIA-BIBS.


%% Properties
properties

end % end properties


%% Constructor
methods
    function obj = PermuteDimensions(varargin)
        % Constructor for PermuteDimensions class

    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        
        % get handle to current doc
        doc = currentDoc(frame);
        img = doc.Image;
        
        % Create the string for ordering dimensions
        nd = 5;
        baseString = ['1' sprintf(repmat(', %d', 1, nd-1), 2:nd)];        

        % creates a new dialog, and populates it with some fields
        gd = imagem.gui.GenericDialog('Permute Dimensions');
        
        addTextField(gd, 'New Order: ', baseString);
                
        % displays the dialog, and waits for user
        showDialog(gd);
        
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % get dialog options
        orderString = getNextString(gd);
        tokens = strsplit(orderString, ', ');
        inds = str2num(char(tokens')); %#ok<ST2NM>
        
        % create image with permuted dimensions
        res = permute(img, inds);
        
        % add image to application, and create new display
        [viewer2, doc2] = createImageFrame(frame.Gui, res);
        
        % keep display settings if channel dim stays the same
        if inds(4) == 4
            viewer2.DisplayRange = frame.DisplayRange;
        end

        % add history
        newDimsString = sprintf('[%d %d %d %d %d]', inds);
        string = sprintf('%s = permute(%s, %s);\n', ...
             doc2.Tag, doc.Tag, newDimsString);
        addToHistory(frame, string);
    end

end % end methods

end % end classdef


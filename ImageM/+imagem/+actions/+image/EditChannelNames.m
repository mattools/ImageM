classdef EditChannelNames < imagem.actions.VectorImageAction
% Edit channel names of a color or vector image.
%
%   Class EditChannelNames
%
%   Example
%   EditChannelNames
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2020-01-04,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2020 INRA - BIA-BIBS.


%% Properties
properties
    % list of handles on the dialog widgets
    Handles;
    
    Viewer;

end % end properties


%% Constructor
methods
    function obj = EditChannelNames(varargin)
    % Constructor for EditChannelNames class

    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSD>
%         disp('Compute Image median filter');
        
        % get handle to current doc
        obj.Viewer = frame;
        img = currentImage(obj.Viewer);
        
        % creates a new dialog, and populates it with some fields
        gd = imagem.gui.GenericDialog('Edit Channel Names');
        obj.Handles.Dialog = gd;
        
        % retrieve channel names of current image
        nChannels = channelNumber(img);
        names = img.ChannelNames;
        if length(names) ~= nChannels
            names = cell(1, nChannels);
        end
        
        for ic = 1:nChannels
            addTextField(gd, sprintf('Channel %d: ', ic), names{ic});
        end
                
        % displays the dialog, and waits for user
        showDialog(gd);
        
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % get dialog options
        newNames = cell(1, nChannels);
        for ic = 1:nChannels
            newNames{ic} = getNextString(gd);
        end

        img.ChannelNames = newNames;
%         % add history
%         string = sprintf('%s = medianFilter(%s, ones(%d,%d));\n', ...
%             newDoc.Tag, doc.Tag, width, height);
%         addToHistory(obj.Viewer, string);
    end

end % end methods

end % end classdef


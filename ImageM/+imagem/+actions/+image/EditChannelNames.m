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
        
        % get handle to current doc
        obj.Viewer = frame;
        img = currentImage(obj.Viewer);
        
        % retrieve channel names of current image, or create them if empty
        nc = channelCount(img);
        names = img.ChannelNames;
        if length(names) ~= nc
            names = cell(1, nc);
        end
        
        % creates a new dialog, and populates it with some fields
        gd = imagem.gui.GenericDialog('Edit Channel Names');
        for ic = 1:nc
            addTextField(gd, sprintf('Channel %d: ', ic), names{ic});
        end
                
        % displays the dialog, and waits for user
        showDialog(gd);
        
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % retrieve new channel names
        newNames = cell(1, nc);
        for ic = 1:nc
            newNames{ic} = getNextString(gd);
        end
        
        % update image
        img.ChannelNames = newNames;
        
        % add history
        pattern = ['{''%s''' repmat(', ''%s''', 1, nc-1)   '}'];
        namesString = sprintf(pattern, newNames{:});
        string = sprintf('%s.ChannelNames = %s\n', ...
            obj.Viewer.Doc.Tag, namesString);
        addToHistory(obj.Viewer, string);
    end

end % end methods

end % end classdef


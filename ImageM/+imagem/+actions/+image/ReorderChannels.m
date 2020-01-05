classdef ReorderChannels < imagem.actions.VectorImageAction
% Change order of channels of a vector image.
%
%   Class ReorderChannels
%
%   Example
%   ReorderChannels
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
    function obj = ReorderChannels(varargin)
    % Constructor for ReorderChannels class

    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSD>
%         disp('Compute Image median filter');
        
        % get handle to current doc
        obj.Viewer = frame;
        img = currentImage(obj.Viewer);
        
        % Create the string for ordering labels
        nChannels = channelNumber(img);
        baseString = ['1' sprintf(repmat(',%d', 1, nChannels-1), 2:nChannels)];        

        % creates a new dialog, and populates it with some fields
        gd = imagem.gui.GenericDialog('Edit Channel Names');
        obj.Handles.Dialog = gd;
        
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
        
        res = Image('data', img.Data(:,:,:,inds,:), ...
            'parent', img, ...
            'ChannelNames', img.ChannelNames(inds));
        
        % add image to application, and create new display
        [doc2, viewer2] = addImageDocument(frame, res); %#ok<ASGLU>
        viewer2.DisplayRange = frame.DisplayRange;
        
        % additional setup for 3D images
        if isa(frame, 'imagem.gui.Image3DSliceViewer') && isa(viewer, 'imagem.gui.Image3DSliceViewer')
            updateSliceIndex(viewer2, frame.SliceIndex);
        end

%         % add history
%         string = sprintf('%s = medianFilter(%s, ones(%d,%d));\n', ...
%             newDoc.Tag, doc.Tag, width, height);
%         addToHistory(obj.Viewer, string);
    end

end % end methods

end % end classdef


classdef ImageKMeansSegmentation < imagem.actions.CurrentImageAction
% One-line description here, please.
%
%   Class ImageKMeansSegmentation
%
%   Example
%   ImageKMeansSegmentation
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
    function obj = ImageKMeansSegmentation(varargin)
        % Constructor for ImageKMeansSegmentation class.

    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        % Apply k-means segmentation on the current image.
        
        
        % open dialog
        gd = imagem.gui.GenericDialog('K-Means Segmentation');
        addNumericField(gd, 'Class Number: ', 3, 0);
        addCheckBox(gd, 'Display class image', true);
        addCheckBox(gd, 'Display average values image', true);
        addCheckBox(gd, 'Show centroid table', false);
        
        % displays the dialog, and waits for user
        showDialog(gd);
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % parse user input
        nClasses = getNextNumber(gd);
        displayClasses = getNextBoolean(gd);
        displayAverage = getNextBoolean(gd);
        displayCentroids = getNextBoolean(gd);
        
        
        % apply k-means algorithm
        img = currentImage(frame);
        [classes, centroids] = kmeans(img, nClasses);
        
        
        % process display
        if displayClasses
            [newFrame2, newDoc] = createImageFrame(frame, classes); %#ok<ASGLU>
        end
        if displayAverage
            % Compute average image of each class, iterating over channels
            nc = channelCount(img);
            avgData = zeros(size(img.Data), class(img.Data));
            for iChannel = 1:nc
                channel = avgData(:,:,:,iChannel,:);
                for iClass = 1:nClasses
                    channel(classes.Data == iClass) = centroids(iClass, iChannel);
                end
                avgData(:,:,:,iChannel,:) = channel;
            end
            
            % create average image
            avg = Image('Data', avgData, 'Parent', img);
            avg.Name = sprintf('%s-kmeans%d-Average', img.Name, nClasses);
            
            % create frame to display synthetic image
            [avgFrame2, avgDoc] = createImageFrame(frame, avg); %#ok<ASGLU>
        end
        
        if displayCentroids
            tab = Table(centroids);
            tab.Name = sprintf('%s-kmeans%d-Centroids', img.Name, nClasses);
            if ~isempty(img.ChannelNames)
                tab.ColNames = img.ChannelNames;
            end
            
            [tabFrame, tabDoc] = createTableFrame(frame.Gui, tab); %#ok<ASGLU>
        end
        
    end
end % end methods

end % end classdef


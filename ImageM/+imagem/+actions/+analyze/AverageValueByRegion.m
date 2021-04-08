classdef AverageValueByRegion < imagem.actions.CurrentImageAction
% One-line description here, please.
%
%   Class AverageValueByRegion
%
%   Example
%   AverageValueByRegion
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-12-23,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = AverageValueByRegion(varargin)
        % Constructor for AverageValueByRegion class.
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        
        app = frame.Gui.App;
        imageNames = getImageNames(app);
        
        % creates a new dialog, and populates it with some fields
        gd = imagem.gui.GenericDialog('Average Value by Region');
        addChoice(gd, 'Label image of regions:', imageNames, imageNames{1});
        addChoice(gd, 'Image of intensities:', imageNames, imageNames{1});
        
        % displays the dialog, and waits for user
        showDialog(gd);
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % parse the user inputs
        labelImageName = getNextString(gd);
        intensityImageName = getNextString(gd);
        
        % check label image
        labelImageDoc = getImageDocument(app, labelImageName);
        labelImage = labelImageDoc.Image;
        if ~isLabelImage(labelImage)
            warning('Requires region image to be a label image');
            return;
        end
        
        % retrieve intensity image
        intensityImageDoc = getImageDocument(app, intensityImageName);
        intensityImage = intensityImageDoc.Image;
        

        % get labels
        labels = unique(labelImage.Data(:));
        labels(labels == 0) = [];
        nLabels = length(labels);
        
        if isScalarImage(intensityImage)
            resData = zeros(nLabels, 1);
            for i = 1:nLabels
                resData(i) = mean(intensityImage.Data(labelImage.Data == labels(i)));
            end
            res = Table(resData, {'Mean'});
            
        elseif isVectorImage(intensityImage)
            nc = channelCount(intensityImage);
            resData = zeros(nLabels, nc);
            
            for ic = 1:nc
                channelImage = channel(intensityImage, ic);
                for i = 1:nLabels
                    resData(i, ic) = mean(channelImage.Data(labelImage.Data == labels(i)));
                end
            end
            
            channelNames = intensityImage.ChannelNames;
            if isempty(channelNames) || length(channelNames) ~= nc
                channelNames = cellstr(num2str((1:nc)', 'Ch%02d'))';
            end
            res = Table(resData, channelNames);

        else
            error(['Can not manage type of image: ' intensityImage.Name]);
        end

        % create first axis
        if isprop(res, 'Axes')
            res.Axes{1} = table.axis.NumericalAxis('Label', labels(:)');
        end
        res.Name = [intensityImage.Name '-AverageValues'];
        
        % display in a new table
        createTableFrame(frame.Gui, res);
    end
end % end methods

end % end classdef


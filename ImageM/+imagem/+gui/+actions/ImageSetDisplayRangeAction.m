classdef ImageSetDisplayRangeAction < imagem.gui.actions.CurrentImageAction
% Change the values corresponding to black and white in display.
%
%   Class ImageSetDisplayRangeAction
%
%   Example
%   ImageSetDisplayRangeAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2016-01-06,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2016 INRA - BIA-BIBS.
    

%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = ImageSetDisplayRangeAction(viewer, varargin)
        % Constructor for ImageSetDisplayRangeAction class
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, 'setDisplayRangeManual');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, src, event) %#ok<INUSD>

        % get handle to viewer figure, doc, and image
        viewer = obj.Viewer;
        img = currentImage(obj);

        if ~ismember(img.Type, {'grayscale', 'intensity', 'label'})
            return;
        end

        % get extreme values for grayscale in image
        mini = min(img);
        maxi = max(img);

        % get actual value for grayscale range
        clim = get(viewer.Handles.ImageAxis, 'CLim');

        % define dialog options
        if isinteger(mini)
            prompt = {...
                sprintf('Min grayscale value (%d):', mini), ...
                sprintf('Max grayscale value (%d):', maxi)};
        else
            prompt = {...
                sprintf('Min grayscale value (%f):', mini), ...
                sprintf('Max grayscale value (%f):', maxi)};
        end
        title = 'Input for grayscale range';
        nbLines = 1;
        default = {num2str(clim(1)), num2str(clim(2))};

        % open the dialog
        answer = inputdlg(prompt, title, nbLines, default);

        % if user cancel, return
        if isempty(answer)
            return;
        end

        % convert input texts into numerical values
        mini = str2double(answer{1});
        maxi = str2double(answer{2});
        if isnan(mini) || isnan(maxi)
            return;
        end

        viewer.DisplayRange = [mini maxi];
        set(viewer.Handles.ImageAxis, 'CLim', [mini maxi]);
    end
end % end methods

end % end classdef


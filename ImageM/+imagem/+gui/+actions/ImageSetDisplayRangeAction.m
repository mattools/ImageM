classdef ImageSetDisplayRangeAction < imagem.gui.actions.CurrentImageAction
    %IMAGESETDISPLAYRANGEACTION  Change the values corresponding to black and white in display
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
    % e-mail: david.legland@nantes.inra.fr
    % Created: 2016-01-06,    using Matlab 8.6.0.267246 (R2015b)
    % Copyright 2016 INRA - BIA-BIBS.
    
    
    %% Properties
    properties
    end % end properties
    
    
    %% Constructor
    methods
        function this = ImageSetDisplayRangeAction(viewer, varargin)
            % Constructor for ImageSetDisplayRangeAction class
            this = this@imagem.gui.actions.CurrentImageAction(viewer, 'setDisplayRangeManual');
        end
        
    end % end constructors
    
    
    %% Methods
    methods
        function actionPerformed(this, src, event) %#ok<INUSD>
            
            % get handle to viewer figure, doc, and image
            viewer = this.viewer;
            doc = viewer.doc;
            
            if ~ismember(doc.image.type, {'grayscale', 'intensity', 'label'})
                return;
            end
            
            % get extreme values for grayscale in image
            minimg = min(doc.image.data(:));
            maximg = max(doc.image.data(:));
            
            % get actual value for grayscale range
            clim = get(viewer.handles.imageAxis, 'CLim');
            
            % define dialog options
            if isinteger(minimg)
                prompt = {...
                    sprintf('Min grayscale value (%d):', minimg), ...
                    sprintf('Max grayscale value (%d):', maximg)};
            else
                prompt = {...
                    sprintf('Min grayscale value (%f):', minimg), ...
                    sprintf('Max grayscale value (%f):', maximg)};
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
            
            viewer.displayRange = [mini maxi];
            set(viewer.handles.imageAxis, 'CLim', [mini maxi]);
        end
    end % end methods
    
end % end classdef


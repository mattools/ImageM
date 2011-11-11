classdef PlanarImageDisplay < imagem.gui.ImageDisplay
%PLANARIMAGEDISPLAY  One-line description here, please.
%
%   Deprecated: replaced by PlanarImageViewer
%
%   Example
%   PlanarImageDisplay
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-10-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    % handle to the figure
    hFig;
    
    % list of handles to the varisous gui items
    handles;

end % end properties


%% Constructor
methods
    function this = PlanarImageDisplay(varargin)
    % Constructor for PlanarImageDisplay class
        this = this@imagem.gui.ImageDisplay(varargin{:});
        
        setupLayout();
        
        function setupLayout
            
            % scrollable panel for image display
            scrollPanel = uipanel('Parent', this.panel);
%             scrollPanel = uipanel('Parent', this.panel, ...
%                 'resizeFcn', @this.onScrollPanelResized);
            
            ax = axes('parent', scrollPanel, ...
                'units', 'normalized', ...
                'position', [0 0 1 1]);
            
            % intialize image display with default image. 
            hIm = imshow(ones(10, 10), 'parent', ax);
            this.handles.scrollPanel = imscrollpanel(scrollPanel, hIm);
            
            % keep widgets handles
            this.handles.imageAxis = ax;
            this.handles.image = hIm;

            % once each panel has been resized, setup image magnification
            api = iptgetapi(this.handles.scrollPanel);
            mag = api.findFitMag();
            api.setMagnification(mag);
            
        end
    end

end % end constructors


%% Methods
methods
    
    function refreshDisplay(this)
        % Refresh image display of the current slice
        
        api = iptgetapi(this.handles.scrollPanel);
        api.replaceImage(permute(this.image.data, [2 1 3]));
        
        % extract calibration data
        spacing = this.image.spacing;
        origin  = this.image.origin;
        
        % set up spatial calibration
        dim     = size(this.image);
        xdata   = ([0 dim(1)-1] * spacing(1) + origin(1));
        ydata   = ([0 dim(2)-1] * spacing(2) + origin(2));
        
        set(this.handles.image, 'XData', xdata);
        set(this.handles.image, 'YData', ydata);
        
        % setup axis extent from imaeg extent
        extent = physicalExtent(this.image);
        set(this.handles.imageAxis, 'XLim', extent(1:2));
        set(this.handles.imageAxis, 'YLim', extent(3:4));
        
%         % for grayscale and vector images, adjust displayrange and LUT
%         if ~strcmp(this.image.type, 'color')
%             set(this.handles.imageAxis, 'CLim', this.displayRange);
%             colormap(this.handles.imageAxis, this.lut);
%         end
        
        % adjust zoom to view the full image
        api = iptgetapi(this.handles.scrollPanel);
        mag = api.findFitMag();
        api.setMagnification(mag);
    end
    


end % end methods

end % end classdef


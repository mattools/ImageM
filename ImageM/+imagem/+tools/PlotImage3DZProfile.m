classdef PlotImage3DZProfile < imagem.gui.Tool & imagem.gui.events.ImageDisplayListener
% Open a plot frame and display the Z-Profile of selected points.
%
%   Class PlotImage3DZProfile
%
%   Example
%   PlotImage3DZProfile
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-11-15,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    Handles;
    
    LastClickedPoint;
    
end % end properties


%% Constructor
methods
    function obj = PlotImage3DZProfile(viewer, varargin)
        % Constructor for PlotImage3DZProfile class
        obj = obj@imagem.gui.Tool(viewer, 'PlotImage3DZProfile');
        
        % initialize properties
        obj.Handles = struct();
    end

end % end constructors


%% Implements Tool methods
methods
    function select(obj) %#ok<*MANU>
        disp('select PlotImage3DZProfile');
        
        % creates a new figure for displaying spectrum
        obj.Handles.Figure = figure( ...
            'Name', 'Z-Profile', ...
            'MenuBar', 'None', ...
            'NumberTitle', 'Off', ...
            'DeleteFcn', @(src,evt)obj.close(src,evt));
        
%         % add to list of sub-figures
%         obj.Handles.SubFigures = [obj.Handles.SubFigures, obj.Handles.Figure];
        
        % get image 
        img = obj.Viewer.Doc.Image;
        displayRange = [min(img.Data(:)) max(img.Data(:))];
        sliceIndex = obj.Viewer.SliceIndex;

        % configure axis
        ax = gca;
        hold(ax, 'on');
        set(ax, 'xlim', [1 size(img, 3)]);
        set(ax, 'ylim', displayRange);
        titleStr = 'Z-Profile';
        if ~isempty(img.Name)
            titleStr = [titleStr ' of ' img.Name];
        end
        title(ax, titleStr, 'Interpreter', 'None');
        xlabel(ax, 'Slice index');
        ylabel(ax, 'Image intensity');
        
        % plot line marker for current slice
        obj.Handles.ZLine = plot(ax, [sliceIndex sliceIndex], displayRange, 'k');
        
        % store settings
        userdata = struct('profiles', [], 'profileHandles', [], 'zLineHandle', obj.Handles.ZLine);
        set(gca, 'userdata', userdata);
        obj.Handles.ZProfileAxis = ax;
        
        % use this tool as image display listener
        addImageDisplayListener(obj.Viewer, obj);
        
%         % set menu entry to true
%         set(src, 'Checked', 'On');
            
    end
    
    function deselect(obj)
        disp('deselect PlotImage3DZProfile');
        % cleanup listeners
%         removeMouseListener(obj.Viewer, obj);
%         removeImageDisplayListener(obj.Viewer, obj);
    end
    
    % Overload default Tool methods
    function b = isActivable(obj)
        doc = currentDoc(obj.Viewer);
        b = ~isempty(doc) && ~isempty(doc.Image);
        if b
            b = b && is3dImage(doc.Image);
        end
    end
end



%% Implements Mouse Listener methods
methods
    function onMouseButtonPressed(obj, hObject, eventdata) %#ok<INUSD>
        
        pos = get(obj.Viewer.Handles.ImageAxis, 'CurrentPoint');
        obj.LastClickedPoint = pos(1,:);

        fprintf('%f %f\n', pos(1, 1:2));
        
        img = obj.Viewer.Doc.Image;
        coord = round(pointToIndex(img, pos(1, 1:2)));
        coord = coord(1:2);
        
        % control on bounds of image
        if sum(coord < 1) > 0 || sum(coord > [size(img, 1) size(img,2)]) > 0
            return;
        end

        % extract profile
        profile = permute(img.Data(coord(1), coord(2), :, :), [4 3 1 2]);
        
        % add profile to axis user data
        userdata = get(obj.Handles.ZProfileAxis, 'userdata');
%         if strcmp(get(obj.Handles.Figure, 'SelectionType'), 'normal')
%             % replace profile list with current profile
%             userdata.profiles = profile;
%             delete(userdata.profileHandles);
            h = plot(obj.Handles.ZProfileAxis, profile, 'b');
%             userdata.profileHandles = h;
%         else
%             % add the current profile to profile list
%             userdata.profiles = [userdata.profiles profile];
%             h = plot(obj.Handles.ZProfileAxis, profile, 'b');
%             userdata.profileHandles = [userdata.profileHandles h];
%         end
        
        set(obj.Handles.ZProfileAxis, 'userdata', userdata);

    end
    
    function onMouseButtonReleased(obj, hObject, eventdata) %#ok<INUSD>
    end
    
    function onMouseMoved(obj, hObject, eventdata) %#ok<INUSD>
    end
    
end % mouse listener methods

%% Implements Image Display Listener methods
methods
    function onDisplayRangeChanged(obj, source, event)
        disp('process change in display range');
    end
    
    function onCurrentSliceChanged(obj, source, event)
        % Update position of Z-line on Z-profile plot
        
        % get 3D Slice viewer
        viewer = obj.Viewer;

        % update position of Z line marker
        set(obj.Handles.ZLine, 'XData', [viewer.SliceIndex viewer.SliceIndex]);
        set(obj.Handles.ZLine, 'YData', viewer.DisplayRange);
    end
    
    function onCurrentChannelChanged(obj, source, event)
        disp('process change in current channel');
    end
end % image display methods


%% Implements Figure methods
methods
    function close(obj, varargin)
        disp('close ZProfile figure');
        deselect(obj);
        
        if ishghandle(obj.Handles.Figure)
            delete(obj.Handles.Figure);
        end
    end
end

end % end classdef


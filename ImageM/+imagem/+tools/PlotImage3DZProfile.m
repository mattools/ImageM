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
% e-mail: david.legland@inrae.fr
% Created: 2019-11-15,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRAE - BIA-BIBS.


%% Properties
properties
    % Handles to widgets, as a struct.
    % Handle list:
    % * Figure;
    % * ZProfileAxis
    % * ZLine
    Handles;
    
    LastClickedPoint;
    
    MarkerCoords = zeros(0, 2);
    
    DisplayMarkers = true;
    
    MarkerStyle = '+';
    MarkerColor = [1 0 0];
    MarkerLineWidth = 1;
    
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


%% Mehods specific to the tool
methods
    function clearCurves(obj)
        % Clear the curves, and the associated markers.
        
        if ~isempty(obj.Handles.Profiles)
            delete(obj.Handles.Profiles);
            obj.Handles.Profiles = [];
        end
        
        clearMarkers(obj);
    end
    
    function updateMarkers(obj)
        % update display of markers.
        if ~isempty(obj.Handles.Markers) && ishghandle(obj.Handles.Markers)
            set(obj.Handles.Markers, 'XData', obj.MarkerCoords(:,1));
            set(obj.Handles.Markers, 'YData', obj.MarkerCoords(:,2));
        else
            obj.Handles.Markers = plot(obj.Handles.ImageAxis, ...
                obj.MarkerCoords(:,1), obj.MarkerCoords(:,2), 'r+');
        end
        
        set(obj.Handles.Markers, 'Marker',      obj.MarkerStyle);
        set(obj.Handles.Markers, 'Color',       obj.MarkerColor);
        set(obj.Handles.Markers, 'LineWidth',   obj.MarkerLineWidth);
        set(obj.Handles.Markers, 'Visible', booleanToObOff(obj.DisplayMarkers));
    end
    
    function clearMarkers(obj)
        % Remove marker handles from image display.
        if ~isempty(obj.Handles.Markers)
            delete(obj.Handles.Markers);
            obj.Handles.Markers = [];
        end
        obj.MarkerCoords = zeros(0, 2);
    end
end


%% Implements Tool methods
methods
    function select(obj) %#ok<*MANU>
        disp('select PlotImage3DZProfile');
        
        % reset state
        obj.MarkerCoords = [];
        
        % reset references to widgets
        obj.Handles.Markers = [];
        obj.Handles.Profiles = [];
        
        % keep handle to axis object containing image, for drawing markers
        obj.Handles.ImageAxis = obj.Viewer.Handles.ImageAxis;
        
        createFigure(obj);
        
        % use this tool as image display listener
        addImageDisplayListener(obj.Viewer, obj);
    end
    
    
    function deselect(obj)
        disp('deselect PlotImage3DZProfile');
        % cleanup listeners
%         removeMouseListener(obj.Viewer, obj);
%         removeImageDisplayListener(obj.Viewer, obj);
    end
end

methods (Access = private)
    function createFigure(obj)
        % Initialize figure for profile display.
        
        % get image from calling frame
        img = obj.Viewer.Doc.Image;
        displayRange = [min(img.Data(:)) max(img.Data(:))];
        sliceIndex = obj.Viewer.SliceIndex;

        % creates a new figure for displaying spectrum
        obj.Handles.Figure = figure( ...
            'Name', 'Z-Profile', ...
            'MenuBar', 'None', ...
            'NumberTitle', 'Off', ...
            'DeleteFcn', @(src,evt)obj.close(src,evt));
        
        createMenu(obj);
        
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
    end
    
    function createMenu(obj)
        
        hFig = obj.Handles.Figure;
        fileMenu = uimenu(hFig, 'Label', 'File');
        uimenu(fileMenu, 'Label', 'Close', ...
            'Callback', @(src, evt) onSelectMenuClose(obj, src, evt));

        editMenu = uimenu(hFig, 'Label', 'Edit');
        uimenu(editMenu, 'Label', 'Display Markers', ...
            'Checked', booleanToObOff(obj.DisplayMarkers), ...
            'Callback', @(src, evt) onSelectMenuToggleMarkersDisplay(obj, src, evt));
        uimenu(editMenu, 'Label', 'Clear Curves', ...
            'Callback', @(src, evt) onSelectMenuClearCurves(obj, src, evt));        
    end
    
    function onSelectMenuClose(obj, src, evt) %#ok<INUSD>
        disp('close');
        clearMarkers(obj);
        close(obj);
    end
    
    function onSelectMenuToggleMarkersDisplay(obj, src, evt) %#ok<INUSD>
        disp('toggle marker display');
        state = obj.DisplayMarkers;
        state = ~state;
        obj.DisplayMarkers = state;
        set(src, 'Checked', booleanToObOff(state));
        
        updateMarkers(obj);
    end
    
    function onSelectMenuClearCurves(obj, src, evt) %#ok<INUSD>
        disp('clear curves (and markers...)');
        clearCurves(obj);
    end
end


methods
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
        coord = round(pointToIndex(img, [pos(1, 1:2) obj.Viewer.SliceIndex]));
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
            obj.Handles.Profiles = [obj.Handles.Profiles h];
%             userdata.profileHandles = h;
%         else
%             % add the current profile to profile list
%             userdata.profiles = [userdata.profiles profile];
%             h = plot(obj.Handles.ZProfileAxis, profile, 'b');
%             userdata.profileHandles = [userdata.profileHandles h];
%         end
        
        set(obj.Handles.ZProfileAxis, 'userdata', userdata);

        obj.MarkerCoords = [obj.MarkerCoords ; coord];
%         if isempty(obj.Handles.Markers)
%             obj.Handles.Markers = plot(obj.Handles.ImageAxis, ...
%                 obj.MarkerCoords(:,1), obj.MarkerCoords(:,2), 'r+');
%         end
        updateMarkers(obj);
    end
    
    function onMouseButtonReleased(obj, hObject, eventdata) %#ok<INUSD>
    end
    
    function onMouseMoved(obj, hObject, eventdata) %#ok<INUSD>
    end
    
end % mouse listener methods

%% Implements Image Display Listener methods
methods
    function onDisplayRangeChanged(obj, source, event) %#ok<INUSD>
        disp('process change in display range');
    end
    
    function onCurrentSliceChanged(obj, source, event) %#ok<INUSD>
        % Update position of Z-line on Z-profile plot
        
        % get 3D Slice viewer
        viewer = obj.Viewer;

        % update position of Z line marker
        set(obj.Handles.ZLine, 'XData', [viewer.SliceIndex viewer.SliceIndex]);
        set(obj.Handles.ZLine, 'YData', viewer.DisplayRange);
    end
    
    function onCurrentChannelChanged(obj, source, event) %#ok<INUSD>
        disp('process change in current channel');
    end
end % image display methods


%% Implements Figure methods
methods
    function close(obj, varargin)
        disp('close ZProfile figure');
        
        clearMarkers(obj);
        
        deselect(obj);
        
        if ishghandle(obj.Handles.Figure)
            delete(obj.Handles.Figure);
        end
    end
end

end % end classdef

function str = booleanToObOff(b)
if b
    str = 'on';
else
    str = 'off';
end
end
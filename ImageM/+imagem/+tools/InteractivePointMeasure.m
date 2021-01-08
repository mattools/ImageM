classdef InteractivePointMeasure < imagem.gui.Tool
% One-line description here, please.
%
%   Class InteractivePointMeasure
%
%   Example
%   InteractivePointMeasure
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-01-08,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.


%% Properties
properties
    MeasureTable = [];
    
    TableView = [];
    
    % the list of point positions, as a N-by-2 array
    Positions = [];
    
    % handle to the graphical item
    PointsHandle;
   
end % end properties


%% Constructor
methods
    function obj = InteractivePointMeasure(parent, varargin)
        % Constructor for InteractivePointMeasure class.
        obj = obj@imagem.gui.Tool(parent, 'interactivePointMeasure');
        
                
        doc = currentDoc(obj);
        img = doc.Image;
        
        disp('interactive measure of points (double click to end)');
        
        % generate coordinate names
        nd = ndims(img);
        if nd == 2
            coordNames = {'x', 'y'};
        else
            coordNames = {'x', 'y', 'z'};
        end
        
        % generate channel names
        nc = channelCount(img);
        channelNames = img.ChannelNames;
        if length(channelNames) ~= nc
            if nc == 1
                channelNames = {'Value'};
            else
                channelNames = cellstr(num2str((1:nc)', 'C%02d'))';
            end
        end
        
        % create empty table
        nCols = nd + nc;
        colNames = [coordNames channelNames];
        tab = Table(zeros([0 nCols]), colNames);
        tab.Name = [img.Name '-measures'];
        obj.MeasureTable = tab;
        
        % create table viewer
        [newFrame, newDoc] = createTableFrame(obj.Viewer.Gui, tab, obj.Viewer);
        newDoc.ImageSize = size(img, 1:ndims(img));
        
        obj.TableView = newFrame;
    end

end % end constructors


%% Methods
methods
    function onMouseButtonPressed(obj, hObject, eventdata) %#ok<INUSD>
        
        % check the tool is still in measure mode
        if isempty(obj.MeasureTable)
            return;
        end
        % check the figure was not closed...
        if ~ishandle(obj.TableView.Handles.Figure)
            return;
        end
        
        doc = currentDoc(obj);
        img = doc.Image;
        
        % check if right-clicked or double-clicked
        type = get(obj.Viewer.Handles.Figure, 'SelectionType');
        if ~strcmp(type, 'normal')
            % clear inner data
            obj.MeasureTable = [];
            obj.TableView = [];
            return;
        end

        point = get(obj.Viewer.Handles.ImageAxis, 'CurrentPoint');
        coords = round(pointToIndex(obj, point(1, 1:2)));
        
        % update viewer's current selection
        shape = struct('Type', 'PointSet', 'Data', obj.Positions);
        obj.Viewer.Selection = shape;
        
        % udpate position list
        if size(obj.Positions, 1) == 0
            obj.Positions = coords(1,1:2);
            % if clicked first point, creates a new graphical object
            removePointsHandle(obj);
            obj.PointsHandle = line(...
                'XData', coords(1,1), 'YData', coords(1,2), ...
                'LineStyle', 'none', ...
                'Marker', '+', ...
                'MarkerSize', 6, 'LineWidth', 2, ...
                'Color', 'b');
        else
            obj.Positions = [obj.Positions ; coords(1,1:2)];
            % update graphical object
            set(obj.PointsHandle, 'xdata', obj.Positions(:,1));
            set(obj.PointsHandle, 'ydata', obj.Positions(:,2));
        end
        
        pos = [num2cell(coords), {1, ':'}];
       
        if isa(obj.Viewer, 'Image3DSliceViewer')
            coords = [coords obj.Viewer.SliceIndex];
            pos{3} = [num2cell(coords), {':'}];
        end
        
        if isScalarImage(img)
            value = img.Data(pos{:});
            row = [coords double(value)];
        else
            values = img.Data(pos{:});
            row = [coords double(values(:)')];
        end
        
        addRow(obj.MeasureTable, row);
        repaint(obj.TableView);
    end
    
    function index = pointToIndex(obj, point)
       % Converts coordinates of a point in physical dimension to image index
       % First element is column index, second element is row index, both are
       % given in floating point and no rounding is performed.
       doc = currentDoc(obj);
       img = doc.Image;
       spacing = img.Spacing(1:2);
       origin  = img.Origin(1:2);
       index   = (point - origin) ./ spacing + 1;
   end

    function deselect(obj)
        removePointsHandle(obj);
    end
    
    function removePointsHandle(obj)
        if ~ishandle(obj.PointsHandle)
            return;
        end
        
        ax = obj.Viewer.Handles.ImageAxis;
        if isempty(ax)
            return;
        end
       
        delete(obj.PointsHandle);
    end
    
end % end methods


methods
    function b = isActivable(obj)
        doc = obj.Viewer.Doc;
        b = ~isempty(doc) && ~isempty(doc.Image);
    end
end

end % end classdef


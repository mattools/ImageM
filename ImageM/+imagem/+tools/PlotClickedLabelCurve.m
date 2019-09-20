classdef PlotClickedLabelCurve < imagem.gui.Tool
%PLOTCLICKEDLABELCURVE  One-line description here, please.
%
%   Class PlotClickedLabelCurve
%
%   Example
%   PlotClickedLabelCurve
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-09-18,    using Matlab 9.6.0.1072779 (R2019a)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    Table;
    
    XData;
    
    Handles;
    
end % end properties


%% Constructor
methods
    function obj = PlotClickedLabelCurve(viewer, tab, varargin)
        % Constructor for PlotClickedLabelCurve class

        obj = obj@imagem.gui.Tool(viewer, 'plotLabelCurve');
        
        obj.Table = tab;
        
        obj.Handles.Figure = figure;
        h = plotRows(tab, 'color', [.5 .5 .5]);
        obj.Handles.AllRows = h;
        
        obj.XData = get(h(1), 'XData');
        
        obj.Handles.MainAxis = get(obj.Handles.Figure, 'Children');
        hold(obj.Handles.MainAxis, 'on');
        obj.Handles.CurrentRow = [];
        
    end

end % end constructors


%% Methods
methods

    function onMouseButtonPressed(obj, hObject, eventdata) %#ok<INUSD>

        doc = obj.Viewer.Doc;
        img = doc.Image;
        
        if ~isLabelImage(img)
            return;
        end
        
        point = get(obj.Viewer.Handles.ImageAxis, 'CurrentPoint');
        coord = round(pointToIndex(img, point(1, 1:2)));
        
        % control on bounds of image
        dim = size(img);
        if any(coord < 1) || any(coord > dim([1 2]))
            return;
        end
        
        currentLabel = img(coord(1), coord(2));
%         fprintf('Current Label: %d\n', currentLabel);
        if currentLabel < 1
            return;
        end
        
        % TODO: should consider the case with missing labels
        labelIndex = currentLabel;
        ydata = obj.Table.Data(labelIndex, :);
        
        if isempty(obj.Handles.CurrentRow)
            obj.Handles.CurrentRow = plot(obj.Handles.MainAxis, obj.XData, ydata, ...
                'LineWidth', 2, 'Color', 'b');
        else
            set(obj.Handles.CurrentRow, 'ydata', ydata);
        end
    end

end % end methods

end % end classdef


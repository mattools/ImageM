classdef MeasureWithinSelection < imagem.actions.CurrentImageAction
% Measure average value within selection.
%
%   Class MeasureWithinSelection
%
%   Example
%   MeasureWithinSelection
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-01-28,    using Matlab 9.7.0.1247435 (R2019b) Update 2
% Copyright 2020 INRA - BIA-BIBS.


%% Properties
properties
    CurrentTableFrame;
    
end % end properties


%% Constructor
methods
    function obj = MeasureWithinSelection(varargin)
    % Constructor for MeasureWithinSelection class
        
    end

end % end constructors



methods
    function run(obj, frame)
        disp('Measure Within Selection');
        
        % if selection exists, use it as roi
        if ~isprop(frame, 'Selection') || isempty(frame.Selection)
            warning('requires a valid selection')
            return;
        end

        % extract image to process
        img = currentImage(frame);
        if size(img, 3) > 1
            img = img(:,:,frame.SliceIndex);
        end
        
        selection = frame.Selection;
        if strcmp(selection.Type, 'Polygon')
            poly = selection.Data;
            roi = roipoly(img.Data(:,:,1,1,1), poly(:,2), poly(:,1));
        else
            warning('can only manage polygon selection')
            return;
        end
        
        % compute mean values within ROI for each channel
        nc = channelCount(img);
        meanValues = zeros(1, nc);
        for i = 1:nc
            ch = channel(img, i);
            meanValues(i) = mean(ch(roi));
        end
        
        % determines if a valid table frame already exists.
        hasFrame = false;
        if ~isempty(obj.CurrentTableFrame)
            if ishandle(obj.CurrentTableFrame.Handles.Figure)
                tab = obj.CurrentTableFrame.Doc.Table;
                if size(tab, 2) == nc
                    hasFrame = true;
                end
            end
        end
                
        % create or update table
        if hasFrame
            % update current table frame
            tab = obj.CurrentTableFrame.Doc.Table;
            if size(tab, 2) ~= nc
                return;
            end
            tab = Table([tab.Data ; meanValues], tab.ColNames);
            obj.CurrentTableFrame.Doc.Table = tab;
            obj.CurrentTableFrame.Doc.Modified = true;
            repaint(obj.CurrentTableFrame);
        else
            % Display result in a new table frame.
            
            % create valid column names
            colNames = img.ChannelNames;
            if isempty(colNames)
                if nc == 1
                    colNames = {'Value'};
                else
                    colNames = cellstr(num2str((1:nc)', 'Ch%d'))';
                end
            end
            
            % create table
            tab = Table(meanValues, colNames);
            
            % create new table frame
            [newFrame, newDoc] = createTableFrame(frame.Gui, tab, frame); %#ok<ASGLU>
            obj.CurrentTableFrame = newFrame;
        end
    end
end

end % end classdef


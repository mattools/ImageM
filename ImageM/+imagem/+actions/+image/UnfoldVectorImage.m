classdef UnfoldVectorImage < imagem.actions.VectorImageAction
% Transform a vector image into a Table.
%
%   Class UnfoldVectorImage
%
%
%   Example
%   UnfoldVectorImage
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2019-11-17,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = UnfoldVectorImage(varargin)
        % calls the parent constructor
        obj = obj@imagem.actions.VectorImageAction(varargin{:});
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        
        % get handle to current doc
        doc = currentDoc(frame);
        img = doc.Image;

        if ~isVectorImage(img)
            return;
        end
        
        % default table name
        tableName = 'Channels';
        if ~isempty(img.Name)
            tableName = [img.Name '-Channels'];
        end
        
        % creates a new dialog, and populates it with some fields
        gd = imagem.gui.GenericDialog('Unfold Vector Image');
        addTextField(gd, 'Table Name: ', tableName);
        addChoice(gd, 'Channel Plot Type: ', {'line', 'bar', 'stem', 'stairSteps'}, 'line');
        addCheckBox(gd, 'Create Coords Table', false);
        
        % displays the dialog, and waits for user
        showDialog(gd);
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % parse the user inputs
        tableName = getNextString(gd);
        type = getNextString(gd);
        createCoordsTable = getNextBoolean(gd);
        
        % unfold the table
        [tab, coords] = unfold(img);
        tab.Name = tableName;
        nc = size(tab, 2);
        tab.PreferredPlotTypes = repmat({type}, 1, nc);
        
        % create table viewer
        [newFrame, newDoc] = createTableFrame(frame.Gui, tab, frame); %#ok<ASGLU>
        newDoc.ImageSize = size(img, 1:ndims(img));

        % also create a table for coordinates if requested
        if createCoordsTable
            if ndims(img) == 2 %#ok<ISMAT>
                coordNames = {'x', 'y'};
            elseif ndims(img) == 3
                coordNames = {'x', 'y', 'z'};
            end
            coordsTable = Table(coords, coordNames);
            [coordsFrame, coordsDoc] = createTableFrame(frame.Gui, coordsTable); %#ok<ASGLU>
        end
        
        % add to history
        if createCoordsTable
            string = sprintf('[%s, %s] = unfold(%s);\n', ...
                newDoc.Tag, coordsDoc.Tag, doc.Tag);
            addToHistory(frame, string);
        else
            string = sprintf('%s = unfold(%s);\n', newDoc.Tag, doc.Tag);
            addToHistory(frame, string);
        end
        
    end
    
end % end methods

end % end classdef


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
        
        % creates a new dialog, and populates it with some fields
        gd = imagem.gui.GenericDialog('Unfold Vector Image');
        addChoice(gd, 'Plot Type: ', {'line', 'bar', 'stem', 'stairSteps'}, 'line');
        addCheckBox(gd, 'Create Coords Table', false);
        
        % displays the dialog, and waits for user
        showDialog(gd);
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % parse the user inputs
        type = getNextString(gd);
        createCoordsTable = getNextBoolean(gd);
        
        % unfold the table
        [data, colNames, coords] = unfold(img);
        tab = Table(data, colNames);
        nc = size(tab, 2);
        tab.PreferredPlotTypes = repmat({type}, 1, nc);
        
        % create table viewer
        [newFrame, newDoc] = createTableFrame(frame.Gui, tab, frame); %#ok<ASGLU>
        newDoc.ImageSize = size(img, 1:ndims(img));

        % add to history
        string = sprintf('[tab, names, coords] = unfold(%s);\n', doc.Tag);
        addToHistory(frame, string);
        string = sprintf('%s = Table(tab, names});\n', newDoc.Tag);
        addToHistory(frame, string);
        
        % also create a table for coordinates if requested
        if createCoordsTable
            if ndims(img) == 2 %#ok<ISMAT>
                coordNames = {'x', 'y'};
                coordStr = '{''x'', ''y''}';
            elseif ndims(img) == 3
                coordNames = {'x', 'y', 'z'};
                coordStr = '{''x'', ''y'', ''z''}';
            end
            coordsTable = Table(coords, coordNames);
            [coordsFrame, coordsDoc] = createTableFrame(frame.Gui, coordsTable); %#ok<ASGLU>
            
            % add to history
            string = sprintf('%s = Table(coords, %s});\n', coordsDoc.Tag, coordStr);
            addToHistory(frame, string);
        end
    end
    
end % end methods

end % end classdef


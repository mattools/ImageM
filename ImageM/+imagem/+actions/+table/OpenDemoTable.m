classdef OpenDemoTable < imagem.gui.Action
% Open a new data table stored in a file.
%
%   Class OpenDemoTable
%
%   Example
%   OpenDemoTable
%
%   See also
%     tblui.TableGuiAction
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
    DemoFileName;
end % end properties


%% Constructor
methods
    function obj = OpenDemoTable(fileName)
    % Constructor for OpenDemoTable class
        obj = obj@imagem.gui.Action();
        obj.DemoFileName = fileName;
    end

end % end constructors


%% Methods
methods
    function run(obj, frame)
        disp('Open demo table ');
        
        % get handle to parent GUI
        gui = frame.Gui;
        
        % read the demo image
        tab = Table.read(obj.DemoFileName);
        
        % add image to application, and create new display
        [frame2, doc2] = createTableFrame(gui, tab);
        
        % add history
        string = sprintf('%s = Table.read(''%s'');\n', ...
            doc2.Tag, obj.DemoFileName);
        addToHistory(frame2, string);
    end
end % end methods

end % end classdef


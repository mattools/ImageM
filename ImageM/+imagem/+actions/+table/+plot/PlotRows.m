classdef PlotRows < imagem.actions.CurrentTableAction
% Plot all rows of the current table.
%
%
%   output = Truxx(input)
%
%   Example
%   Truxx
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-11-26,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRA - Cepia Software Platform.

%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = PlotRows()
        % Constructor for PlotRows class
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        
        % get handle to current doc
        doc = frame.Doc;
        tab = doc.Table;
        
        figure; plotRows(tab);
    end
end % end methods


end
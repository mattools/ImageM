classdef TableDoc < imagem.app.ImagemDoc
%TABLEDOC  Enapsulates a data Table, and data for GUI interaction.
%
%   Class TableDoc
%
%   Example
%   TableDoc
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
    % the data table that stores the data.
    Table;
        
end % end properties


%% Constructor
methods
    function obj = TableDoc(table)
    % Constructor for TableDoc class
        obj.Table = table;
    end

end % end constructors


%% Methods
methods
end % end methods

end % end classdef


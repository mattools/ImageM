classdef TableDoc < handle
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
    
    % a boolean flag indicating whether the table was modified or .
    Modified = false;
    
end % end properties


%% Constructor
methods
    function this = TableDoc(table)
    % Constructor for TableDoc class
        this.Table = table;
    end

end % end constructors


%% Methods
methods
end % end methods

end % end classdef


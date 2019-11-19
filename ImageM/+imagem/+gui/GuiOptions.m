classdef GuiOptions < handle
%Global options for creating GUIs.
%
%   Class GuiOptions
%
%   Example
%   GuiOptions
%
%   See also
%     ImagemGUI

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-11-19,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    TextOptions = {'FontSize', 14};

    DlgListSize = [180 220];
    
end % end properties


%% Constructor
methods
    function obj = GuiOptions()
    % Constructor for GuiOptions class

    end

end % end constructors


%% Methods
methods
end % end methods

end % end classdef


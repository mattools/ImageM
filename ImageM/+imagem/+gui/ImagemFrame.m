classdef ImagemFrame < handle
% Base class for all figure widgets managed by ImageM application.
%
%   Class ImagemFrame
%
%   Example
%   ImagemFrame
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-11-15,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    % Reference to the main GUI.
    Gui;
   
    % List of handles to the various gui items.
    Handles;
    
end % end properties


%% Constructor
methods
    function obj = ImagemFrame(gui)
        % Constructor for ImagemFrame class
        %
        % Usage:
        % OBJ = ImagemFrame(GUI);
        % where GUI is an instance of ImagemGUI.
        
        obj.Gui = gui;
        obj.Handles = struct();
    end

end % end constructors


%% Methods
methods
end % end methods

end % end classdef


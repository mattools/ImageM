classdef SetChannelDisplayType < imagem.actions.VectorImageAction
%SETCHANNELDISPLAYTYPE  One-line description here, please.
%
%   Class SetChannelDisplayType
%
%   Example
%   SetChannelDisplayType
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2020-01-28,    using Matlab 9.7.0.1247435 (R2019b) Update 2
% Copyright 2020 INRA - BIA-BIBS.


%% Properties
properties
    DisplayType;
end % end properties


%% Constructor
methods
    function obj = SetChannelDisplayType(displayType)
    % Constructor for SetChannelDisplayType class

        % init inner fields
        obj.DisplayType = displayType;
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSD>
        if isempty(obj.DisplayType)
            return;
        end
        
        % get handle to current doc
        doc = currentDoc(frame);
        
        doc.ChannelDisplayType = obj.DisplayType;
    end
end % end methods

end % end classdef


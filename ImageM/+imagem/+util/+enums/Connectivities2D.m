classdef Connectivities2D
% Enumeration of the various connectivities in 2D.
%
%   Enumeration imagem.util.enums.Connectivities2D
%
%   Example
%     enumLabels = imagem.util.enums.Connectivities2D.allLabels;
%     conn = imagem.util.enums.Connectivities2D.fromLabel(enumLabels{1})
%     conn = 
%       Connectivities2D enumeration
%         C4
%     value(conn)
%     ans =
%          4
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-02-22,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.


%% Enumerates the different cases
enumeration
    C4('C4', 4);
    C8('C8', 8);
end % end properties


%% Static methods
methods (Static)
    function res = allNames()
        % Returns a cell list with all enumeration names.
        mc = ?imagem.util.enums.Connectivities2D;
        itemList = mc.EnumerationMemberList;
        nItems = length(itemList);
        res = cell(1, nItems);
        
        for i = 1:nItems
            % retrieve current enumeration item
            mitem = itemList(i);
            res{i} = mitem.Name;
        end
    end
    
    function res = fromName(name)
        % Identifies a imagem.util.enums.Connectivities2D from its name.
        if nargin == 0 || ~ischar(name)
            error('requires a character array as input argument');
        end
        
        mc = ?imagem.util.enums.Connectivities2D;
        itemList = mc.EnumerationMemberList;
        for i = 1:length(itemList)
            % retrieve current enumeration item
            mitem = itemList(i);
            item = imagem.util.enums.Connectivities2D.(mitem.Name);
            if strcmpi(name, char(item))
                res = item;
                return;
            end
        end
        
        error('Unrecognized imagem.util.enums.Connectivities2D name: %s', name);
    end
    
    function res = allLabels()
        % Returns a cell list with all enumeration names.
        mc = ?imagem.util.enums.Connectivities2D;
        itemList = mc.EnumerationMemberList;
        nItems = length(itemList);
        res = cell(1, nItems);
        
        for i = 1:nItems
            % retrieve current enumeration item
            mitem = itemList(i);
            item = imagem.util.enums.Connectivities2D.(mitem.Name);
            res{i} = item.Label;
        end
    end
    
    function res = fromLabel(label)
        % Identifies a imagem.util.enums.Connectivities2D from its label.
        if nargin == 0 || ~ischar(label)
            error('requires a character array as input argument');
        end
        
        mc = ?imagem.util.enums.Connectivities2D;
        itemList = mc.EnumerationMemberList;
        for i = 1:length(itemList)
            % retrieve current enumeration item
            mitem = itemList(i);
            item = imagem.util.enums.Connectivities2D.(mitem.Name);
            if strcmpi(label, item.Label)
                res = item;
                return;
            end
        end
        
        error('Unrecognized imagem.util.enums.Connectivities2D label: %s', label);
    end
end % end methods

%% Methods
methods
    function v = value(obj)
        v = obj.Value;
    end
end

%% Constructor
methods (Access = private)
    function obj = Connectivities2D(label, value, varargin)
        % Constructor for imagem.util.enums.Connectivities2D class.
        obj.Label = label;
        obj.Value = value;
    end

end % end constructors


%% Properties
properties
    Label;
    Value;
end % end properties

end % end classdef


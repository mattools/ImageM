classdef ColorMaps
% Various color maps for generating color displays.
%
%   Enumeration ColorMaps
%
%   Example
%     label = 'Parula';
%     item = imagem.util.enums.ColorMaps.fromLabel(label);
%     cmap = createColorMap(item, 256);
%     size(cmap)
%          256   3
%
%   See also
%     BasicColors

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-01-05,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.


%% Enumerates the different cases
enumeration
    Parula('Parula');
    Jet('Jet');
    Gray('Gray');
    Hsv('Hsv');
    Hot('Hot');
    Cool('Cool');
end % end properties


%% Static methods
methods (Static)
    function res = allNames()
        % Returns a cell list with all enumeration names.
        mc = ?imagem.util.enums.ColorMaps;
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
        % Identifies a ColorMaps from its name.
        if nargin == 0 || ~ischar(name)
            error('requires a character array as input argument');
        end
        
        mc = ?imagem.util.enums.ColorMaps;
        itemList = mc.EnumerationMemberList;
        for i = 1:length(itemList)
            % retrieve current enumeration item
            mitem = itemList(i);
            item = imagem.util.enums.ColorMaps.(mitem.Name);
            if strcmpi(name, char(item))
                res = item;
                return;
            end
        end
        
        error('Unrecognized ColorMaps name: %s', name);
    end
    
    function res = allLabels()
        % Returns a cell list with all enumeration names.
        mc = ?imagem.util.enums.ColorMaps;
        itemList = mc.EnumerationMemberList;
        nItems = length(itemList);
        res = cell(1, nItems);
        
        for i = 1:nItems
            % retrieve current enumeration item
            mitem = itemList(i);
            item = imagem.util.enums.ColorMaps.(mitem.Name);
            res{i} = item.Label;
        end
    end
    
    function res = fromLabel(label)
        % Identifies a ColorMaps from its label.
        if nargin == 0 || ~ischar(label)
            error('requires a character array as input argument');
        end
        
        mc = ?imagem.util.enums.ColorMaps;
        itemList = mc.EnumerationMemberList;
        for i = 1:length(itemList)
            % retrieve current enumeration item
            mitem = itemList(i);
            item = imagem.util.enums.ColorMaps.(mitem.Name);
            if strcmpi(label, item.Label)
                res = item;
                return;
            end
        end
        
        error('Unrecognized ColorMaps label: %s', label);
    end
end % end methods


%% Constructor
methods
    function map = createColorMap(obj, varargin)
        % Create a N-by-3 color array.
        
        % determine color number
        n = 256;
        if ~isempty(varargin)
            n = varargin{1};
        end
        
        % create color map
        switch obj
            case imagem.util.enums.ColorMaps.Parula
                map = parula(n);
            case imagem.util.enums.ColorMaps.Jet
                map = jet(n);
            case imagem.util.enums.ColorMaps.Hsv
                map = hsv(n);
            case imagem.util.enums.ColorMaps.Hot
                map = hot(n);
            case imagem.util.enums.ColorMaps.Cool
                map = cool(n);
            case imagem.util.enums.ColorMaps.Gray
                map = gray(n);
            otherwise 
                error(['Unprocessed color map: ' obj.Name]);
        end
    end

end % end constructors


%% Constructor
methods
    function obj = ColorMaps(label, varargin)
        % Constructor for ColorMaps class.
        obj.Label = label;
    end

end % end constructors


%% Properties
properties
    Label;
end % end properties

end % end classdef


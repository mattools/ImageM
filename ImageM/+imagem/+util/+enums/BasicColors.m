classdef BasicColors
% One-line description here, please.
%
%   Enumeration BasicColors
%
%   Example
%     label = 'Magenta';
%     item = imagem.util.enums.BasicColors.fromLabel(label);
%     rgb = item.RGB
%     rgb = 
%          1     0     1
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-01-05,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.


%% Enumerates the different cases
enumeration
    Red('Red', [1 0 0]);
    Green('Green', [0 1 0]);
    Blue('Blue', [0 0 1]);
    
    Cyan('Cyan', [1 1 0]);
    Magenta('Magenta', [1 0 1]);
    Yellow('Yellow', [0 1 1]);
    
    Black('Black', [0.0 0.0 0.0]);
    White('White', [1.0 1.0 1.0]);
    
    Gray('Gray', [0.5 0.5 0.5]);
    Dark_Gray('Dark Gray', [0.25 0.25 0.25]);
    Light_Gray('Light Gray', [0.75 0.75 0.75]);
end % end properties


%% Static methods
methods (Static)
    function res = allNames()
        % Returns a cell list with all enumeration names.
        mc = ?imagem.util.enums.BasicColors;
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
        % Identifies a BasicColors from its name.
        if nargin == 0 || ~ischar(name)
            error('requires a character array as input argument');
        end
        
        mc = ?imagem.util.enums.BasicColors;
        itemList = mc.EnumerationMemberList;
        for i = 1:length(itemList)
            % retrieve current enumeration item
            mitem = itemList(i);
            item = imagem.util.enums.BasicColors.(mitem.Name);
            if strcmpi(name, char(item))
                res = item;
                return;
            end
        end
        
        error('Unrecognized BasicColors name: %s', name);
    end
    
    function res = allLabels()
        % Returns a cell list with all enumeration names.
        mc = ?imagem.util.enums.BasicColors;
        itemList = mc.EnumerationMemberList;
        nItems = length(itemList);
        res = cell(1, nItems);
        
        for i = 1:nItems
            % retrieve current enumeration item
            mitem = itemList(i);
            item = imagem.util.enums.BasicColors.(mitem.Name);
            res{i} = item.Label;
        end
    end
    
    function res = fromLabel(label)
        % Identifies a BasicColors from its label.
        if nargin == 0 || ~ischar(label)
            error('requires a character array as input argument');
        end
        
        mc = ?imagem.util.enums.BasicColors;
        itemList = mc.EnumerationMemberList;
        for i = 1:length(itemList)
            % retrieve current enumeration item
            mitem = itemList(i);
            item = imagem.util.enums.BasicColors.(mitem.Name);
            if strcmpi(label, item.Label)
                res = item;
                return;
            end
        end
        
        error('Unrecognized BasicColors label: %s', label);
    end
end % end methods


%% Constructor
methods
    function obj = BasicColors(label, rgb, varargin)
        % Constructor for BasicColors class.
        obj.Label = label;
        obj.RGB = rgb;
    end

end % end constructors


%% Properties
properties
    % The label of the color to display.
    Label;
    % The red, green and blue values, as a 1-by-3 array between 0 and 1.
    RGB;
    
end % end properties

end % end classdef


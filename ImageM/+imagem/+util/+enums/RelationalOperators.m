classdef RelationalOperators
% Enumeration of relational operators.
%
%   Enumeration imagem.util.enums.RelationalOperators
%
%   Example
%     % pick an enumeration
%     op = imagem.util.enums.RelationalOperators.GreaterThan;
%     % apply it onto numerical values
%     res = apply(op, 1:10, 4)
%     res =
%       1x10 logical array
%        0   0   0   0   1   1   1   1   1   1
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-12-23,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.


%% Enumerates the different cases
enumeration
    Equal('Equal (==)', @eq, '==');
    GreaterThanOrEqual('Greater Than or Equal (>=)', @ge, '>=');
    GreaterThan('Greater Than (>)', @gt, '>');
    LesserThanOrEqual('Lesser Than or Equal (<=)', @le, '<=');
    LesserThan('Lesser Than (<)', @lt, '<');
    NotEqual('Not Equal (~=)', @ne, '~=');
end % end properties


%% Static methods
methods (Static)
    function res = allNames()
        % Returns a cell list with all enumeration names.
        mc = ?imagem.util.enums.RelationalOperators;
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
        % Identifies a imagem.util.enums.RelationalOperators from its name.
        if nargin == 0 || ~ischar(name)
            error('requires a character array as input argument');
        end
        
        mc = ?imagem.util.enums.RelationalOperators;
        itemList = mc.EnumerationMemberList;
        for i = 1:length(itemList)
            % retrieve current enumeration item
            mitem = itemList(i);
            item = imagem.util.enums.RelationalOperators.(mitem.Name);
            if strcmpi(name, char(item))
                res = item;
                return;
            end
        end
        
        error('Unrecognized imagem.util.enums.RelationalOperators name: %s', name);
    end
    
    function res = allLabels()
        % Returns a cell list with all enumeration names.
        mc = ?imagem.util.enums.RelationalOperators;
        itemList = mc.EnumerationMemberList;
        nItems = length(itemList);
        res = cell(1, nItems);
        
        for i = 1:nItems
            % retrieve current enumeration item
            mitem = itemList(i);
            item = imagem.util.enums.RelationalOperators.(mitem.Name);
            res{i} = item.Label;
        end
    end
    
    function res = fromLabel(label)
        % Identifies a imagem.util.enums.RelationalOperators from its label.
        if nargin == 0 || ~ischar(label)
            error('requires a character array as input argument');
        end
        
        mc = ?imagem.util.enums.RelationalOperators;
        itemList = mc.EnumerationMemberList;
        for i = 1:length(itemList)
            % retrieve current enumeration item
            mitem = itemList(i);
            item = imagem.util.enums.RelationalOperators.(mitem.Name);
            if strcmpi(label, item.Label)
                res = item;
                return;
            end
        end
        
        error('Unrecognized imagem.util.enums.RelationalOperators label: %s', label);
    end
end % end methods


%% Constructor
methods
    function obj = RelationalOperators(label, op, symbol)
        % Constructor for imagem.util.enums.RelationalOperators class.
        obj.Label = label;
        obj.Op = op;
        obj.Symbol = symbol;
    end

end % end constructors

%% Methods
methods
    function res = apply(obj, arg1, arg2)
        % Apply the selected operator to a pair of numerical arguments.
        %
        % op = imagem.util.enums.RelationalOperators.GreaterThan;
        % res = apply(op, 1:10, 4)
        % res =
        %   1x10 logical array
        %    0   0   0   0   1   1   1   1   1   1
        res = obj.Op(arg1, arg2);
    end
end

%% Properties
properties
    % The label used to identify the enumeration in graphical widgets.
    Label;
    % The operation to apply on numerical values.
    Op;
    % The symbol of the operation in Matlab syntax.
    Symbol;
end % end properties

end % end classdef


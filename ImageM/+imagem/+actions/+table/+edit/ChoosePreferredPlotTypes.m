classdef ChoosePreferredPlotTypes < imagem.actions.CurrentTableAction
% One-line description here, please.
%
%   Class ChoosePreferredPlotTypes
%
%   Example
%   ChoosePreferredPlotTypes
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-07-01,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = ChoosePreferredPlotTypes(varargin)
        % Constructor for ChoosePreferredPlotTypes class.
        obj = obj@imagem.actions.CurrentTableAction();
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        
        table = frame.Doc.Table;
        
        currentType = table.PreferredPlotTypes{1};
        typeList = {'Line', 'Bar', 'StairSteps', 'Stem'};
        
        index = find(strcmpi(currentType, typeList));
        if isempty(index)
            error('invalid preferred plot type');
        end
        
        % creates a new dialog, and populates it with some fields
        gd = imagem.gui.GenericDialog('Choose Plot Types');
        addChoice(gd, 'Type: ', typeList, typeList{index});
        
        % displays the dialog, and waits for user
        showDialog(gd);
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % gets the user inputs
        type = getNextString(gd);
        
        nc = size(table, 2);
        table.PreferredPlotTypes = repmat({type}, 1, nc);
        
    end
    
end % end methods

end % end classdef


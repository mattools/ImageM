classdef ImageReplaceValue < imagem.actions.CurrentImageAction
% Replace one or several values within an image by a new value.
%
%   Class ImageReplaceValue
%
%   Example
%   ImageReplaceValue
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2020-07-31,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2020 INRAE - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = ImageReplaceValue(varargin)
        % Constructor for ImageReplaceValue class.
        obj = obj@imagem.actions.CurrentImageAction();
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL,INUSD>
        
        % get handle to current doc
        doc = frame.Doc;
        
        gd = imagem.gui.GenericDialog('Replace values');
        addTextField(gd, 'Old value(s): ', '1');
        addTextField(gd, 'New value: ', '0');
        
        % displays the dialog, and waits for user
        showDialog(gd);
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % gets the user inputs
        oldValuesStr = getNextString(gd);
        strList = strtrim(strsplit(oldValuesStr, ','));
        oldValues = zeros(1, length(strList));
        for i = 1:length(strList)
            oldValues(i) = parseValue(strList{i});
        end
        
        newValueStr = getNextString(gd);
        newValue = parseValue(newValueStr);
        
        doc.Image(ismember(doc.Image, oldValues)) = newValue;
        
        doc.Modified = true;
        
        updateDisplay(frame);
        
        % update history
        nValues = length(oldValues);
        pattern = ['[%g' repmat(' %g', 1, nValues-1) ']'];
        str1 = sprintf(pattern, oldValues);
        tag = doc.Tag;
        string = sprintf('%s(ismember(%s, %s)) = %g;\n', tag, tag, str1, newValue);
        addToHistory(frame, string);

        % utility function to parse a numeric value
        function val = parseValue(str)
            val = str2num(str); %#ok<ST2NM>
            if isempty(val)
                error(['Could not parse value: ' str]);
            end
        end
    end
    
    function b = isActivable(obj, frame) %#ok<INUSL>
        % Check if current doc contains a scalar image.
        doc = frame.Doc;
        b = ~isempty(doc) && ~isempty(doc.Image);
        if b
            b = isScalarImage(doc.Image);
        end
    end
end % end methods

end % end classdef


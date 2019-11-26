classdef Transpose < imagem.actions.CurrentTableAction
% Transpose the current table.
%
%   Class Transpose
%
%   Example
%   Transpose
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-11-26,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = Transpose(varargin)
    % Constructor for Transpose class

    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        
        % get handle to current doc
        doc = frame.Doc;
        tab = doc.Table;
        
        tab2 = transpose(tab);
        
        [frame, doc2] = createTableFrame(frame.Gui, tab2);
        
        % add history
        string = sprintf('%s = transpose(%s);\n', ...
            doc2.Tag, doc.Tag);
        addToHistory(frame, string);
    end
    
end % end methods

end % end classdef


classdef Nmf < imagem.gui.Action
% Non-negative matrix factorization of current table.
%
%   Class Nmf
%
%   Example
%   Nmf
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-04-09,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = Nmf()
    % Constructor for TablePcaAction class
        obj = obj@imagem.gui.Action();
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL>
        
        if isempty(frame.Doc)
            return;
        end
        table = frame.Doc.Table;
        
        % default number of components
        nComps = min(5, size(table, 2));
        
        % open a dialog to choose number of components
        prompt = {'Number of components:'};
        title = 'Non-Negative Matrix Factorization';
        dims = [1 35];
        definput = {num2str(nComps)};
        answer = inputdlg(prompt, title, dims, definput);
        
        % check user did not cancel
        if isempty(answer)
            return;
        end
        
        % parse user input
        nComps = str2double(answer{1});
        if isnan(nComps)
            error('Could not interpret the number of components from string: %s', answer{1});
        end
        
        [W, H] = nmf(table, nComps);
        
        % create a new frame for weights
        [frameW, docW] = createTableFrame(frame.Gui, W); %#ok<ASGLU>
        
        % create a new frame for coefficients
        [frameH, docH] = createTableFrame(frame.Gui, H); %#ok<ASGLU>


        % update history
        historyString = sprintf('[%s, %s] = nmf(%s, %d);\n', ...
            docW.Tag, docH.Tag, frame.Doc.Tag, nComps);
        addToHistory(frame, historyString);

    end
end % end methods

end % end classdef


classdef Pca < imagem.gui.Action
% Compute principal component analysis of current table.
%
%   Class TablePcaAction
%
%   Example
%   TablePcaAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2012-03-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = Pca()
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
        
        % open a dioalog to set up PCA options and launch computation
        imagem.actions.table.process.PcaDialog(frame.Gui, table, frame);
    end
end % end methods

end % end classdef


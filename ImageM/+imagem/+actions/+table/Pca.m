classdef Pca < imagem.gui.Action
%TABLEPCAACTION  Compute principal component analysis of current table
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
        obj = obj@imagem.gui.Action('plotTable');
    end

end % end constructors


%% Methods
methods
    function run(obj, frame)
        
        if isempty(this.viewer.doc)
            return;
        end
        table = this.viewer.doc.table;
        
        % open a dioalog to set up PCA options and launch computation
        tabui.pca.PcaDialog(this.viewer.gui, table);
    end
end % end methods

end % end classdef


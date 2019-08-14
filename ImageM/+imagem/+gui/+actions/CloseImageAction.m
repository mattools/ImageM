classdef CloseImageAction < imagem.gui.actions.CurrentImageAction
% Close the current ImageM figure.
%
%   output = CloseImageAction(input)
%
%   Example
%   CloseImageAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function obj = CloseImageAction(viewer, varargin)
        % calls the parent constructor
        obj = obj@imagem.gui.actions.CurrentImageAction(viewer, 'closeImage');
    end
end

methods
    function actionPerformed(obj, varargin)
%         disp('Close image action');
        
        viewer = obj.Viewer;
        doc = viewer.Doc;
        
        close(viewer);
        
        if isempty(getViews(doc))
            app = viewer.Gui.App;
            removeDocument(app, doc);
        end
    end
end

end
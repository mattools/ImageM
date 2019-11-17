classdef CloseFrame < imagem.gui.Action
% Close the current ImageM figure.
%
%   output = CloseFrame(input)
%
%   Example
%   CloseFrame
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function obj = CloseFrame()
    end
end

methods
    function run(obj, frame) %#ok<INUSL>
%         disp('Close image action');
        
%         doc = frame.Doc;
        
        close(frame);
        
%         if isempty(getViews(doc))
%             app = frame.Gui.App;
%             removeDocument(app, doc);
%         end
    end
end

end
classdef OpenDemoImage < imagem.gui.Action
% Open and display one of the demo images.
%
%   Class OpenDemoImageAction
%
%   Example
%   OpenDemoImageAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-11-07,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    ImageName;
end % end properties


%% Constructor
methods
    function obj = OpenDemoImage(imageName)
        % Constructor for OpenDemoImage class
        
        % initialize image name
        obj.ImageName = imageName;
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSD>
        
        % read the demo image
        img = Image.read(obj.ImageName);
        
        % add image to application, and create new display
        frame = createImageFrame(frame, img);
        
        tag = frame.Doc.Tag;
                
        % history
        string = sprintf('%s = Image.read(''%s'');\n', tag, obj.ImageName);
        addToHistory(frame, string);        
    end
end % end methods

end % end classdef


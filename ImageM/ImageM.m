function varargout = ImageM(varargin)
% Run a new instance of ImageM application.
%
%   ImageM
%   Creates a new ImageM window, with a menu and without image.
%
%   ImageM(IMG)
%   Creates a new ImageM window initialized with the given image. IMG
%   should be an instance of Image Object.
%
%   VIEWER = ImageM(IMG);
%   Returns the ImageM Viewer object created for the input image.
%   The viewer contains several fields, among them:
%   * Gui:  the global GUI that manages the set of frames/viewers
%   * Doc:  an ImagemDoc object that encapsulates the image together with
%           useful information
%   * Handles: a set of handles to the widgets that constitute this viewer.
%
%
%   Example
%     img = Image.read('cameraman.tif');
%     ImageM(img);
%
%   See also
%     Image
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2011-03-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

import imagem.app.ImagemApp;
import imagem.gui.ImagemGUI;

% check if image is present, or create one
img = [];
if ~isempty(varargin)
    var = varargin{1};
    
    if isa(var, 'Image')
        % if first argument is an image object, keep it
        img = var;
        
        % if image has no name, use the name of the variable
        if isempty(img.Name)
            img.Name = inputname(1);
        end
        
    elseif ischar(var)
        % if first input is a string, use it to open an image        
        img = Image.read(var);
        
    elseif isnumeric(var) || islogical(var)
        % if input is numerical array, convert to image and keep input name
        img = Image(var);
        img.Name = inputname(1);
    end
end

% create the application, and a GUI
app = ImagemApp;
gui = ImagemGUI(app);

% use the GUI to create a new image display
viewer = createImageFrame(gui, img);


% returns handle to viewer if requested
if nargout > 0
    varargout = {viewer};
end

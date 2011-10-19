classdef ImagemImageFigure < handle
%IMAGEMIMAGEFIGURE  One-line description here, please.
%
%   output = ImagemImageFigure(input)
%
%   Example
%   ImagemImageFigure
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-03-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


properties
    % reference to the GUI
    gui;
    
    % handle to the figure
    hFig;
end

methods
    function this = ImagemImageFigure(gui)
        this.gui = gui;
        
        % create default figure
        fig = figure();
        set(fig, 'menubar', 'none')
        set(fig, 'numbertitle', 'off')
        set(fig, 'name', 'ImageM Sub Figure')
        
        % create main figure menu
        createMenu(fig);
        createAxis(fig);
        
        this.hFig = fig;
        
        function createMenu(hf)
            
            import imagem.gui.actions.*;
            
            menu = uimenu(hf, 'Label', 'Files');
            
            action = SayHelloAction(this.gui, 'sayHello');
            uimenu(menu, 'Label', 'Say Hello!', ...
                'Callback', @action.actionPerformed);
            
            action = ExitAction(this.gui, 'quit');
            uimenu(menu, 'Label', 'Quit', 'Separator', 'On', ...
                'Callback', @action.actionPerformed);
        end
        
        function createAxis(hf)
            
            img = imread('cameraman.tif');
            
            ax = axes('parent', hf, 'units', 'normalized', ...
                'position', [.05 .05 .9 .9]);
            imshow(img, 'parent', ax);
            axis('equal');
        end
    end
end

methods
    function close(this)
        close(this.hFig);
    end
end

end
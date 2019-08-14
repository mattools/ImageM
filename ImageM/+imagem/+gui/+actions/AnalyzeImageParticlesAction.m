classdef AnalyzeImageParticlesAction < imagem.gui.actions.LabelImageAction
% Compute geometrical descriptors of particles.
%
%   output = AnalyzeImageParticlesAction(input)
%
%   Example
%   AnalyzeImageParticlesAction
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-11-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function obj = AnalyzeImageParticlesAction(viewer, varargin)
        % calls the parent constructor
        obj = obj@imagem.gui.actions.LabelImageAction(viewer, 'analyzeImageParticles');
    end
end

methods
    function actionPerformed(obj, src, event) %#ok<INUSD>
        disp('analyze particles');
        
        % get current image
        img = currentImage(obj);
        
        % extract parameters
        props = regionprops(img.Data', {...
            'Area', 'Perimeter', 'Centroid', ...
            'MajorAxisLength', 'MinorAxisLength', 'Orientation'});

        % format to column vectors
        areas = [props.Area]';
        perim = [props.Perimeter]';
        centro = reshape([props.Centroid], 2, length(props))';
        major = [props.MajorAxisLength]';
        minor = [props.MinorAxisLength]';
        theta = -[props.Orientation]';
        
        % create data table
        data = [areas perim centro major minor theta];
        tab = Table(data, 'colNames', ...
            {'Area', 'Perimeter', 'CentroidX', 'CentroidY', ...
            'MajorAxisLength', 'MinorAxisLength', 'Orientation'});

        % display data table in its own window
        show(tab);
        
        % display overlay of ellipses
        ellis = [centro major/2 minor/2 theta];
        shape = struct(...
            'Type', 'ellipse', ...
            'Data', ellis, ...
            'Style', {{'-b', 'LineWidth', 1}});
        obj.Viewer.Doc.Shapes = {shape};
        
        updateDisplay(obj.Viewer);

    end
end

end

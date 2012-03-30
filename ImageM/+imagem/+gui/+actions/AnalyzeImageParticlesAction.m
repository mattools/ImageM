classdef AnalyzeImageParticlesAction < imagem.gui.actions.LabelImageAction
%ANALYZEIMAGEPARTICLESACTION Compute geometrical descriptors of particles
%
%   output = AnalyzeImageParticlesAction(input)
%
%   Example
%   AnalyzeImageParticlesAction
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-11-11,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

methods
    function this = AnalyzeImageParticlesAction(parent, varargin)
        % calls the parent constructor
        this = this@imagem.gui.actions.LabelImageAction(parent, 'analyzeImageParticles');
    end
end

methods
    function actionPerformed(this, src, event) %#ok<INUSD>
        disp('analyze particles');
        
        % get handle to parent figure
         
        % apply 'gradient' operation
        img = this.parent.doc.image;
        
        props = regionprops(img.data', {...
            'Area', 'Perimeter', 'Centroid', ...
            'MajorAxisLength', 'MinorAxisLength', 'Orientation'});

        areas = [props.Area]';
        perim = [props.Perimeter]';
        centro = reshape([props.Centroid], 2, length(props))';
        major = [props.MajorAxisLength]';
        minor = [props.MinorAxisLength]';
        theta = -[props.Orientation]';
        
        data = [areas perim centro major minor theta];
        tab = Table(data, 'colNames', ...
            {'Area', 'Perimeter', 'CentroidX', 'CentroidY', ...
            'MajorAxisLength', 'MinorAxisLength', 'Orientation'});

        show(tab);
        
        ellis = [data(:, 3:4) data(:, 5:6)/2 data(:, 7)];
        imAxis = this.parent.handles.imageAxis;
        set(imAxis, 'NextPlot', 'add');
        drawEllipse(imAxis, ellis);
    end
end

end
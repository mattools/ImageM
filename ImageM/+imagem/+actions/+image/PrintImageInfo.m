classdef PrintImageInfo < imagem.actions.CurrentImageAction
% Print some info about current image.
%
%   Class PrintImageInfo
%
%   Example
%   PrintImageInfo
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2020-01-07,    using Matlab 9.7.0.1247435 (R2019b) Update 2
% Copyright 2020 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = PrintImageInfo(varargin)
    % Constructor for PrintImageInfo class.
    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSL,INUSD>
         
        % flip image
        doc = currentDoc(frame);
        img = currentImage(frame);
        
        fprintf('Print image info for document %s\n', doc.Tag);
        fprintf('  Image name: %s\n', img.Name);
        fprintf('  File Path: %s\n', img.FilePath);
        
        sizePattern = ['%d' repmat('x%d', 1, ndims(img)-1)];
        fprintf(['  Size: ' sizePattern '\n'], size(img));
        fprintf('  Type: %s\n', img.Type);
        
        if img.Calibrated
            fprintf('  Calibrated: true\n');
            calibPattern = ['[%g' repmat(',%g', 1, ndims(img)-1) ']'];
            fprintf(['  Origin: ' calibPattern '\n'], img.Origin);
            fprintf(['  Spacing: ' calibPattern '\n'], img.Spacing);
            fprintf('  Unit Name: %s\n', img.UnitName);
        else
            fprintf('  Calibrated: false\n');
        end

        if ~isempty(img.AxisNames)
            fprintf('  Axis Names: {''%s''', img.AxisNames{1});
            for i = 2:length(img.AxisNames)
                fprintf(',''%s''', img.AxisNames{i});
            end
            fprintf('}\n');
        else
            fprintf('  Axis Names: {}\n');
        end
        
        if ~isempty(img.ChannelNames)
            fprintf('  Channel Names: {''%s''', img.ChannelNames{1});
            nc = channelCount(img);
            if nc > 10
                for i = 2:10
                    fprintf(', ''%s''', img.ChannelNames{i});
                end
                fprintf('... (%d more)}\n', nc-10);
            else
                for i = 2:nc
                    fprintf(', ''%s''', img.ChannelNames{i});
                end
                fprintf('}\n');
            end
        else
            fprintf('  Channel Names: {}\n');
        end
    end
end % end methods

end % end classdef


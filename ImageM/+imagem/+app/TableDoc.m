classdef TableDoc < imagem.app.ImagemDoc
%TABLEDOC  Enapsulates a data Table, and data for GUI interaction.
%
%   Class TableDoc
%
%   Example
%   TableDoc
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2012-03-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
    % The data table that stores the data.
    Table;
    
    % The size of the image that was used to generate this table, if relevant.
    ImageSize = [];
    
end % end properties


%% Constructor
methods
    function obj = TableDoc(table, varargin)
    % Constructor for TableDoc class
    %
    % Usage:
    %   DOC = imagem.app.TableDoc(TAB)
    %   DOC = imagem.app.TableDoc(TAB, PARENTDOC)
    %
        obj.Table = table;
        
        if ~isempty(varargin) 
            if isa(varargin{1}, 'imagem.app.TableDoc')
                refDoc = varargin{1};
                obj.ImageSize = refDoc.ImageSize;
            else
                error('Unable to process additional arguments');
            end
        end
            
    end

end % end constructors


%% Methods
methods
end % end methods

end % end classdef


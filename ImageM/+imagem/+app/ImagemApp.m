classdef ImagemApp < handle
%IMAGEMAPP ImageM application class, that manages open images
%
%   output = ImagemApp(input)
%
%   Example
%   ImagemApp
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-03-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    % set of image documents managed by this application
    docList;
    
    % default connectivity associated to each dimension. Equals 4 for 2D,
    % and 6 for 3D. Stored as a row vector, starting at dim=2 (no need for
    % connectivity info for 1D)
    defaultConnectivity = [4 6];
    
    % the size (diameter) of the brush (in pixels)
    brushSize = 3;
    
end 

%% Constructor
methods
    function this = ImagemApp(varargin)
        
        
    end % constructor 

end % construction function

%% General methods
methods

    function printVersion(this) %#ok<MANU>
        % 
        disp('ImageM is running...');
        disp('testing version!');
        
    end
end % general methods

%% Method for document management
methods
    function addDocument(this, doc)
        this.docList = [this.docList {doc}];
    end
    
    function removeDocument(this, doc)
        ind = -1;
        for i = 1:length(this.docList)
            if this.docList{i} == doc
                ind = i;
                break;
            end
        end
        
        if ind == -1
            error('could not find the document');
        end
        
        this.docList(ind) = [];
    end

    function docList = getDocuments(this)
        docList = this.docList;
    end
    
    function names = getImageNames(this)
        % returns a cell array of strings containing name of each image
        names = cell(length(this.docList),1);
        for i = 1:length(this.docList)
            doc = this.docList{i};
            names{i} = doc.image.name;
        end
    end
    
    function b = hasDocuments(this)
        b = ~isempty(this.docList);
    end

    function doc = getDocument(this, index)
        % Returns a document, either by its index, or by its name
        
        if isnumeric(index)
            doc = this.docList{index};
            
        elseif ischar(index)
            doc = [];
            for i = 1:length(this.docList)
                currentDoc = this.docList{i};
                if strcmp(currentDoc.image.name, index)
                    doc = currentDoc;
                    break;
                end
            end
            
            if isempty(doc)
                error(['Could not find document with name: ' index]);
            end
        else
            error('Index must be either numeric or char');
        end
    end
    
    function newName = createDocumentName(this, baseName)
        % returns either the base name of doc, or the name with an index
       
        if isempty(baseName)
            baseName = 'NoName';
        end
        newName = baseName;
               
        % if the name is free, no problem
        if ~hasDocumentWithName(this, baseName)
            return;
        end
        
        % otherwise, we first check if name contains an "index"
        % here: the number at the end of the name, separated by a minus
        [path name ext] = fileparts(baseName);
        isDigit = ismember(name, '1234567890');
        numDigits = length(name) - find(~isDigit, 1, 'last');
        if numDigits > 0 && numDigits < length(name) && name(end-numDigits) == '-'
            baseName = fullfile(path, [name(1:end-numDigits-1) ext]);
        end
        
        index = 1;
        while true
            newName = createIndexedName(baseName, index);
            if ~hasDocumentWithName(this, newName)
                return;
            end
            index = index + 1;
        end
        
        % inner function
        function name = createIndexedName(baseName, index)
            % add the given number to the name of the document
            [path name ext] = fileparts(baseName);
            name = [name '-' num2str(index) ext];
        end

    end
    
    function b = hasDocumentWithName(this, name)
        % returns true if the app contains a doc with the given name
        
        b = false;
        for i = 1:length(this.docList)
            doc = this.docList{i};
            if isempty(doc.image)
                continue;
            end
            
            if strcmp(doc.image.name, name)
                b = true;
                return;
            end
        end
    end
     
end

%% Method for local settings
methods
    function conn = getDefaultConnectivity(this, dim)
        % Get the default connectivity associated to a dimension
        % Defaults are 4 for 2D, and 6 for 3D.
        %
        
        if nargin == 1
            dim = 2;
        end
        conn = this.defaultConnectivity(dim - 1);
    end
    
    function setDefaultConnectivity(this, dim, conn)
        % Changes the default connectivity associated to a dimension
        this.defaultConnectivity(dim - 1) = conn;
    end
    
end

end % classdef


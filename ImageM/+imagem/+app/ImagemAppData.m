classdef ImagemAppData < handle
% ImageM application class, that manages open images.
%
%   output = ImagemAppData(input)
%
%   Example
%   ImagemAppData
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-03-10,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    % Set of documents (images, tables...) managed by this application.
    DocList;
    
    % Default connectivity associated to each dimension.
    % Equals 4 for 2D, and 6 for 3D. Stored as a row vector, starting at
    % dim=2 (no need for connectivity info for 1D)
    DefaultConnectivity = [4 6];
    
    % The size (diameter) of the brush (in pixels).
    BrushSize = 3;
    
    % The value used to draw the brush
    BrushValue = 255;
    
    % The color used to draw the brush in color images
    BrushColor = [255 255 255];
    
    % History of user commands, as a cell array of strings.
    History = cell(0, 1);
end 

%% Constructor
methods
    function obj = ImagemAppData(varargin)
        % Constructor for the ImagemAppData class.
    end

end % construction function

%% General methods
methods

    function printVersion(obj) %#ok<MANU>
        % 
        disp('ImageM is running...');
        disp('testing version!');
        
    end
end % general methods


%% Methods for management of image documents
methods
    function [doc, tag] = createImageDocument(obj, image, newName, refTag)
        % Create a new image document, add it to app, and return doc.
        %
        % DOC = createImageDocument(APP, IMG);
        % Creates the new document for the image IMAGE, in the instance of
        % ImageMAppData given by APP.
        %

        
        % determine the name of the new image
        if nargin < 3 || isempty(newName)
            % find a 'free' name for image
            newName = createDocumentName(obj, image.Name);
        end
        image.Name = newName;
        
        % creates new instance of ImageDoc
        doc = imagem.app.ImageDoc(image);
        
        % setup document tag
        if nargin < 4
            tag = createImageTag(obj, image);
        else
            tag = createImageTag(obj, image, refTag);
        end
        doc.Tag = tag;
        
        % compute LUT of label image
        if isLabelImage(image)
            doc.ColorMapName = 'jet';
            nLabels = double(max(image.Data(:)));
            if nLabels < 255
                baseLut = jet(255);
                inds = floor((1:nLabels)*255/nLabels);
                doc.ColorMap = baseLut(inds,:);
            else
                doc.ColorMap = jet(nLabels);
            end
        end
        
        % add ImageDoc to the application
        addDocument(obj, doc);
    end
    
    function doc = getImageDocument(obj, imageName)
        % Returns the image document with specified name.
        % If several images have the same name, returns the first one.
        
        if ~ischar(imageName)
            error('image name should be specified as a string');
        end
        
        for i = 1:length(obj.DocList)
            doc = obj.DocList{i};
            if isa(doc, 'imagem.app.ImageDoc')
                if strcmp(doc.Image.Name, imageName)
                    return;
                end
            end
        end
        
        error(['Could not find any image document with name: ' imageName]);
    end

    function names = getImageNames(obj)
        % returns a cell array of strings containing name of each image.
        names = {};
        for i = 1:length(obj.DocList)
            doc = obj.DocList{i};
            if isa(doc, 'imagem.app.ImageDoc')
                names = [names {doc.Image.Name}]; %#ok<AGROW>
            end
        end
    end
    
    function newTag = createImageTag(obj, image, baseName)
        % finds a name that can be used as tag for obj image

        % If no tag is specified, choose a base name that describe image
        % type
        if nargin < 3 || isempty(baseName)
            % try to use a more specific tag depending on image type
            if isBinaryImage(image)
                baseName = 'bin';
            elseif isLabelImage(image)
                baseName = 'lbl';
            else
                % default tag for any type of image
                baseName = 'img';
            end
        end
               
        % if the name is free, no problem
        if isFreeTag(obj, baseName)
            newTag = baseName;
            return;
        end
        
        % iterate on indices until we find a free tag
        index = 1;
        while true
            newTag = [baseName num2str(index)];
            if isFreeTag(obj, newTag)
                return;
            end
            index = index + 1;
        end
    end
    
end


%% Methods for management of Table documents
methods
    function doc = createTableDocument(obj, table, varargin)
        % Create a new image document, add it to app, and return doc.
        %
        % Syntax:
        % doc = createTableDocument(app, table)
        % Create a new document from the Table object
        %
        % doc = createTableDocument(app, table, parentDoc)
        % Also copies some information from parent document.
        %
        % doc = createTableDocument(..., NAME)
        % specifies the name of the new table.
        %
        
        % default values
        refTag = '';
        newName = '';
        parentDoc = '';
        
        while ~isempty(varargin)
            if isa(varargin{1}, 'imagem.app.TableDoc')
                parentDoc = varargin{1};
                
            elseif ischar(varargin{1})
                if isempty(newName)
                    newName = varargin{1};
                else
                    refTag = varargin{1};
                end
            end
            
            varargin(1) = [];
            continue;
        end
        
        % determine the name of the new image
        if isempty(newName)
            % find a 'free' name for image
            newName = createDocumentName(obj, table.Name);
        end
        table.Name = newName;
        
        % creates new instance of TableDoc
        doc = imagem.app.TableDoc(table);
        
        % optionnally copy some info
        if ~isempty(parentDoc)
            doc.ImageSize = parentDoc.ImageSize;
        end
        
        % setup document tag
        tag = createTableTag(obj, table, refTag);
        doc.Tag = tag;
        
        % add ImageDoc to the application
        addDocument(obj, doc);
    end
    
    function doc = getTableDocument(obj, tableName)
        % Returns the table document with specified name.
        % If several tables have th esame name, returns the first one.
        
        if ~ischar(tableName)
            error('table name should be specified as a string');
        end
        
        for i = 1:length(obj.DocList)
            doc = obj.DocList{i};
            if isa(doc, 'imagem.app.TableDoc')
                if strcmp(doc.Table.Name, tableName)
                    return;
                end
            end
        end
        
        error(['Could not find any table with name: ' tableName]);
    end

    function names = getTableNames(obj)
        % returns a cell array of strings containing name of each table.
        names = {};
        for i = 1:length(obj.DocList)
            doc = obj.DocList{i};
            if isa(doc, 'imagem.app.TableDoc')
                names = [names {doc.Table.Name}]; %#ok<AGROW>
            end
        end
    end

    function newTag = createTableTag(obj, table, baseName) %#ok<INUSL>
        % finds a name that can be used as tag for a table document

        % If no tag is specified, choose a base name that describe table
        if nargin < 3 || isempty(baseName)
            % default tag for tables
            baseName = 'tab';
        end
               
        % if the name is free, no problem
        if isFreeTag(obj, baseName)
            newTag = baseName;
            return;
        end
        
        % iterate on indices until we find a free tag
        index = 1;
        while true
            newTag = [baseName num2str(index)];
            if isFreeTag(obj, newTag)
                return;
            end
            index = index + 1;
        end
    end
    
end


%% Method for document management
methods
    function addDocument(obj, doc)
        obj.DocList = [obj.DocList {doc}];
    end
    
    function removeDocument(obj, doc)
        ind = -1;
        for i = 1:length(obj.DocList)
            if obj.DocList{i} == doc
                ind = i;
                break;
            end
        end
        
        if ind == -1
            error('could not find the document');
        end
        
        obj.DocList(ind) = [];
    end

    function docList = getDocuments(obj)
        docList = obj.DocList;
    end
    
    
    function b = hasDocuments(obj)
        b = ~isempty(obj.DocList);
    end

    function doc = getDocument(obj, index)
        % Returns a document, either by its index, or by its name
        
        if isnumeric(index)
            doc = obj.DocList{index};
            
        elseif ischar(index)
            doc = [];
            for i = 1:length(obj.DocList)
                currentDoc = obj.DocList{i};
                if strcmp(currentDoc.Image.Name, index)
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

    function newName = createDocumentName(obj, baseName)
        % returns either the base name of doc, or the name with an index
       
        if isempty(baseName)
            baseName = 'NoName';
        end
        newName = baseName;
               
        % if the name is free, no problem
        if ~hasDocumentWithName(obj, baseName)
            return;
        end
        
        % otherwise, we first check if name contains an "index"
        % here: the number at the end of the name, separated by a minus
        [path, name, ext] = fileparts(baseName);
        isDigit = ismember(name, '1234567890');
        numDigits = length(name) - find(~isDigit, 1, 'last');
        if numDigits > 0 && numDigits < length(name) && name(end-numDigits) == '-'
            baseName = fullfile(path, [name(1:end-numDigits-1) ext]);
        end
        
        index = 1;
        while true
            newName = createIndexedName(baseName, index);
            if ~hasDocumentWithName(obj, newName)
                return;
            end
            index = index + 1;
        end
        
        % inner function
        function name = createIndexedName(baseName, index)
            % add the given number to the name of the document
            [path, name, ext] = fileparts(baseName);
            name = [name '-' num2str(index) ext];
        end

    end
    
    function b = hasDocumentWithName(obj, name)
        % returns true if the app contains a doc with the given name
        
        b = false;
        for i = 1:length(obj.DocList)
            doc = obj.DocList{i};
            if isa(doc, 'imagem.gui.ImageDoc')
                if strcmp(doc.Image.Name, name)
                    b = true;
                    return;
                end
            elseif isa(doc, 'imagem.gui.TableDoc')
                if strcmp(doc.Table.Name, name)
                    b = true;
                    return;
                end
            end
        end
    end
    
    function b = isFreeTag(obj, tag)
        % returns true if the app contains a doc with the given tag
        
        b = true;
        for i = 1:length(obj.DocList)
            doc = obj.DocList{i};            
            if strcmp(doc.Tag, tag)
                b = false;
                return;
            end
        end
    end

end


%% App global variables
methods
    function addToHistory(obj, string)
        % Add the specified string to app history
        obj.History = [obj.History ; {string}];
        fprintf('%s', string);
    end

    function printHistory(obj)
        % display stored history
        fprintf('Command history:\n');
        for i = 1:length(obj.History)
            fprintf(obj.History{i});
        end
    end

end

%% Method for local settings
methods
    function conn = getDefaultConnectivity(obj, dim)
        % Get the default connectivity associated to a dimension
        % Defaults are 4 for 2D, and 6 for 3D.
        %
        
        if nargin == 1
            dim = 2;
        end
        conn = obj.DefaultConnectivity(dim - 1);
    end
    
    function setDefaultConnectivity(obj, dim, conn)
        % Changes the default connectivity associated to a dimension
        obj.DefaultConnectivity(dim - 1) = conn;
    end
    
end

end % classdef


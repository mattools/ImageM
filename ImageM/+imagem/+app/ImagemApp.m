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
end 

%% Constructor
methods
    function this = ImagemApp(varargin)
        
        
    end % constructor 

end % construction function

%% General methods
methods

    function printVersion(this)
        % 
        disp('ImageM is running...');
        disp('testing version!');
        
    end
end % general methods

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

    function docList = documentList(this)
        disp('method ''documentList()'' is deprecated, use ''getDocuments()'' instead');
        docList = this.docList;
    end
    
    function docList = getDocuments(this)
        docList = this.docList;
    end
    
    function b = hasDocuments(this)
        b = ~isempty(this.docList);
    end
    
end

end
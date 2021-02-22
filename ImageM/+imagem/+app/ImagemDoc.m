classdef ImagemDoc < handle
% ImageM Document class that contains one image and the associated data.
%
%   Class ImagemDoc
%
%   Example
%   ImagemDoc
%
%   See also
%     ImageDoc, TableDoc

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2011-10-22,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


%% Properties
properties
    % The short name used to identify document on command-line arguments.
    % Examples of common tags: img01, tab02, lbl03...
    Tag;
 
    % A flag of modification.
    Modified = false;
    
    % A set of views attached to this doc. Can be image viewer, profiles...
    Views = {};
    
end % end properties


%% Constructor
methods
    function obj = ImagemDoc()
    % Constructor for ImagemDoc class.
    end

end % end constructors


%% Methods for view management
methods
    function addView(obj, v)
        obj.Views = [obj.Views {v}];
    end
    
    function removeView(obj, v)
        ind = -1;
        for i = 1:length(obj.Views)
            if obj.Views{i} == v
                ind = i;
                break;
            end
        end
        
        if ind == -1
            error('could not find the view');
        end
        
        obj.Views(ind) = [];
    end
    
    function v = getViews(obj)
        v = obj.Views;
    end
    
end % end methods

end % end classdef


classdef Concatenate < imagem.actions.CurrentTableAction
% Concatenate tables, either horizontally or vertically.
%
%   Class Concatenate
%
%   Example
%   Concatenate
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-11-26,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    Handles;
    Frame;
    
    TableNameList;
end % end properties


%% Constructor
methods
    function obj = Concatenate(varargin)
    % Constructor for Concatenate class

    end

end % end constructors


%% Methods
methods
    function run(obj, frame) %#ok<INUSD>
               
        obj.Frame = frame;

        % initialize clas fields
        app = frame.Gui.App;
        obj.TableNameList = getTableNames(app);
        if length(obj.TableNameList) < 2
            errordlg('Requires At least two table frames', 'modal');
            return;
        end
        
        directions = {'Columns', 'Rows'};
        
        gd = imagem.gui.GenericDialog('Concatenate Tables');
        addChoice(gd, 'Direction: ', directions, directions{1});
        addChoice(gd, 'Table 1: ', obj.TableNameList, obj.TableNameList{1});
        addChoice(gd, 'Table 2: ', obj.TableNameList, obj.TableNameList{2});

        showDialog(gd);
        if wasCanceled(gd)
            return;
        end
        
        dirIndex = getNextChoiceIndex(gd);
        name1 = getNextString(gd);
        name2 = getNextString(gd);
        
        doc1 = getTableDocument(app, name1);
        doc2 = getTableDocument(app, name2);
        
        if dirIndex == 1
            % concatenate columns
            res = [doc1.Table doc2.Table];
            catStr = ' ';
        else
            % concatenate rows
            res = [doc1.Table ; doc2.Table];
            catStr = ' ; ';
        end
        
        % create document containing the new image
        [newFrame, newDoc] = createTableFrame(frame.Gui, res); %#ok<ASGLU>

        % add history
        string = sprintf('%s = [%s%s%s];\n', ...
            newDoc.Tag, doc1.Tag, catStr, doc2.Tag);
        addToHistory(obj.Frame, string);

    end
end % end methods

end % end classdef


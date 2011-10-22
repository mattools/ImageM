function test_suite = test_ImagemApp(varargin) %#ok<STOUT>
%TEST_IMAGEMAPP  Test case for the file ImagemApp
%
%   Test case for the file ImagemApp

%   Example
%   test_ImagemApp
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-10-22,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

initTestSuite;

function test_AddRemoveDocs %#ok<*DEFNU>

% create an appli
app = imagem.app.ImagemApp;
assertFalse(hasDocuments(app));

% create some images
img1 = Image.read('peppers.png');
img2 = Image.read('cameraman.tif');

% create one doc for each image
doc1 = imagem.app.ImagemDoc(img1);
doc2 = imagem.app.ImagemDoc(img2);

% add images to the doc
app.addDocument(doc1);
assertTrue(hasDocuments(app));
app.addDocument(doc2);

app.removeDocument(doc1)
assertTrue(hasDocuments(app));
app.removeDocument(doc2)
assertFalse(hasDocuments(app));


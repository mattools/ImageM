function tests = test_VectorImageNorm
% Test suite for the file VectorImageNorm.
%
%   Test suite for the file VectorImageNorm
%
%   Example
%   test_VectorImageNorm
%
%   See also
%     VectorImageNorm

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-01-04,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);


function test_constructor(testCase) %#ok<*DEFNU>
% Test call of function without argument.

view = imagem.util.vectorImage.VectorImageNorm();

assertTrue(testCase, isa(view, 'imagem.util.vectorImage.VectorImageNorm'));


function test_convert(testCase) %#ok<*DEFNU>
% Test call of function without argument.

data = 3 * ones([30 20 4]);
img = Image('Data', data, 'vector', true);
view = imagem.util.vectorImage.VectorImageNorm();

res = convert(view, img);

assertTrue(testCase, isa(res, 'Image'));
assertEqual(testCase, size(res), size(img));
assertEqual(testCase, res.Data(1,1), 6.0, 'AbsTol', .01);


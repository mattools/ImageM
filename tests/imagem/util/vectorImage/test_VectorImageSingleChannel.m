function tests = test_VectorImageSingleChannel
% Test suite for the file VectorImageSingleChannel.
%
%   Test suite for the file VectorImageSingleChannel
%
%   Example
%   test_VectorImageSingleChannel
%
%   See also
%     VectorImageSingleChannel

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2021-01-04,    using Matlab 9.8.0.1323502 (R2020a)
% Copyright 2021 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);


function test_constructor(testCase) %#ok<*DEFNU>
% Test call of function without argument.

view = imagem.util.vectorImage.VectorImageSingleChannel();

assertTrue(testCase, isa(view, 'imagem.util.vectorImage.VectorImageSingleChannel'));


function test_convert(testCase) %#ok<*DEFNU>
% Test call of function without argument.

data = 3 * ones([30 20 4]);
img = Image('Data', data, 'vector', true);
view = imagem.util.vectorImage.VectorImageSingleChannel();

res = convert(view, img);

assertTrue(testCase, isa(res, 'Image'));
assertEqual(testCase, size(res), size(img));
assertEqual(testCase, res.Data(1,1), 3.0, 'AbsTol', .01);


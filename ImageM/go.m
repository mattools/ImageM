%GO  run script for ImageM
%
%   output = go(input)
%
%   Example
%   go
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-10-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% clean up
close all
clear classes

% load demo image
img = Image.read('cameraman.tif');

% display it!
ImageM(img);

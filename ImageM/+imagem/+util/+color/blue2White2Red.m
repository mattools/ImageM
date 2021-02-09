function newmap = blue2White2Red(m)
%BLUE2WHITE2RED   Blue to white to red color map.
%
%   blue2White2Red(M)
%   Returns an M-by-3 matrix containing a blue to white to red colormap,
%   with white corresponding to the CAXIS value closest to zero.  
%   This colormap is most useful for images and surface plots with positive
%   and negative values.
%
%   Example
%     figure
%     surf(peaks)
%     colormap(bluewhitered)
%     axis tight
%
%   See also HSV, HOT, COOL, BONE, COPPER, PINK, FLAG, 
%   COLORMAP, RGBPLOT.

% default number of values
if nargin < 1
   m = 256;
end

% define color "waypoints"
bottom = [0 0 0.5];
botmiddle = [0 0.5 1];
middle = [1 1 1];
topmiddle = [1 0 0];
top = [0.5 0 0];

% It has both negative and positive
% Find ratio of negative to positive
ratio   = .5;
neglen  = round(m * ratio);
poslen  = m - neglen;


% Process colors for negative part
new     = [bottom; botmiddle; middle];
len     = length(new);
oldsteps = linspace(0, 1, len);
newsteps = linspace(0, 1, neglen);
newmap1 = zeros(neglen, 3);

for i = 1:3
    % Interpolate over RGB spaces of colormap
    newmap1(:,i) = min(max(interp1(oldsteps, new(:,i), newsteps), 0), 1)';
end


% Process colors for positive part
new = [middle; topmiddle; top];
len = length(new);
oldsteps = linspace(0, 1, len);
newsteps = linspace(0, 1, poslen);
newmap = zeros(poslen, 3);

for i = 1:3
    % Interpolate over RGB spaces of colormap
    newmap(:,i) = min(max(interp1(oldsteps, new(:,i), newsteps), 0), 1)';
end


% concatenate
newmap = [newmap1; newmap];

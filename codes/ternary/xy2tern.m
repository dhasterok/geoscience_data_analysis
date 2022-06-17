function [a,b,c] = xy2tern(x,y)
% XY2TERN - Converts cartesian to ternary coordinates
%
%    The order of the axes are as follows:
%
%                    A
%                   / \
%                  /   \
%                 B --- C
%
%    See also TERN2XY

% half-width
w = 0.5;

% vertical scale
h = 0.5/tan(pi/6);

% position of points
%      A
%     / \
%    /   \
%   B --- C
a = y/h;
b = 1 - (w + x + y*tan(pi/6))*cos(pi/6)/h;
c = 1 - a - b;

return

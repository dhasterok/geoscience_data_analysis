function varargout = rosehist(theta,n,a,varargin);
% ROSEHIST - Computes a rose histogram
%
%   [EDGES,BIN] = ROSEHIST(THETA,N) computes the a rose histogram from the
%   angles, THETA, with N divisions and bin boundaries defined by EDGES.
%   The number of values within each bin are given
%   by BIN.
%
%   [EDGES,BIN] = ROSEHIST(THETA,N,A) computes a rose histogram with a
%   repeat angle of 360/A.
%
%   ROSEHIST(THETA,N) produces a rose histogram plot using ROSEPLOT if
%   ROSEHIST is given no return arguments.
%
%   ROSEHIST(THETA,N,'AngleConvention',VAL) produces a rose histogram with
%   an angle convention from 0 to 360 (VAL = 360), and -180 to 180
%   (VAL = 180). Angles out of convention bounds will be shifted
%   appropriately.
%
% See also: ROSEPLOT

% Original: 3 Feb 2006 by D. Hasterok (Univ. Utah)
% Last Modified: 13 Sept 2013 by D. Hasterok (Univ. Adelaide)

if ~exist('n','var')
    n = 360;
end
if ~exist('a','var')
    a = 1;
end
convention = 360;
if nargin > 3
    convention = varargin{1};
end

theta = theta(:);

% Bin edges
% depend on convention
% fix out of convention angles
if convention == 360
    edges = linspace(0,360,a*(n+1));
    
    ind = theta < 0;
    theta(ind) = 360 + theta(ind);
elseif convention == 180
    edges = linspace(-180,180,a*(n+1));
    
    ind = theta > 180;
    theta(ind) = theta(ind) - 360;
else
    error('Unknown AngleConvention.');
end

if a ~= 1
    dt = 360/a;
    angle = [convention-360:dt:convention];
    
    for i = 2:length(angle)-1
        ind = angle(i) < theta <= angle(i+1);
        tmp = theta(ind) - (i-1)*dt;
    end
    theta = tmp;
end

% Histogram
bin = zeros([1 length(edges)-1]);
for i = 1:n
    ind = edges(i) <= theta & theta < edges(i+1);
    bin(i) = sum(ind);
end

if a ~= 1
    for i = 2:a
        bin((i-1)*n+1:i*n) = bin(1:n);
    end
end

% Assign output arguments and/or plot histogram.
if nargout > 1
    varargout{1} = edges;
    varargout{2} = bin;
else
    %bar(edges(1:length(edges)-1),bin,'histc');
    %break
    p = roseplot(edges,bin, ...
        'PlotType','histogram', ...
        'AngleConvention',convention);
    varargout{1} = p;
end

return % ROSEHIST

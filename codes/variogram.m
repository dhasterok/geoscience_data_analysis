function [r,gamma] = variogram(x,y,v,varargin)

R = 6371;
llflag = 0;
if nargin == 4
    llflag = varargin{1};
end

% number of lags
nh = 80;

% compute range
nx = length(x);
xrange = max(x) - min(x);
yrange = max(y) - min(y);

% lag values
h = linspace(0,0.5*min([xrange yrange]),nh)';
if llflag
    h = R*h*pi/180;
end

% for each lag
gamma = zeros([nh-1 1]);
N = zeros([nh-1 1]);

% compute distance between every point and every other point
for i = 1:nx-1
    if ~llflag % Cartesian coordinates
        D = sqrt((x(i) - x(i+1:nx)).^2 - (y(i) - y(i+1:nx)).^2);
    else % longitude and latitude coordinates
        D = R*sphangle(x(i+1:nx),y(i+1:nx),x(i),y(i));
    end

    % squared difference of values
    dV = (v(i) - v(i+1:nx)).^2;
    
    for j = 1:nh-1
        % find data within lag
        ind = h(j) <= D & D < h(j+1);

        % variogram values
        if sum(ind) > 0
            gamma(j) = gamma(j) + sum(dV(ind));
            N(j) = N(j) + sum(ind);
        end
    end
end
gamma = 0.5*gamma./N;

% midpoint of lag distances
r = midpt(h);

return
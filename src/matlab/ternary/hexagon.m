function hexbin = hexagon(n)
% hexagon - tesselates hexagons within a triangle.
%
%   hexbin = hexagon(N) tesselates a hexaogonal polygon with a triangle
%   returning the vertices within the structure hexbin.  N sets the
%   resolution, i.e., number of bins along the x-axis.  Memory is allocated
%   within hexbin for common statistical parameters.

if n <= 0 || floor(n) ~= n
    error('N must be a positive integer.');
end

% rotation angles
rot = linspace(0,360,7)*pi/180;

% create first vertex
y = 0.5/(3*n*tan(pi/6));
x = y*tan(pi/6);

% create hexagon verticies (first is repeated to close polygon)
xv = x*cos(rot) - y*sin(rot);
yv = x*sin(rot) + y*cos(rot);

% create hexbin structure
hexbin(1).xv = xv;
hexbin(1).yv = yv;
hexbin(1).n = 0;
hexbin(1).mean = nan;
hexbin(1).median = nan;
hexbin(1).std = nan;

% number of polygons is 3*n*(n+1)/2 + 1
hexbin = repmat(hexbin,3*n*(n+1)/2+1,1);

% create the hexagons
%figure;
%hold on;
c = 1;
% create cells in groups of horizontal rows of hexagons.  Must create three
% sets of rows in the pattern n n-1 n-2, n-1 n-2 n-3, ... , 3 2 1, 2 1 0,
% and then add (after the loops the last row) with a single hexagon
% note: hexagons at the verticies of the triangle and along the edges have
% to be trimmed.
for j = n:-1:1
    for i = [1:j+1]-(j+2)/2
        hexbin(c).xv = xv + i*6*x;
        hexbin(c).yv = yv + 3*(n-j)*y;
        if j == n && i == 1-(n+2)/2 % bottom left cell
            hexbin(c).xv = [hexbin(c).xv(1) i*6*x hexbin(c).xv(6) hexbin(c).xv(1)];
            hexbin(c).yv = [hexbin(c).yv(1) 0 hexbin(c).yv(6) hexbin(c).yv(1)];
        elseif j == n && i == n+1-(n+2)/2 % bottom right cell
            hexbin(c).xv = [hexbin(c).xv(2) hexbin(c).xv(3) i*6*x  hexbin(c).xv(2)];
            hexbin(c).yv = [hexbin(c).yv(2) hexbin(c).yv(3) 0  hexbin(c).yv(2)];
        elseif j == n % bottom cells
            hexbin(c).xv = [hexbin(c).xv(1) hexbin(c).xv(2) hexbin(c).xv(3) hexbin(c).xv(6) hexbin(c).xv(1)];
            hexbin(c).yv = [hexbin(c).yv(1) hexbin(c).yv(2) hexbin(c).yv(3) hexbin(c).yv(6) hexbin(c).yv(1)];
        else
            if i == 1-(j+2)/2 % left cells
                hexbin(c).xv = [hexbin(c).xv(1) hexbin(c).xv(4) hexbin(c).xv(5) hexbin(c).xv(6) hexbin(c).xv(1)];
                hexbin(c).yv = [hexbin(c).yv(1) hexbin(c).yv(4) hexbin(c).yv(5) hexbin(c).yv(6) hexbin(c).yv(1)];
            elseif i == j+1-(j+2)/2 % right cells
                hexbin(c).xv = [hexbin(c).xv(2) hexbin(c).xv(3) hexbin(c).xv(4) hexbin(c).xv(5) hexbin(c).xv(2)];
                hexbin(c).yv = [hexbin(c).yv(2) hexbin(c).yv(3) hexbin(c).yv(4) hexbin(c).yv(5) hexbin(c).yv(2)];
            end
        end
        
        %fill(hexbin(c).xv,hexbin(c).yv,[0.7 0.7 0.7]);
        c = c + 1;
    end
    
    for i = [1:j]-(j+1)/2
        hexbin(c).xv = xv + i*6*x;
        hexbin(c).yv = yv + (3*(n-j)+1)*y;

        %fill(hexbin(c).xv,hexbin(c).yv,[0.5 0.5 0.5]);
        c = c + 1;
    end
    if j-1 ~= 0
        for i = [1:j-1]-j/2
            hexbin(c).xv = xv + i*6*x;
            hexbin(c).yv = yv + (3*(n-j)+2)*y;

            %fill(hexbin(c).xv,hexbin(c).yv,[0.3 0.3 0.3]);
            c = c + 1;
        end
    end
end
% top cell
hexbin(c).xv = xv;
hexbin(c).yv = yv+3*n*y;

hexbin(c).xv = [hexbin(c).xv(4) hexbin(c).xv(5) 0 hexbin(c).xv(4)];
hexbin(c).yv = [hexbin(c).yv(4) hexbin(c).yv(5) 3*n*y hexbin(c).yv(4)];

%fill(hexbin(c).xv,hexbin(c).yv,[0.7 0.7 0.7]);
%axis equal
%terngrid

return
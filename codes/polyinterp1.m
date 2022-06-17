function yi = polyinterp1(x,y,xi);
% POLYINTERP1 - 1D polynomial interpolation
%
%   yi = polyinterp1(x,y,xi) will interpolate the set of points (x,y) to
%   the locations contained in xi.

% Original: 2019 by D. Hasterok (Univ. Adelaide)
x = x(:);
y = y(:);
xi = xi(:);

Np = length(x);
Ni = length(xi);

% preallocate matricies
A = zeros([Np,Np]);
B = zeros([Ni,Np]);

% create linear system coefficients
A(:,1) = ones(size(x));
B(:,1) = ones(size(xi));
for i = 2:Np
    A(:,i) = x.^(i-1);
    B(:,i) = xi.^(i-1);
end

% determine polynomal coefficients
m = inv(A)*y;

% compute interpolated values
yi = B*m;

return
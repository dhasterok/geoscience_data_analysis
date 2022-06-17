function [sigma,R] = circstd(angles,varargin);
% CIRCSTD - computes the circular standard deviation
%
%   [sigma,R] = circstd(angles) computes the circular standard deviation 
%   and resultant (peakedness) of a 360 distribution from a set of
%   angles in degrees.
%
%   sigma = circstd(angles,a) computes the circular standard deviation for
%   distributions which have repeats every 360/a degrees.

% D. Hasterok (Univ. Adelaide, 2019)

if nargin == 2
    a = varargin{1};
else
    a = 1;
end

% split angles into Cartesian components
S = sum(sin(a*pi/180*angles));
C = sum(cos(a*pi/180*angles));

% resultant vector
R = sqrt(S^2 + C^2)/length(angles);

% standard deviation
sigma = 180/pi*sqrt(2*(1 - R))/a;

return
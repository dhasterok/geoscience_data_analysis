function mu = circmean(angles,varargin);
% CIRCMEAN - computes the circular mean
%
%   mu = circmean(angles) computes the circular mean of a 360 
%   distribution from a set of angles in degrees.
%
%   mu = circmean(angles,a) computes the circular mean for distributions
%   which have repeats every 360/a degrees.

% D. Hasterok (Univ. Adelaide, 2019)

if nargin == 2
    a = varargin{1};
else
    a = 1;
end

% split angles into cartesian components
S = sum(sin(a*pi/180*angles));
C = sum(cos(a*pi/180*angles));

% compute mean angle
mu = 180/pi*atan2(S,C)/a;

return
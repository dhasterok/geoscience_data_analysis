function PDF = maxbolt(x,a)

% MAXBOLT - Maxwell-Boltzmann distribution.
%
%    Maxwell-Boltzmann distribution PDF = maxbolt(x,a)

PDF = sqrt(2/pi)*x.^2.*exp(-0.5*x.^2*a^-2)*a^-3;

return

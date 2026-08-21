function x = randmb(N,a)
% RANDMB - Maxwell-Boltzmann distributed random numbers.
%
%    X = RANDMB(N,A) computes a N-by-N random number with a Maxwell-
%    Boltzmann distribution for sufficiently large N.  If N is a two
%    element vector, then RANDMB computes an M-by-N set of random numbers.
%    The probability distribution function (PDF) for the Maxwell-Boltzmann
%    distribution is
%
%        P(x) = sqrt(2/pi) x^2 exp[-x^2/(2a^2)]/a .
%
%    The distribution mean is given by
%
%        mu = 2 a sqrt(2/pi) ,
%
%    and variance by
%
%        sigma^2 = a^2(3 - 8/pi) .
%
%    This distribution is similar to a Gaussian except that it has the
%    added advantage that P(x) = 0 at x = 0.  This is particularly
%    advantageous when a dataset that can only hold positive or negative
%    values, yet has an mean close enough to zero and large enough
%    standard deviation that the origin will be crossed by the uncertainty.
%

% Original: 18 August 2010 by D. Hasterok
% Revised: 28-July 2011 by D. Hasterok.  Moved the inverse CDF
%   computation into an external function CDFINV_MB for more general
%   use.

% Number of dimensions
ndim = length(N);

% Number of rows (nr) and columns (nc) of final random numbers
if ndim == 1
    nr = N;
    nc = N;
else
    nr = N(1);
    nc = N(2);
end

% Uniform random numbers on (0,1)
u = rand(N);

% Compute random number x:P(x) is a Maxwell-Boltzmann distribution for
% large N
x = cdfinv_mb(u,a);

return

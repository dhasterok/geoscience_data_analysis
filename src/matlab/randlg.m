function x = randmb(N,mu,sigma)
% RANDLG - Log-normal distributed random numbers.
%
%    X = RANDLG(N,A) computes a N-by-N random number with a Log-normal
%    distribution for sufficiently large N.  If N is a two
%    element vector, then RANDLG computes an M-by-N set of random numbers.
%    The probability distribution function (PDF) for the Log-normal
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
% Last Modified: 18 August 2010 by D. Hasterok

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

% Compute random number x:P(x) is a Log-normal distribution for
% large N
x = cdfinv_lg(u,mu,sigma);

return

function P = circnormal(theta,mu,sigma,varargin)
% CIRCNORMAL - computes the circular normal
%
%   P = circnormal(angle,mu,sigma) computes probability distribution for
%   circular normal distribution.
%
%   P = circnormal(angle,mu,sigma) computes the circular distributions
%   which have repeats every 360/a degrees.
%
%   theta, sigma and, mu should all be in degrees.

% D. Hasterok (Univ. Adelaide, 2019)

if nargin == 4
    a = varargin{1};
else
    a = 1;
end

sigma = sigma*pi/180;
mu = mu*pi/180;
theta = theta*pi/180;

% repeat to ensure proper peaks
k = [-a:a];
for i = 1:length(theta)
    P(i) = 1/(sigma*sqrt(2*pi))*sum(exp(-(a*theta(i) - mu + 2*pi*k).^2/(2*sigma^2)));
end

return
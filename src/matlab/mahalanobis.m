function [dsquared,varargout] = mahalanobis(x,varargin)
% MAHALANOBIS - Computes multivariate distance.
%
%   [dsquared,varargout] = mahalanobis(x) computes the Mahalanobis distance
%   (i.e., multivariate distance to the data centroid).
%
%   [dsquared,varargout] = mahalanobis(x,mu,V) where mu is the mean of the
%   data and V is the covariance matrix.
%
%   If the data need to be recentered using centered log-ratio (clr) or
%   isometric log-ratio (ilr) transformations, then an additional
%   argument can be added to the end of the input variables to do so.
%
%   [dsquared,varargout] = mahalanobis(x,'recenter') where 'recenter is
%   either 'clr' or 'ilr'.

% D. Hasterok, 11 Feb 2019

if nargin == 2
    x = recenter(x,varargin{1});

    mu = mean(x,1);
    V = cov(x);
elseif nargin >= 3
    mu = varargin{1};
    V = varargin{2};
    if nargin == 4
        x = recenter(x,varargin{3});
    end
else
    mu = mean(x,1);
    V = cov(x);
end

invV = inv(V);
for i = 1:size(x,1)
    dsquared(i,1) = (x(i,:) - mu)*invV*(x(i,:) - mu)';
end


if nargout > 1
    varargout{1} = mu;
    varargout{2} = V;
end

return


function z = recenter(x,cf)
% recenters the data using a clr or ilr transform as indicated by the
% input
switch cf
    case 'none'
        z = x;
    case 'clr'
        z = clr(x);
    case 'ilr'
        z = ilr(x);
    otherwise
        error('Unknown log-ratio transform.');
end

return
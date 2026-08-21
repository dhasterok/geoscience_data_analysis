function [model,r] = llsq(yd,A,varargin)
% LLSQ - linear least squares regression
%
%   model = llsq(yd,A) computes the linear least squares model given a
%   data vector, yd, and operator matrix, A, generally with the first
%   column as zeros.  The output model is a structure that contains the
%   model parameters .m, 95% confidence intervals associated with the model
%   parameter, .ci, root mean square (RMS) misfit, .rms, and coefficient of
%   determination, .rsq.
%
%   [model,r] = llsq(yd,A) additionally returns the model residuals.
%
%   To set the confidence interval, model = llsq(yd,A,'Alpha',alpha).

% Last Modified: 20 June 2023
% D. Hasterok, University of Adelaide

% parse inputs
% -------------------------
p = inputParser;

addRequired(p,'DataVector',@isnumeric);
addRequired(p,'OperatorMatrix',@isnumeric);
addParameter(p,'Alpha',0.95);

parse(p,yd,A,varargin{:});

model.alpha = p.Results.Alpha;
% -------------------------

% covariance matrix
C = inv(A'*A);

% compute model parameters
model.m = C*A'*yd;

% modeled data
ym = A*model.m;

% residual
r = yd - ym;

% number of degrees of freedom
df = height(A) - height(model.m);

% confidence interval
model.ci = tinv(model.alpha,df)*diag(C*(r'*r)/(df - 1)).^(1/2);

% root-mean-square (RMS) misfit
model.rms = sqrt(sum(r.^2/length(yd)));

% zero mean
model.rsq = sum((ym - mean(yd)).^2)/sum((yd - mean(yd)).^2);

%yd0 = y - mean(y);

% compute r^2 value
% this didn't work
%rsq = 1 - r'*r/(yd0'*yd0);
%mss = sum((A*m(:,1) - mean(A*m(:,1))).^2);
%rss = sum(r.^2);

%rsq = mss/(mss + rss);

return
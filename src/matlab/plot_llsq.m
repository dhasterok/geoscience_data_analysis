function h = plot_llsq(x,y,m,varargin)
% plot_llsq - plot a linear regression model and confidence intervals
%
%   h = plot_llsq(x,y,m) will plot a linear least squares model with 95%
%   confidence bounds.  It returns the handles, h, to the graphics objects.
%
%   Options:
%       'Alpha'             set the confidence interval, default 0.95
%
%       'XLim'              x limits for plotting the model

% Last Modified: 20 June 2023
% D. Hasterok, University of Adelaide

% parse inputs
% -------------------------
p = inputParser;

addRequired(p,'X',@isnumeric);
addRequired(p,'Y',@isnumeric);
addRequired(p,'m',@isnumeric);
addParameter(p,'Alpha',0.95,@isnumeric);
addParameter(p,'XLim',[],@isnumeric);

parse(p,x,y,m,varargin{:});

% x vector and weights
if size(x,2) == 2
    w = x(:,2);
    x = x(:,1);
else
    w = ones(size(x));
end

alpha = p.Results.Alpha;
% -------------------------

% x limits for plotting model
xl = p.Results.XLim;
if isempty(xl)
    xl = [min(x) max(x)];
end

Nd = length(x);     % number of data
Nm = length(m);     % number of model parameters

% number of degrees of freedom
nu = length(x) - length(m);

% points along model
xtmp = linspace(xl(1),xl(2),50)';
ytmp = [ones(size(xtmp)) xtmp]*m(:,1);

% weighted mean of x data
xmu = sum(w.*x)/sum(w);

% standard error
se = sqrt(sum((y - [ones(size(x)) x]*m(:,1)).^2)/(nu)) * ...
    sqrt(1/Nd + (xtmp - xmu).^2/sum((x - xmu).^2));

% confidence intervals
yci = repmat(ytmp,1,2) + ...
    tinv((1 - alpha)/2,nu)*repmat([-1 1],length(xtmp),1).*repmat(se,1,2);

% plot confidence intervals
h(2) = fill([xtmp; flipud(xtmp)],[yci(:,1); flipud(yci(:,2))],[0.7 0.7 0.7], ...
    'EdgeColor','none');
% plot model
h(1) = plot(xl', [1 1; xl]'*m(:,1), 'k-');

%plot(xtmp,m(1,1)+m(1,2) + (m(2,1)+m(2,2))*xtmp);
%plot(xtmp,m(1,1)+m(1,2) + (m(2,1)-m(2,2))*xtmp);
%plot(xtmp,m(1,1)-m(1,2) + (m(2,1)+m(2,2))*xtmp);
%plot(xtmp,m(1,1)-m(1,2) + (m(2,1)-m(2,2))*xtmp);

return
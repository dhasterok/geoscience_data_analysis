function stats = kde(val,varargin)
% KDE - Kernel density estimation.
%
%   S = KDE(X,DX) computes a kernel smoothed estimate of the empirical
%   probability density (PDF) and cumulative distribution (CDF)
%   functions for a set of data, X, at intervals of DX.  
%
%   DX may contain three elements [XMIN XMAX STEP] for the minimum,
%   maximum, and interval size for the final model vector.
%
%   S = KDE(X,DX,ADAPT) allows for adaptive kernel estimation.  ADAPT =
%   1 turns on the adaptive algorithm and 0 turns it off.  Default is
%   on.
%
%   S = KDE(X,DX,ADAPT,KTYPE) additionally changes the kernel PDF
%   functions.  The default is 'gaussian', although currently no other
%   kernel estimation functions are presently included.

% Last Modified by D. Hasterok 4-August 2011

% Kernel width chosen by criterion of Silverman equation 3.31 At end
% points of interval data are reflected out to 4 sigma, so that df(x)/dx
% = 0. Option exists to iterate for an adaptive kernel estimate using
% algorithm of Silverman Chapter 5.
%
% Ref:

if nargin == 0 
    help kde;
elseif nargin > 4
    error('ERROR (kde): Too many input arguments.');
end

% setup iid vector of observations and, if necessary, vectors of weights
% and censors
% ------------------------------------------
[nr,nc] = size(val);
if nr < nc 
    val = val';
end
val = sortrows(val,1);

x = val(:,1);
Nx = length(x);

% censor data [1,0] = [un-,-]censored
switch min([nr,nc])
case 1
    w = ones([Nx,1]);
    c = ones([Nx,1]);
case 2
    w = val(:,1);
    c = ones([Nx,1]);
case 3
    w = val(:,1);
    c = val(:,2);
otherwise
    error('ERROR (kde): The minimum vector length must be <3.');
end
w = w/sum(w);   % data weights

% setup iid variable for model distribution
% ------------------------------------------
if nargin > 1
    val = varargin{1};
else
    val = [];
end

switch length(val)
case 0
    zmin = x(1);
    zmax = x(end);
    dz = [zmax - zmin]/100;
case 1
    dz = val;
    zmin = x(1);
    zmax = x(end);
case 2
    zmin = min(val);
    zmax = max(val);
    dz = [zmax - zmin]/100;
case 3
    zmin = val(1);
    zmax = val(2);
    dz = val(3);
end

z = [zmin:dz:zmax]';
if z(end) < zmax
    z = [z; z(end)+dz];
end

% kernel type
% ------------------------------------------
ktype = 'gaussian';
opt = {};
if nargin > 2
    temp = varargin{2};
end

if iscell(temp)
    if length(temp) > 0
        ktype = temp{1};
        if length(temp) > 1
            for i = 2:length(temp)
                opt{i-1} = temp{i};
            end
        else
            opt = {};
        end
    end
elseif ischar(temp)
    ktype = temp;
else
    error('ERROR (kde): Incorrect kernel argument.');
end

% restricted bounds
% ------------------------------------------
btype = 'none';
bnds = [-Inf, Inf];
if nargin > 3
    temp = varargin{3};
    if ischar(temp)
        btype = temp;
        switch temp
        case 'none'
            bnds = [-Inf, Inf];
        case '+'
            bnds = [0, Inf];
        case '-'
            bnds = [-Inf, 0];
        otherwise
            error('ERROR (kde): Unknown bounds argument.');
        end
    elseif iscell(temp)
        if ~ischar(temp{1})
            error('ERROR (kde): First bounds argument must be a string.');
        end
        btype = temp{1};
        if ~strcmp(btype,'limit')
            if length(temp) ~= 3
                error('ERROR (kde): Bounded limits not properly formatted.');
            end
        end
        bnds = [min(temp{2:3}), max(temp{2:3})];
    else
        error('ERROR (kde): Incorrect bounds argument.');
    end
end

if bnds(1) > x(1) | x(end) > bnds(2)
    error('ERROR (kde): Data out of restricted bounds');
end

% fix x based on bounds
switch btype
case 'none'
case '-'
    x = log(flipud(-x));
    z = log(flipud(-z));
    w = flipud(w);
    c = flipud(c);
case '+'
    x = log(x);
    z = log(z);
otherwise
    x = log(x - bnds(1)) - log(bnds(2) - x);
    z = log(z - bnds(1)) - log(bnds(2) - z);
end


% Estimate kernel density function
% ---------------------------------------------------
switch ktype
case 'gaussian'
    % default values for adaptive kernel width, 1 = true
    if isempty(opt)
        opt{1} = 1;
    end

    f = gauss_kde(x,z,opt);
case 'lognormal'
    if isempty(opt)
        opt{1} = 10;        % alpha
        opt{2} = 4.9039;    % beta
    end
    f = lognorm_kde(x,z,c,opt);
case 'invgauss'
    if isempty(opt)
        opt{1} = 10;        % alpha
        opt{2} = 4.9039;    % beta
    end
    f = invgauss_kde(x,z,c,opt);
otherwise
    error('ERROR (kde): Unknown kernel type.');
end

% reset bounds if necessary
switch btype
case 'none'
case '-'
    z = -flipud(exp(z));
case '+'
    z = exp(z);
    f = f(:)./z(:);
otherwise
    z = (bnds(1) + bnds(2)*exp(z)) ./ (exp(z) + 1);
    f = f(:).*(bnds(2) - bnds(1)) ./ ((z(:) - bnds(1)) .* (bnds(2) - z(:)));
end


% set statistics vector
% ---------------------------------------------------
% model PDF
stats.xPDF = z(:);
stats.yPDF = f(:);

% model CDF
stats.xCDF = z(:);
stats.yCDF = dz*cumsum(f(:));

% normalize PDF & CDF 
% i.e. integral of -xmin to xmax of PDF = 1 and CDF(xmax) = 1
stats.yPDF = stats.yPDF./stats.yCDF(end);
stats.yCDF = stats.yCDF./stats.yCDF(end);

% plots for debugging
%subplot(121);
%plot(stats.xPDF,stats.yPDF,'r-');
%subplot(122);
%plot(stats.xCDF,stats.yCDF,'b-');

return


% KERNEL_EST - Comutes the kernel estimator for the PDF with width h
function f = kernel_est(n,u,x,h,ktype);

switch ktype
case 'gaussian'
    K = gauss_kernel(u,x,h);
case 'invgauss'
    K = invgauss_kernel(u,x,h);
case 'epanechnikov'
    K = epanechnikov_kernel(u,x,h);
end

f = sum( K./n );

return


% -------------------------------------------------------------
% Gaussian DF estimates
% Follows the adaptive kernel procedure of Silverman [1985]
% -------------------------------------------------------------
function f = gauss_kde(x,z,opt);

Nx = length(x);
Nz = length(z);

% Calculate quartiles
qt = quartiles(x);
sigma = std(x);

Nx = length(x);

kw = 0.9*min([sigma, (qt(3) - qt(1))/1.34])*Nx^(-0.2);
%h = kw*ones([3*Nx 1]);
h = kw*ones(size(x));

% Reflect dataset at either end to accommodate end problems
%extx = [2*x(1) - x(end:-1:1);
%    x;
%    2*x(end) - x(end:-1:1)];
extx = x;

% adaptive kernel width using Silverman's algorithm
f = zeros(size(x));
if (opt{1} == 1)
    alpha = 0.5;  % sensitivity parameter 0 <= alpha <= 1

    % estimate kernels
    for i = 1:Nx
        f(i) = kernel_est(Nx,x(i),extx,h,'gaussian');
    end

    % geometric mean
    %g = exp(sum(log(f))/Nx);
    g = exp(sum(log(f))/Nx);

    % compute local bandwidth factor
    lambda = (g./f).^alpha;

    % compute adaptive kernel width estimate
    %h = [h(1:Nx).*lambda(Nx:-1:1); ...
    %    h(Nx+1:2*Nx).*lambda(1:Nx);
    %    h(2*Nx+1:3*Nx).*lambda(Nx:-1:1)];
    h = h.*lambda;
end
%plot(exp(x),h,'b-'); hold on;

% compute final kernel estimator
f = zeros(size(z));
for i = 1:Nz
    f(i) = kernel_est(Nz,z(i),extx,h,'gaussian');
end

return


% -------------------------------------------------------------
% Reciprocal inverse Gaussian
% From Scaillet [2003]
% -------------------------------------------------------------
%function f = rigauss_kde(x,z,opt);
%return


% -------------------------------------------------------------
% Log-normal DF estimates
% Follows the procedure of Kurwita et al. [2010]
% -------------------------------------------------------------
function f = lognorm_kde(x,z,c,opt);

if length(opt) ~= 2
    error('Error (kde): Incorrect number of kernel options.');
end
alpha = opt{1};
beta = opt{2};

Nx = length(x);
Nz = length(z);

s = KaplanMeier(c)';

lnx = repmat(log(x),1,Nz);
lnz = repmat(log(z)',Nx,1);

% Bayes bandwidth estimator
bstar = beta ./ (1 + 0.5*beta*(lnx - lnz).^2);

% bandwidth
h = (s * bstar.^alpha) ./ (s * bstar.^(alpha + 0.5));
h = h * gamma(alpha) / gamma(alpha + 0.5);
%plot(z,h,'r-'); hold on;

% log normal kernel
k = lognorm_kernel(z,x,h);

f = s * k;

return


% -------------------------------------------------------------
% Inverse gaussian DF estimates
% Follows the procedure of Kurwita et al. [2010]
% -------------------------------------------------------------
function f = invgauss_kde(x,z,c,opt);

Nx = length(x);
Nz = length(z);

if length(opt) ~= 2
    error('Error (kde): Incorrect number of kernel options.');
end
alpha = opt{1};
beta = opt{2};

Nz = length(z);
Nx = length(x);

s = KaplanMeier(c)';

xx = repmat(x,1,Nz);
zz = repmat(z',Nx,1);

% Bayes bandwidth estimator
astar = alpha + 0.5;
bstar = beta ./ ( 1 + 0.5*beta*(zz - xx).^2 ./ (zz.*xx.^2) );
h = (s * bstar.^(astar - 1)) ./ ((s * bstar.^astar)*(astar - 1));
%plot(z,h,'g-'); hold on;

% log normal kernel
k = invgauss_kernel(z,x,1e-5./h);

f = s * k;

return


% Kaplan Meier survival estimate
function s = KaplanMeier(c);

n = length(c);
i = [1:n-1]';
p = ((n - i)./(n - i + 1)).^c(i);

S = [cumprod(p); 0];

s = [1 - S(1);  S(1:n-1) - S(2:n)];

return


% Product Limit Esimate for the Suvival Function of the Censoring
% distribution (Blum Susarla). The role of the censoring variable is
% reversed.
function s = BlumSusarla(n,c);

i = [1:n-1]';
p = ((n - i)./(n - i + 1)).^(1 - c(i));

s(2:n) = cumprod(p);

return

% -------------------------------------------------------------
% Kernel functions
% -------------------------------------------------------------

% GAUSS_KERNEL - Computes kernel as Gaussian PDF
function K = gauss_kernel(u,x,h);

Nu = length(u);
Nx = length(x);

K = exp(-0.5*((u - x)./h).^2)./(sqrt(2*pi)*h);
%plot(exp(x),K,'b-'); hold on;

return % GAUSS_KERNEL

function K = epanechnikov_kernel(u,x,h);

K = 3/4*(1 - ((u-x)./h).^2);

return % EPANECHNIKOV_KERNEL


% IGAUSS_KERNEL - Computes kernel as inverse Gaussian PDF
function K = invgauss_kernel(u,x,h);

Nu = length(u);
Nx = length(x);

uu = repmat(u(:)',Nx,1);
xx = repmat(x(:),1,Nu);
hh = repmat(h(:)',Nx,1);
%hh = repmat(h,Nu,Nx);

K = zeros(size(uu));
ind = find(uu ~= 0 | xx ~= 0);
K(ind) = exp( - 0.5./(hh(ind).*xx(ind)) .* (uu(ind)./xx(ind) - 2 + xx(ind)./uu(ind)) ) ...
    ./ sqrt(2*pi*hh(ind).*uu(ind).^3);
ind = find(uu == 0 & xx == 0);
K(ind) = 0;

%K = sum(K,2);

return %IGAUSS_KERNEL


% RIGAUSS_KERNEL - Computes kernel as reciprocal inverse Gaussian PDF
function K = rigauss_kernel(u,x,h);

K = 1./sqrt(2*pi*h*u) .* ...
    exp( - 0.5*(u - h)/h .* (u./(x - h) - 2 + (x - h)./u) );

return % RIGAUSS_KERNEL


% LOGNORM_KERNEL - Computes kernel as log-normal PDF
function k = lognorm_kernel(u,x,h)

Nu = length(u);
Nx = length(x);

uu = repmat(u(:)',Nx,1);
xx = repmat(x(:),1,Nu);
hh = repmat(h(:)',Nx,1);

k = exp(-0.5*(log(uu./xx) ./ hh).^2) ./ (sqrt(2*pi)*uu.*hh);
%plot(xx,k); hold on;

return  % LOGNORM_KERNEL

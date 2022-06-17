function [model,varargout] = gausscensor(x,varargin)

x = x(~isnan(x(:)));

% separate censored values from uncensored values
N = length(x);
c = -x(x <= 0);
u = x(x > 0);

% assume bdl values for 0's
%   - either as the maximum bdl values
%   - or as an order of magnitude greater than the smallest uncensored
%   value
c(c == 0) = mode(c);
if sum(c == 0) > 0
    c(c == 0) = 10*min(u);
end

% sort censored and uncensored data
c = sort(c);
u = sort(u);

nc = length(c);
nu = length(u);

pflag = 0;
qflag = 0;
opt = 1;
a = 3/8;
Q = [0.025 0.25 0.5 0.75 0.975]';
if nargin > 1
    while opt < nargin
        switch lower(varargin{opt})
            case 'scale'
                % normal (0) or log-normal? (1)
                switch lower(varargin{opt+1})
                    case 'log'
                        u = log(u);
                        c = log(c);
                    case 'log10'
                        u = log10(u);
                        c = log10(c);
                    case 'linear'
                        % nothing to do
                    otherwise
                        error('Unknown scale');
                end
                opt = opt + 2;
            case 'plot'
                pflag = 1;
                opt = opt + 1;
            case 'a'
                a = varargin{opt+1};
                opt = opt + 1;
                if a < 0 | 1 < a
                    error('a must be 0 <= a <= 1');
                end
            case 'quantiles'
                Q = varargin{opt+1};
                qflag = 1;
                opt = opt + 2;
            otherwise
                error('Unknown Option');
        end
    end
end
Q = Q(:);

if length(u) < 8
    model.mu = NaN;
    model.sigma = NaN;
    model.sigma_mu = NaN;
    model.rms = NaN;
    
    if nargout == 2
        varargout{1} = nan([length(Q) 2]);
    end
    return
end
    

% indicies of uncensored data
j = 1;
k = 1;
ind = zeros(size(u));
if length(c) > 0
    while k <= nc & j <= nu
        if c(k) <= u(j)
            k = k + 1;
        else
            ind(j) = j + k - 1;
            j = j + 1;
        end
    end
    if j <= nu
        ind(j:nu) = [j:nu] + k - 1;
    end
else
    ind = [1:length(u)]';
end

% produce empirical cdf
% Michael, J.R., and Schucany, W.R. (1986),
% Analysis of Data From Censored Samples,
% in Goodness of Fit Techniques,
% ed. by D'Agostino, R.B., and Stephens,
% M.A., Marcel Dekker, New York.
y = (N - a + 1)/(N - 2*a + 1) * ...
    cumprod((ind - a)./(ind - a + 1),1,'reverse');

% remove repeated values of u to yield only a unique (u,y) -> (uu,yy)
% for CDF
[uu,iu] = unique(u);
diu = diff(iu);

ind = find(diu > 1);
iu(ind) = iu(ind+1)-1;
yy = y(iu);

% estimate scale parameters (mu,sigma) for the distribution
% Gillespie et al., 2010 (doi:10.1097/EDE.0b013e3181ce9f08)
dy = diff([0;yy]);
mu = sum(uu.*dy);
sigma = sqrt(N/(N - 1)*sum((uu - mu).^2.*dy));

% confidence interval on mu
i = [1:length(uu)-1]';
yy(2:end).*diff(uu);
sigma_mu = sum(cumsum(yy(2:end).*diff(uu))./((N - i).*(N - i + 1)));
%sigma_mu = NaN;

% RMS misfit to estimated CDF
rms = sqrt(sum((yy - 0.5*(1 + erf((uu - mu)/(sqrt(2)*sigma)))).^2)/N);


%[m,rms,ci95] = invnewton('gaussmodel',uu,yy,[mu; sigma]);

% compute quantiles
if nargout == 2
    varargout{1} = [mu + sigma*sqrt(2)*erfinv(2*Q - 1) ...
        interp1(yy,uu,Q)];
end

if pflag
    figure;
    %data histogram
    subplot(221); hold on;
    % uncensored data
    p = histogram(u,'DisplayStyle','stairs','LineWidth',1);
    % censored data
    histogram(c,'BinWidth',p.BinWidth,'DisplayStyle','stairs','LineWidth',1);
    
    xlabel('x');
    title('Histograms');
    set(gca,'Box','on');
    
    legend('uncensored','censored','Location','best');
    
    % CDF plot
    subplot(223); hold on;
    % excluding censored data
    h = cdfplot(u);
    set(h,'LineWidth',1.5);
    
    % including censored data
    U = [uu uu]';
    Y = [[0; yy(1:end-1)] [yy(1:end-1); yy(end)]]';
    plot(U(:),Y(:),'-','LineWidth',1.5);
        
    z = linspace(1e-6,1-1e-6,100);
    
    % normal distribution CDF
    plot(mu + sigma*sqrt(2)*erfinv(2*z - 1),z,'-','LineWidth',1.5);
    
    xlabel('x');
    ylabel('CDF(x)');
    set(gca,'Box','on');

    legend('excl. censored','incl. censored','normal CDF','Location','best');

    % Q-Q plot
    subplot(224); hold on;
    % normal distribution quantiles
    q = sqrt(2)*erfinv(2*yy - 1);
    plot(q,uu,'o');
    plot(sqrt(2)*erfinv(2*z - 1),mu + sigma*sqrt(2)*erfinv(2*z - 1),'-');
    set(gca,'Box','on');
    xlabel('Standard Normal');
    ylabel('Empirical Data');
    title('Q-Q Plot');
end

model.mu = mu;
model.sigma = sigma;
model.sigma_mu = sigma_mu;
model.rms = rms;

return
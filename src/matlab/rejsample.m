function r = rejsample(xo,Po,Nr,varargin)
% REJSAMPLE - Rejection sampling of arbitrary PDF
%
%   r = rejsample(xo,Po,Nr)

% Modified: 16 August 2011 - fixed bug where xo must have separations of
% 1 unit.  Added ability to handle variable steps in x.

% Modified: 10 October 2011 - added capability to compute x's from a
% histogram.

% xo            % observation parameter
% Po            % PDF of uncertainty
% Nr            % number of realizations

if length(xo) == length(Po)
    ptype = 'smooth';
elseif length(xo) == length(Po) + 1;
    ptype = 'hist';
end

if nargin == 0
    help rejsample;
    return
elseif nargin == 4
    ptype = varargin{1};
elseif nargin ~= 3
    error('Incorrect number of arguments.');
end

xo = xo(:);
Po = Po(:);


% Rejection sampling algorithm
switch ptype
case {'smooth'}
    r = smoothsample(xo,Po,Nr);
case {'hist'}
    r = histsample(xo,Po,Nr);
otherwise
    error('ERROR (rejsample): Unknown distribution type.');
end

return


function r = smoothsample(xo,Po,Nr);

% determine step size
dx = unique(xo(2:end) - xo(1:end-1));
if length(dx) ~= 1
    % multiple spacings in x, adjust spacings to minimum and interpolate
    % PDF to new x's
    dx = min(dx);
    xt = xo;
    Pt = Po;
    xo = [xo(1):dx:xo(end)];
    Po = interp1(xt,Pt,xo);
elseif ~isempty(find(dx == 0))
    % step size must be positive
    error('xo must be monotonic increasing');
end

m = xo(end) - xo(1);  % scaling factor
b = xo(1);            % minimum bound

M = max(Po);            % max of PDF, used as envelope function

%r = NaN*zeros([Nr 1]);
r = zeros([Nr 1]);
for i = 1:Nr
    while 1
        xr = m*rand(1) + b;
        if xr < b
            error('Random number failed (xr < min(xo))');
        elseif xr > m + b
            error('Random number failed (xr > max(xo) + min(xo))');
        end
        y = M*rand(1);
    
        % rescale index by step size in x
        ind1 = floor((xr - b)/dx) + 1;
        ind2 = ceil((xr - b)/dx) + 1;
        if ind1 ~= ind2
            f = (xr - xo(ind1)) / (xo(ind2) - xo(ind1)) ...
                * (Po(ind2) - Po(ind1)) ...
                + Po(ind1);
            if f > M
                error(['f > M, f = ',num2str(f),'M = ',num2str(M)]);
            end
        else
            f = Po(ind1);
        end
            
        if (y < f)
            r(i) = xr;
            break;
        end
    end
end

return


function r = histsample(xo,Po,Nr);

m = xo(end) - xo(1);  % scaling factor
b = xo(1);            % minimum bound

M = max(Po);            % max of PDF, used as envelope function
Nx = length(xo);

dx = unique(xo(2:end) - xo(1:end-1));
if length(dx) == 1
    flag = 1;
else
    flag = 0;
end

%r = NaN*zeros([Nr 1]);
r = zeros([Nr 1]);
for i = 1:Nr
    while 1
        xr = m*rand(1) + b;
        if xr < b
            error('Random number failed (xr < min(xo))');
        elseif xr > m + b
            error('Random number failed (xr > max(xo) + min(xo))');
        end
        y = M*rand(1);
    
        % rescale index by step size in x
        if flag
            ind = floor((xr - b)/dx) + 1;
            f = P(ind);
        else
            for j = 2:Nx
                if xr - xo(j) <= 0
                    f = Po(j-1);
                    break;
                end
            end
        end

        if f > M
            error(['f > M, f = ',num2str(f),'M = ',num2str(M)]);
        end
            
        if (y < f)
            r(i) = xr;
            break;
        end
    end
end

return

%N = 1e6;
%r = NaN*zeros([N 1]);
%for i = 1:N
%    while 1
%        x = rand(1);
%        y = 1.5*rand(1);
%    
%        f = 6*x*(1 - x);
%        if (y < f)
%            r(i) = x;
%            break;
%        end
%    end
%end
%
%edges = [0:0.01:1];
%Ne = length(edges);
%[n,bin] = histc(r,edges);
%
%x = midpt(edges);
%y = n(1:Ne-1)/sum(n)/(edges(2) - edges(1));
%
%f = 6*x.*(1 - x);
%plot(x,f,'k-',x,y,'r-');

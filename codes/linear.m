function [X,Y,m] = linear(x,y,varargin);
% [X,Y,m] = linear(x,y,varargin);

x = x(:);
y = y(:);

alpha = 0.05;
r = max(x) - min(x);
X = linspace(min(x)-0.05*r,max(x)+0.05*r,100);
if nargin > 2 & nargin < 5
    alpha = varargin{1}
    if nargin == 4
        X = varargin{2};
    end
elseif nargin ~= 2
    help linear;
end

X = X(:);
Y = zeros([length(X) 3]);

A = [ones([length(x) 1]) x];
B = [ones([length(X) 1]) X];

m = inv(A'*A)*A'*y;

res = sum((A*m - y).^2);

Y(:,1) = B*m;

mu = mean(x);
n = length(x);

t = tdist(n-2,alpha);

CI = t*sqrt(res/(n - 2)*(1/n + (X - mu).^2/sum((x - mu).^2)));

Y(:,2) = Y(:,1) - CI;
Y(:,3) = Y(:,1) + CI; 

return

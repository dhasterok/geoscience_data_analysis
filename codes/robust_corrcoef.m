function [rq,rs,rp,rk] = robust_corrcoef(X,Y);

X = X(:);
Y = Y(:);

N = length(X);

R(:,1) = rankvec(X);
R(:,2) = rankvec(Y);
R = sortrows(R);
x = R(:,1);
y = R(:,2);


xmed = median(x);
ymed = median(y);

rq= N^-1*sum(sign(x - xmed).*sign(y - ymed));
s = 0;
%for i = 1:N-1
%    s = s + ...
%        sum(sign(x(i:end-1) - x(i+1:end)).*sign(y(i:end-1) - y(i+1:end)));
%end
A = repmat(X,1,N);
B = A - A';
A = repmat(Y,1,N);
C = A - A';

cp = sum(triu((B < 1 & C < 1) | (B > 1 & C > 1) & ~(B == 0 & C == 0),1),'all');
dp = sum(triu((B < 1 & C > 1) | (B > 1 & C < 1) & ~(B == 0 & C == 0),1),'all');

rk = 2*(cp - dp)/(N*(N-1));
rs = 1 - 6*sum((x - y).^2)/(N*(N^2 - 1));
rp = corr(X,Y);

return

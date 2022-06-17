function t = tdist(n,alpha);
% TDIST - Student's t-test distribution
%
%     T = TDIST(N,ALPHA) computes the probability T, given N degrees of
%     freedom and confidence level (1 - alpha/2).

m = 0.5*(n + 1);
t = gamma(m).*(1 + alpha.^2./n).^-m ./ (sqrt(n*pi)*gamma(0.5*n));

return

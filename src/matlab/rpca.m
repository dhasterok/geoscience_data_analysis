function [T,P] = rPCA(X,A,p,q)
 
% Input:
%   p - oversampling parameter
%   q - number of iterations
%   A - expected rank of X
%
% Output:
%   T = Scores
%   P = Loadings
%
% Description:
% ------------
% The matrix B has dimension (A + p) x M, where M is number of columns in
% X. The bigger p and q are, the better approximation is but big Q makes
% calculations slower. Usually q = 1 gives a very good approximation and q
% = 0 with p = 20 gives fast computation with decent approximation quality
% Funtion written by Sergey Kucheyavskyi and modified by José Manuel Amigo

% Original: J.P. Cruz-Tirado, University of Campinas (2022)
% https://doi.org/10.1016/j.aca.2022.339793

% Randomization
nvar = size(X,2);
 
l = A + p;
 
% Randomization to avoid ill-conditioning
Y = X*(rand(nvar,l)*2 - 1);
[Q,~] = qr(Y,0);
 
for i = 1:q
    Y = X'*Q;
    [Q, ~] = qr(Y, 0);
    Y = X*Q;
    [Q, ~] = qr(Y,0);
end
 
B = Q'*X;
 
% Calibration
[~,~,P] = svds(B,A);
 
% Prediction
T = X*P;
end

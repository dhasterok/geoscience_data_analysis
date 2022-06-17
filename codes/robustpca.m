function robustpca(x)

z = ilr(x);

% log transformation
[mcd.sig,mcd.mu] = robustcov(z);


M = rand(size(x,2),200);

pfa('factors',5,'scores','Bartlett','rotation','varimax',M)



return
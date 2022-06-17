function m = ridgeregress(A,d,lambda,f,varargin)

if nargin == 5
    if strcmp(varargin{1},'log')
        A = log10(A);
    end
end

alpha = lambda.^2;

[nd, np] = size(A);
nr = length(alpha);

ifit = false(nd,1);
nuse = floor(f*nd);
ifit(randperm(nd,nuse)) = true;

Abar = mean(A,1);
Asd = std(A,[],1);

Ac = (A - repmat(Abar,nd,1))./repmat(Asd,nd,1);

Chisq = zeros(size(lambda));
m = zeros(np,nr);
for i = 1:length(alpha)
    m(:,i) = inv(Ac(ifit,:)'*Ac(ifit,:) + alpha(i)*eye(np))*Ac(ifit,:)'*d(ifit,:);
    
    Chisq(i) = sum((d(~ifit) - Ac(~ifit,:)*m(:,i)).^2/(1 - nuse));
end



return
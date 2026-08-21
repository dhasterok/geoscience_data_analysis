function [U2_obs,out] = watsons_U2(data,varargin)

if nargin == 2
    alpha = varargin{1};
end

% Compute U^2 statistic from the observed data
U2_obs = U2_statistic(data);

% produce a random set of U^2 values for random datasets
U2 = U2_distribution(data);

% compute the CDF
[CDF_U2,edges] = histcounts(U2,50,'Normalization','cdf');
x = midpt(edges);

%figure;
%plot(x,CDF_U2,'o-');

if nargin == 2
    [~,ind] = unique(CDF_U2);
    U2_alpha = interp1(CDF_U2(ind),x(ind),1-alpha,'spline');
    out = U2_alpha;
else
    p = 1 - interp1(x,CDF_U2,U2_obs,'spline');
    out = p;
end

return

function U2_obs = U2_statistic(data)

% sort all the angles in a common set
data = sortrows(data,2);

group = unique(data.group);

% indices of group A and B
indA = strcmp(data.group,group{1});
indB = strcmp(data.group,group{2});

% use these vectors later to determine U^2 distribution for N1 and N2
% degrees of freedom
A = data.direction(indA);
B = data.direction(indB);

% number of samples in groups A an B
Ni = sum(indA);
Nj = sum(indB);

% create i, j indices
data.i = cumsum(indA);
data.j = cumsum(indB);

% find and remove duplicate angles
c = 1;
while c < height(data)
    if data.direction(c) == data.direction(c+1)
        % if the duplicates come from different groups, combine the group
        % name
        if indA(c) == indB(c+1) | strcmp(data.group(c),[group{1},'/',group{2}]);
            data.group{c+1} = [group{1},'/',group{2}];
        end
        % delete current row, i.e., keep last duplicate since it will have
        % the correct i and j values for the entry.
        data(c,:) = [];
    else
        c = c + 1;
    end
end
% compute frequencies of A and B
data.fi = data.i/Ni;
data.fj = data.j/Nj;

% U^2 statistic
U2_obs = Ni*Nj/(Ni+Nj)^2*(sum((data.fi - data.fj).^2) - (sum(data.fi - data.fj))^2/(Ni+Nj));

return


function U2 = U2_distribution(data)

group = unique(data.group);

% indices of group A and B
indA = strcmp(data.group,group{1});
indB = strcmp(data.group,group{2});

N1 = sum(indA);
N2 = sum(indB);

% number of realizations
N = 10^3;
U2 = zeros(N,1);

for i = 1:N
    data.direction = data.direction(randperm(N1+N2));
    U2(i) = U2_statistic(data);
end

return
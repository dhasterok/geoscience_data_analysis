function T = rankvec(x);
% RANKVEC - Ranks orders a vector
%
%   r = rankvec(x) rank orders the vector x.  When x's are tied, the rank
%   is determined by the average of the ranks for the tied values.

N = length(x);
% we can quickly find the rank order of most x's using the index value from
% sort
[X,r] = sort(x);
i = 1;
j = 2;
R = zeros(size(r));

while 1;
    s = i;
    % search for duplicates among the x values
    while j <= N
        if x(r(j)) == x(r(i))
            s = s + j;
            j = j + 1;
        else
            break;
        end
    end

    if i == j-1 % rank of unique value
        R(i) = i;
    else % average duplicate ranks
        R(i:j-1) = s/(j - i);
    end
    i = j;
    j = i + 1;
    
    if i > N
        break;
    end
end

% place in correct order
T = zeros(size(R));
for i = 1:length(R);
    T(r) = R;
end

return

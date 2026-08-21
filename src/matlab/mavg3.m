function xs = mavg3(x,w)
% mavg3 - produces a moving average
%
%   xs = mavg3(x,w) produces a moving average of x using a window size of
%   w.  Window size should be odd, if not, it adds one.

% make sure window size is odd
if mod(w,2) == 0
    warning('Oops... should have made window odd, adding one.');
    w = w + 1;
end

xs = nan(size(x));
for i = 1:length(x)
    if i <= (w-1)/2
        xs(i) = nan;
    elseif i > length(x) - (w-1)/2
        xs(i) = nan;
    else
        %[i-(w-1)/2 i+(w-1)/2]
        xs(i) = sum(x(i-(w-1)/2:i+(w-1)/2))/w;
    end
end

return
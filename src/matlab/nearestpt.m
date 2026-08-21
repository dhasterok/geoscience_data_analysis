function yp = nearestpt(x,y,xp)

for i = 1:length(xp)
    [~,ind] = min(abs(x - xp(i)));
    yp(i) = y(ind);
end

return
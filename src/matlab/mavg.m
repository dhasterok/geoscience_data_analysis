function y = mavg(x,w)

istart = 1;
iend = w;
c = (w/2)+1;
while iend <= length(x)-(w/2)
   y(c) = mean(x(istart:iend));
   istart = istart + 1;
   iend = iend + 1;
   c = c + 1;
end

y(y==0) = NaN;

end
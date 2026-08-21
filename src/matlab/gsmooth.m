function Z = gsmooth(z)

s = 1/273*[1 4 7 4 1;
    4 16 26 16 4;
    7 26 41 26 7;
    4 16 26 16 4;
    1 4 7 4 1];

[nr,nc] = size(z);

Z = z;

for i = 3:nr-2
    for j = 3:nc-2
        Z(i,j) = sum(sum(s.*z(i-2:i+2,j-2:j+2)));
    end
end

return
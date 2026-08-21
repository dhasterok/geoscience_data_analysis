function varargout = ternhex(a,b,c,val,n,varargin)

hexbin = hexagon(n);

[x,y] = tern2xy(a,b,c);

for i = 1:length(hexbin)
    in = inpolygon(x,y,hexbin(i).xv,hexbin(i).yv);
    hexbin(i).n = sum(in);
    hexbin(i).mean = mean(val(in));
    hexbin(i).median = median(val(in));
    hexbin(i).std = std(val(in));
end

figure;
subplot(131);
ternary('Labels',{'K_2O','Na_2O','CaO'});
hold on;
for i = 1:length(hexbin)
    patch(hexbin(i).xv,hexbin(i).yv,hexbin(i).n,'EdgeColor','none');
end
colorbar;

subplot(132);
ternary('Labels',{'K_2O','Na_2O','CaO'});
hold on;
for i = 1:length(hexbin)
    patch(hexbin(i).xv,hexbin(i).yv,hexbin(i).median,'EdgeColor','none');
end
colorbar;

subplot(133);
ternary('Labels',{'K_2O','Na_2O','CaO'});
hold on;
for i = 1:length(hexbin)
    patch(hexbin(i).xv,hexbin(i).yv,hexbin(i).std,'EdgeColor','none');
end
colorbar;

return
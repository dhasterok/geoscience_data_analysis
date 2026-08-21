function dendrite(data,N)

Y = pdist(data{1:20000,8:end});
Z = linkage(Y,'average');

figure;
[H,T] = dendrogram(Z);
cat = str2num(get(gca,"XTickLabel"));

u = unique(data.rock_type);

edges = min(T)-0.5:max(T)+0.5;
%figure
for i = 1:length(u)
    ind = strcmp(data.rock_type,u(i));
    if all(~ind(1:N))
        n(i,:) = nan(1,width(edges)-1);
        continue;
    end
    
    n(i,:) = histcounts(T(ind(1:N)),'BinEdges',edges);
end
n = n(:,cat);

figure;
imagesc(n./repmat(sum(n,2),1,width(n)));
set(gca,'XTick',min(T):max(T),'XTickLabel',cat);
set(gca,'YTick',[1:length(u)],'YTickLabel',u);

figure;
scatter(data.sio2(1:N),data.na2o(1:N)+data.k2o(1:N),[],T,'filled');
colormap2('plasma','N',max(T));
cb = colorbar;
cb.Ticks = [1:max(T)];

return
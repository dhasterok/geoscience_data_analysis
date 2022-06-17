function [z, coeff, score, latent, tsquared, explained, mu, scale] = db_pca(data,varargin)

el = {'sio2','tio2','al2o3','feo_tot','mgo','cao','na2o','k2o','p2o5'};
ilr_flag = 0;
clr_flag = 0;
field = 'rock_type';

opt = 1;
while opt < nargin
    switch lower(varargin{opt})
        case 'fields'
            el = varargin{opt+1};
            opt = opt + 2;
        case 'none'
            % do nothing
            disp('nothing to do.');
            opt = opt + 1;
        case 'ilr'
            ilr_flag = 1;
            opt = opt + 1;
        case 'clr'
            clr_flag = 1;
            opt = opt + 1;
        case 'class'
            field = varargin{opt+1};
            opt = opt + 2;
        otherwise
            error('Unknown option for db_pca.');
    end
end


for i = 1:length(el)
    if i == 1
        ind = data{:,el{i}} > 0;
    else
        ind = ind & data{:,el{i}} > 0;
    end
end
data = data(ind,:);

class = data(:,field);

x = data{:,el};

% close the compositions in an Aitchison-space (normalize the desired
% fields to 1);
x = closure(x);

if ilr_flag
    [z,U] = ilr(x);
    scale = U;
elseif clr_flag
    z = clr(x);
    scale = [];
else
    z = x;
    scale = [];
end
coeff = zeros([size(z,2) size(z,2)]);
score = zeros(size(z));
latent = zeros([1 size(z,2)]);
tsquared = zeros([size(z,1) 1]);
explained = zeros([1 size(z,2)]);
mu = zeros([1 size(z,2)]);

[coeff, score, latent, tsquared, explained, mu] = pca(z);

if ilr_flag
    for i = 1:length(el)-1
        vl{i} = num2str(i);
    end
else
    vl = el;
end

figure;
% normalized eigenvalues
subplot(121);
hold on;
scatter([1:length(explained)],cumsum(explained),'s','filled');
scatter([1:length(explained)],explained,'o','filled');
legend('Cumulative','Individual');
xlabel('Principal Component');
ylabel('Explained Variance (%)');
axis square;
set(gca,'Box','on');

% eigenvectors
subplot(122);
imagesc(coeff);
axis ij;
set(gca,'XAxisLocation','top');
xlabel('Principal Vector');
set(gca,'YTick',[1:size(x,2)],'YTickLabels',vl);
colormap(rwb);
caxis([-1 1]);
colorbar;
axis square;

%figure;
%histogram(tsquared);
%xlabel('Hotelling''s t^2 statistic');
%xlim([0 round(quantile(tsquared,0.975)/10)*10]);

% make a plot of the average score of plutonic rock types
rt = unique(data.rock_type);

figure;
for i = 1:length(rt)
    %subplot(131);
    hold on;
    pcahist(score(:,1:2),coeff(:,1:2),strcmp(data.rock_type,rt{i}),vl,'PC 1','PC 2',rt{i});
    if i == 1
        plot([zeros([1 length(explained)]); coeff(:,1)'],[zeros([1 length(explained)]); coeff(:,2)'],'k-');
        for j = 1:length(explained)
            if length(explained) == length(el)
                text(coeff(j,1),coeff(j,2),el{j});
            else
                text(coeff(j,1),coeff(j,2),num2str(j));
            end
        end
    end
    %subplot(132);
    %hold on;
    %pcahist(score(:,[2 3]),coeff(:,[2 3]),strcmp(data.rock_type,rt{i}),vl,'PC 2','PC 3',rt{i});

    %subplot(133);
    %hold on;
    %pcahist(score(:,[1 3]),coeff(:,[1 3]),strcmp(data.rock_type,rt{i}),vl,'PC 1','PC 3',rt{i});
end

%figure;
%for i = 1:length(vl)
%    subplot(3,3,i)
%    histogram(z(:,i));
%    xlabel(vl{i});
%end

return


function pcahist(score,coeff,iind,vl,xlbl,ylbl,txt);

cl = [0.01 0.1:0.2:0.9];
%if sum(iind) > 0
%    [f,xi] = ksdensity(score(iind,1:2));
%    contour(xi(:,1),xi(:,2),log10(f),cl,'b','ShowText','on');
%    whos
%end
edges = [-7:0.5:7];
%nig = gsmooth(hist2d(score(iind,1),score(iind,2),edges,edges));%/sum(iind));
scatter(mean(score(iind,1)),mean(score(iind,2)),'s','filled');
text(mean(score(iind,1))+0.01,mean(score(iind,2)),txt)

%if sum(iind) > 0
%    [cl,v] = clevels(nig);
%    [~,hi] = contour(midpt(edges),midpt(edges),nig, ...
%        cl,'b','ShowText','on');
%    hi.LabelSpacing = 200;
%    hi.TextList = 1-v;
%end

%scatter(score(iind,1),score(iind,2),16,'filled');
%scatter(score(sind,1),score(sind,2),16,'filled');
%biplot(coeff(:,1:2),'Varlabels',vl);

axis square;
set(gca,'Box','on');
xlabel(xlbl);
ylabel(ylbl);

return


function [cl,v] = clevels(n)

v = [0.01 0.05 0.1 0.25 0.5 0.75 0.95];

n = sort(n(:));
cdf = cumsum(n/sum(n));

%figure; 
%plot(n,cdf)
%hold on;

for i = 1:length(v)
    cl(i) = max(n(cdf <= v(i)));
    %plot(cl(i),v(i),'o');
end
%error('just checking');

return
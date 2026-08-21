function [results, score, z, tsquared, mu, scale] = pca_gdb(data,varargin)
% pca_gdb - Principal component analysis applied to geochemical data.
%
%   pca_gdb(data) produces several plots associated with a PCA analysis
%   using a table of geochemical data.  The plots include a plot of the
%   eigenvalues (explained variance), both individual and cumulative, a
%   plot of the eigenvector (principal component) matrix, and a plot of PC1
%   and PC2 scores.
%
%   pca_gdb(data) returns the data used to produce the PCA.  If the
%   data are transformed (see below), z will be the transformed data.
%
%   [results, score, z, tsquared, mu, scale] = pca_gdb(data) returns the
%   results of the pca analysis
%
%   Options:
%       'PlotType'              Produce pca plots, default = 'none'.
%
%       'Fields'                Fields used to produce PCA.  The default
%                               fields include major oxides {'sio2','tio2',
%                               'al2o3','feo_tot','mgo','cao','na2o','k2o',
%                               'p2o5'}.  Provide a list as a cell array.
%
%       'CenteringMethod'       Center and normalize the data so that all
%                               data are similar in magnitude and
%                               unbounded.  Options include 'none'
%                               (default), centered-log ratio ('clr'), and
%                               isometric log ratio ('ilr').
%
%       'ClassName'             Field used for defining a class names for
%                               defining colors plotting.
%
%       'ClassTypes'            If the field 'ClassName' is filled with a
%                               cell array of char/string, then ClassTypes 
%                               can be a cell array of selected classes for
%                               coloring points.  Use {'all'} for all
%                               possible types.
%
%       'AverageScore'          If 'ClassTypes' is defined, it is possible
%                               to display the average score rather than
%                               the set.
%
% see pca ilr clr

% default fields for PCA
pcafields = {'sio2','tio2','al2o3','feo_tot','mgo','cao','na2o','k2o','p2o5'};

p = inputParser;

addRequired(p,'Data',@istable);
addParameter(p,'Fields',pcafields,@iscellstr);
addParameter(p,'CenteringMethod','none',@ischar);
addParameter(p,'ClassName','',@ischar);
addParameter(p,'ClassTypes',{'all'},@iscellstr);
addParameter(p,'PlotType','scatter',@ischar);

parse(p,data,varargin{:})

pcafields = p.Results.Fields;
center = p.Results.CenteringMethod;
classname = p.Results.ClassName;
plottype = p.Results.PlotType;

% if classname is defined, then select classtypes for grouping samples
if ~isempty(classname) & iscellstr(p.Results.ClassTypes)
    if length(p.Results.ClassTypes) == 1 & strcmp(p.Results.ClassTypes,'all')
        classtypes = unique(data.(classname));
    else
        classtypes = p.Results.ClassTypes;
    end
end

% select pcafields for PCA analysis
for i = 1:length(pcafields)
    if i == 1
        ind = data{:,pcafields{i}} > 0;
    else
        ind = ind & data{:,pcafields{i}} > 0;
    end
end
data = data(ind,:);

% make a plot of the average score of plutonic rock types
x = data{:,pcafields};

% close the compositions in an Aitchison-space (normalize the desired
% fields to 1);
x = closure(x);

% perform any necessary centering
switch center
    case 'none'
        z = x;
        scale = [];
        vl = pcafields;
    case 'clr'
        z = clr(x);
        scale = [];
        vl = pcafields;
    case 'ilr'
        [z,U] = ilr(x);
        scale = U;
        for i = 1:length(pcafields)-1
            vl{i} = num2str(i);
        end
end

% principal component analysis
[coeff, score, latent, tsquared, explained, mu] = pca(z);

results.coeff = coeff;
results.latent = latent;
results.explained = explained;
results.pcafields = pcafields(:);

if strcmp(plottype,'none')
    return
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

figure;
hold on;
if isempty(classtypes)
elseif isnumeric(data.(classname))
    scatter(score(:,1),score(:,2),8,data.(classname),'filled','MarkerFaceAlpha',0.3);
    set(gca,'Box','on');
    cb = colorbar;
    cb.Label.String = classname;
else
    x = nan([height(classtypes) 1]);
    y = nan([height(classtypes) 1]);
    for i = 1:length(classtypes)
        %subplot(131);
        [x(i),y(i)] = pcahist(score(:,1:2),coeff(:,1:2),strcmp(data.(classname),classtypes{i}), ...
            vl,'PC 1','PC 2',classtypes{i},plottype);
        
        %subplot(132);
        %hold on;
        %pcahist(score(:,[2 3]),coeff(:,[2 3]),strcmp(data.rock_type,rt{i}),vl,'PC 2','PC 3',rt{i});
    
        %subplot(133);
        %hold on;
        %pcahist(score(:,[1 3]),coeff(:,[1 3]),strcmp(data.rock_type,rt{i}),vl,'PC 1','PC 3',rt{i});
    end
    dx = diff(get(gca,'XLim'));
    text(x+0.02*dx,y,classtypes);
end

% plot data axes
scale = min(max(get(gca,'XLim'))/max(coeff(:,1)), max(get(gca,'YLim'))/max(coeff(:,2)));
plot([zeros([1 height(results.coeff)]); scale*results.coeff(:,1)'], ...
    [zeros([1 height(results.coeff)]); scale*results.coeff(:,2)'],'-','Color',[0.5 0.5 0.5]);

dx = 0.05*scale*cos(atan2(coeff(:,2),coeff(:,1)));
dy = 0.05*scale*sin(atan2(coeff(:,2),coeff(:,1)));

if length(results.pcafields) == height(results.coeff)
    text(scale*results.coeff(:,1)+dx,scale*results.coeff(:,2)+dy,results.pcafields, ...
        'HorizontalAlignment','center','VerticalAlignment','middle','Color',[0.5 0.5 0.5]);
else
    text(scale*results.coeff(:,1)+dx,scale*results.coeff(:,2)+dy,num2str([1:height(coeff)]'), ...
        'HorizontalAlignment','center','VerticalAlignment','middle','Color',[0.5 0.5 0.5]);
end

return


function [x,y] = pcahist(score,coeff,iind,vl,xlbl,ylbl,txt,plottype)

cl = [0.01 0.1:0.2:0.9];
%if sum(iind) > 0
%    [f,xi] = ksdensity(score(iind,1:2));
%    contour(xi(:,1),xi(:,2),log10(f),cl,'b','ShowText','on');
%    whos
%end
edges = [-7:0.5:7];

x = mean(score(iind,1));
y = mean(score(iind,2));
switch plottype
%     case 'contour'
%         if sum(iind) == 0
%             return
%         end
% 
%         nig = gsmooth(hist2d(score(iind,1),score(iind,2),edges,edges));%/sum(iind));
%         
%         [cl,v] = clevels(nig);
%         [~,hi] = contour(midpt(edges),midpt(edges),nig, ...
%             cl,'b','ShowText','on');
%         hi.LabelSpacing = 200;
%         hi.TextList = 1-v;
    case 'average'
        scatter(x,y,'s','filled');
    case 'scatter'
        scatter(score(iind,1),score(iind,2),'filled','MarkerFaceAlpha',0.3); 
end



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
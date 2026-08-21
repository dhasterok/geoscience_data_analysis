function varargout = elvelplot(data,plotstyle,el1,el2,varargin)
% Plots elements/ratios vs. elements/ratios
%
%   p = elvelplot(data,plotstyle,el1,el2,varargin)
%   Uses scatter, but does not accept properties.  To change plot
%   characteristics:
%       p.SizeData - size
%       p.CData - color
%       p.Marker - symbol
%       p.MarkerEdgeColor = 'none', p.MarkerFaceColor = 'flat' to fill
%
%   plotstyle options
%
%   Options:
%       'XScale', 'YScale'      'linear' or 'log'; 'log' converts values to
%                               log10, default is 'linear'
%
%       'BinField'              field used to bin data for plotting
%                               averages; if binfield can be a ratio not
%                               included in the data table
%
%       'BinEdges'              edges of bins
%
%       'Color'                 normalized color triplet or colormap

p = inputParser;

addParameter(p,'XScale','linear',@ischar);
addParameter(p,'YScale','linear',@ischar);
addParameter(p,'BinField','',@ischar);
addParameter(p,'BinEdges',[],@isnumeric);
addParameter(p,'Color',lines(1),@isnumeric);

parse(p,varargin{:});

xscale = p.Results.XScale;
yscale = p.Results.YScale;
binfield = p.Results.BinField;
edges = p.Results.BinEdges;
colour = p.Results.Color;

if isempty(colour) & ~isempty(edges)
    colour = midpt(edges);
end

% create axis labels before fixing field names
xlbl = getlabel(el1);
ylbl = getlabel(el2);

% fix field names so that they match those in data
el1 = fixfieldnames(data.Properties.VariableNames,el1);
el2 = fixfieldnames(data.Properties.VariableNames,el2);

% make the plot
switch lower(plotstyle)
    case {'scatter','hist2d'}
        p = elvelplot_all(data,el1,el2,xscale,yscale,plotstyle);
    case {'average','whisker'}
        if isempty(binfield) && isempty(edges)
            [p,xq,yq,n] = elvelplot_avg(data,el1,el2,xscale,yscale,plotstyle,colour);
        else
            if strcmp(binfield,'')
                binfield = el1;
            end
            [p,xq,yq,n] = elvelplot_avg(data,el1,el2,xscale,yscale,plotstyle,colour,binfield,edges);
        end
        if nargout > 1
            varargout{2} = xq;
            varargout{3} = yq;
            varargout{4} = n;
        end
    otherwise
        error(['Unknown option (',plotstyle,').']);
end
if nargout > 0
    varargout{1} = p;
end

set(gca,'Box','on');

% axis labels
if strcmp(xscale,'log')
    xl = get(gca,'XLim');
    hpax([floor(xl(1)) ceil(xl(2))],'x');
end
xlabel(xlbl);

if strcmp(yscale,'log')
    yl = get(gca,'YLim');
    hpax([floor(yl(1)) ceil(yl(2))],'y');
end
ylabel(ylbl);

return


% -------------------------------------------
% plotting individual data points
% -------------------------------------------
function p = elvelplot_all(data,el1,el2,xscale,yscale,plotstyle)

x = prepdata_all(data,el1,xscale);
y = prepdata_all(data,el2,yscale);

ind = ~isnan(x) & ~isnan(y);
x = x(ind);
y = y(ind);

switch plotstyle
    case 'scatter'
        p = scatter(x,y,'filled');
        p.MarkerFaceAlpha = 0.5;
    case 'hist2d'
        ex = binedges(x);
        ey = binedges(y);
        
        [n,out,cx,cy] = hist2d(x,y,ex,ey);
        imagesc(cx,cy,n);
        axis xy;
        
        p.ex = ex;
        p.ey = ey;
        p.n = n;
end

return
% removes censored data and takes log if necessary


function edges = binedges(v)

vq = quantile(v,[0.025 0.25 0.5 0.75 0.975]);

vmin = floor(vq(1));
vmax = ceil(vq(5));

dv = 2*(vq(4) - vq(2))*numel(v)^(-1/3);
nv = ceil((vmax - vmin)/dv);

edges = linspace(vmin,vmax,nv);

return


% -------------------------------------------
% plotting average data points
% -------------------------------------------
function [p,xq,yq,n] = elvelplot_avg(data,el1,el2,xscale,yscale,plotstyle,colour,varargin)

gca; hold on;
if nargin == 7
    xq = prepdata_avg(data,el1,xscale);
    yq = prepdata_avg(data,el2,yscale);
    
    if isempty(colour)
        colour = [0 0.4470 0.7410];
    end
    p = avgplot(xq,yq,plotstyle,colour);
    n = NaN;
    return
end

binfield = varargin{1};
edges = varargin{2};

if ~strcmpi(data.Properties.VariableNames,'binfield')
    if strcmpi(binfield,'x')
        data{:,binfield} = prepdata_all(data,el1,xscale);
    elseif strcmpi(binfield,'y')
        data{:,binfield} = prepdata_all(data,el2,yscale);
    end
end


if isempty(edges) & iscell(data{:,binfield})
    val = unique(data{:,binfield});
    for i = 1:length(val)
        ind = strcmp(data{:,binfield},val{i});
        n(i) = sum(ind);
        if n(i) < 10
            continue;
        end
        
        xtmp = prepdata_avg(data(ind,:),el1,xscale);
        xq(:,i) = xtmp(:,2);
        ytmp = prepdata_avg(data(ind,:),el2,yscale);
        yq(:,i) = ytmp(:,2);
    end
    if isempty(colour)
        colour = [1:length(val)];
    end
else
    for i = 1:length(edges)-1
        ind = edges(i) <= data{:,binfield} & data{:,binfield} < edges(i+1);
        n(i) = sum(ind);
        if n(i) < 10
            %continue;
            xq(:,i) = nan(5,1);
            yq(:,i) = nan(5,1);
        else
            xtmp = prepdata_avg(data(ind,:),el1,xscale);
            xq(:,i) = xtmp(:,2);
            ytmp = prepdata_avg(data(ind,:),el2,yscale);
            yq(:,i) = ytmp(:,2);
        end
        
    end
    if isempty(colour)
        colour = midpt(edges);
    end
end

p = avgplot(xq,yq,plotstyle,colour);
if size(colour,1) > 1 & size(colour,2) == 1
    colorbar;
    caxis([min(colour) max(colour)]);
elseif size(colour,1) > 1
     colorbar;
end

return


function p = avgplot(xq,yq,plotstyle,colour)
    
switch plotstyle
    case 'average'
        plot([xq(2,:); xq(4,:)], [yq(3,:); yq(3,:)],'Color',[0.7 0.7 0.7]);
        hold on;
        plot([xq(3,:); xq(3,:)], [yq(2,:); yq(4,:)],'Color',[0.7 0.7 0.7]);
        
        p = scatter(xq(3,:),yq(3,:),[],colour,'filled');
        if size(colour,1) > 1
            colorbar
        end
    case 'whisker'
        % 2.5 to 97.5% bars
        p = plot([xq(1,:); xq(5,:)], [yq(3,:); yq(3,:)],'-', ...
            [xq(3,:); xq(3,:)], [yq(1,:); yq(5,:)],'-');
        hold on;
        set(p,'Color',[0.7 0.7 0.7]);

        % 25 to 75% box
        f = fill([xq(2,:); xq(4,:); xq(4,:); xq(2,:); xq(2,:)], ...
            [yq(2,:); yq(2,:); yq(4,:); yq(4,:); yq(2,:)],[0 0.4470 0.7410],'EdgeColor','none');

        % 50% point
        p = scatter(xq(3,:),yq(3,:),'o','filled');
        set(p,'CData',[1 1 1]);
end

return
function p = roseplot(theta,rho,varargin);
% ROSEPLOT - Produces a rose plot.
%
%    ROSEPLOT will produce compass convention polar plots, histograms.
%    There are a number of options depending on the type of plot.
%
%
%
%    ROSEPLOT(BIN,EDGES) produces a rose plot with edges
%    defined by EDGES created by ROSEHIST.
%
% See also: ROSEHIST

% Last Modified: 3-Feb. 2006 by D. Hasterok (Univ. Utah)

theta = theta*pi/180;

opt = 1;
normtype = 'bincount';
plottype = 'plot';
color = [0 0.4470 0.7410];
linspec = '';
convention = 360;
while nargin >= opt + 2
    if nargin > 2
        switch varargin{opt}
            case 'PlotType'
                plottype = varargin{opt+1};
                opt = opt + 2;
            case 'Normalization'
                normtype = varargin{opt+1};
                opt = opt + 2;
            case 'Color'
                color = varargin{opt+1};
                opt = opt + 2;
            case 'AngleConvention'
                convention = varargin{opt+1};
                opt = opt + 2;
            otherwise
                linespec = varargin{opt};
                opt = opt + 1;
        end
    end
end

% add axes if plot is empty
if isempty(get(gca,'Children'))
    roseaxes(convention);
end

switch plottype
    case 'histogram'
        p = rosehistogram(theta,rho,normtype,color);
    case 'scatter'
        [x,y] = pol2cart(theta,rho);
        p = scatter(x,y,30,color,'filled');
    case 'plot'
        [x,y] = pol2cart(theta,rho);
        p = plot(x,y,'Color',color);
    otherwise
        error('Unknown PlotType.');
end

return

function p = rosehistogram(edges,bin,normtype,color)

n = length(bin);

dt = 2*pi/n;
switch normtype
    case 'bincount'
        % do nothing
    case 'countdensity'
        bin = bin/dt;
    case 'pdf'
        bin = bin/(n*dt);
    case 'probability'
        bin = bin/n;
end

% Set axes
maxbin = max(bin);

% Plot histogram wedges
for i = 1:n
     xv = [0 bin(i)*cos(edges(i)) bin(i)*cos(edges(i+1)) 0]/maxbin;
     yv = [0 bin(i)*sin(edges(i)) bin(i)*sin(edges(i+1)) 0]/maxbin;
     p = patch(yv,xv,color);
     set(p,'EdgeColor',[0 0 0],'LineWidth',0.25);
end

return

function [x,y] = pol2cart(theta,rho)

rho = rho/max(rho);

x = rho.*cos(pi/2 - theta);
y = rho.*sin(pi/2 - theta);

return
function c = plotcoast(varargin);
% PLOTCOAST - Plots coastline.
%
%    C = PLOTCOAST plots global coastlines and returns graphics
%    handles to coastline plot.
%
% 11 May 2011 By D. Hasterok (SIO)

lstyle = 'k-';
if nargin == 1
    lstyle = varargin{1};
    if ~ischar(lstyle)
        error('ERROR (plotcoast): Line style argument must follow PLOT options.');
    end
end

hold on;

load('coast.mat');
c = plot(clon,clat,lstyle);

xlabel('Longitude');
ylabel('Latitude');

set(gca,'Box','on');
axis equal;
axis([-180 180 -90 90]);

return

function p = plotpb
% PLOTPB - Plots plate boundaries.
%
%    C = PLOTPB plots plate boundaries and returns graphics
%    handles to boundary plot.
%
% 11 May 2011 By D. Hasterok (SIO)

hold on;

s = load('trench.xy');
r = load('ridge.xy');
t = load('transform.xy');

p(1) = plot(s(:,1),s(:,2),'-','Color',[0    0.4470    0.7410]);
p(2) = plot(r(:,1),r(:,2),'-','Color',[0.8500    0.3250    0.0980]);
p(3) = plot(t(:,1),t(:,2),'-','Color',[0.9290    0.6940    0.1250]);

xlabel('Longitude');
ylabel('Latitude');

set(gca,'Box','on');
axis equal;
axis([-180 180 -90 90]);

return

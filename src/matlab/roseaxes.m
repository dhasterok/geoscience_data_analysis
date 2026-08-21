function roseaxes(varargin)

convention = 360;
if nargin == 1
    convention = varargin{1};
end

theta = [0:pi/200:2*pi]';
circ = [cos(theta) sin(theta)];

hold on;
% turn off Matlab axis plots
p = get(gca);
p.Color = 'none';
p.XAxis.Visible = 'off';
p.YAxis.Visible = 'off';

% plot outer circle and inner fill
fill(circ(:,1),circ(:,2),[1 1 1],'EdgeColor',[0.15 0.15 0.15]);

% plot 
plot(0.667*circ(:,1),0.667*circ(:,2), ...
     'Color',[0.5 0.5 0.5],'LineWidth',0.25);
plot(0.333*circ(:,1),0.333*circ(:,2), ...
     'Color',[0.5 0.5 0.5],'LineWidth',0.25);

if convention == 360
    axtxt = [0:30:330];
elseif convention == 180
    axtxt = [-150:30:180];
end

for i = 1:length(axtxt)
    % plot radial axes
    plot([0 sin(axtxt(i)*pi/180)],[0 cos(axtxt(i)*pi/180)], ...
          'Color',[0.5 0.5 0.5],'LineWidth',0.25);
    text(1.15*sin(axtxt(i)*pi/180),1.15*cos(axtxt(i)*pi/180),num2str(axtxt(i)), ...
        'VerticalAlignment','middle', ...
        'HorizontalAlignment','center', ...
        'Color',[0.15 0.15 0.15]);
end
axis([-1.3 1.3 -1.3 1.3]);
axis square;

hold on;
set(gca,'Color','none');

return
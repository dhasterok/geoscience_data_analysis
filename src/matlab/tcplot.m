function tcplot(an,T,k)
% TCPLOT - plots thermal conductivity data
%
%   tcplot(an,T,k) where an is the molar fraction anorthite, T is
%   temperature in K and k is thermal conductivity in W m^-1 K^-1.

subplot(121); hold on;
ind = T == 298;
scatter(an(ind),k(ind),24,an(ind),'filled');
colormap(winter);
cb = colorbar;
cb.Label.String = 'An';
cb.TickDirection = 'out';
xlabel('% Anorthite');
ylabel('Thermal Conductivity [W/m/K]');
axis square;
ylim([1 3]);
xlim([0 1]);
set(gca,'Box','on');

subplot(122); hold on;
scatter(T,k,24,an,'filled');
cb = colorbar;
cb.Label.String = 'An';
cb.TickDirection = 'out';
%plot(Tm,km(:,i),lin{i});
xlabel('Temperature [K]');
ylabel('Thermal conductivity [W/m/K]');
ylim([1 3]);
xlim([250 700]);
axis square;
set(gca,'Box','on');

return
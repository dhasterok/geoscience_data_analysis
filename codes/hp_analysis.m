close all;
clear all;

data = readtable('australian_hp.csv','Format','%s%f%f%f');

ind = -45 < data.latitude & data.latitude < -10 & 110 < data.longitude & data.longitude < 155 & strcmp(data.rock_type,'granite');
data = data(ind,:);

[r,gamma] = variogram(data.longitude,data.latitude,log10(data.heat_production),1);

figure;
subplot(211);
plot(r,gamma,'o');
xlabel('Distance');
ylabel('log_{10} \gamma');
pbaspect([1.618 1 1]);

subplot(212);
plot(r,10.^gamma,'o');
hold on;
xlabel('Distance');
ylabel('\gamma');
pbaspect([1.618 1 1]);

[nugget,sill,range,rms] = variogram_model(1.1,1.25,200,'circular',r,10.^gamma);
[h,gc] = variogram_model(nugget,sill,range,'circular',r);
plot(h,gc,'-');

[nugget,sill,range,rms] = variogram_model(1.1,1.25,200,'gaussian',r,10.^gamma);
[h,gg] = variogram_model(nugget,sill,range,'gaussian',r);
plot(h,gg,'-');

[nugget,sill,range,rms] = variogram_model(1.1,1.25,200,'exponential',r,10.^gamma);
[h,ge] = variogram_model(nugget,sill,range,'exponential',r);
plot(h,ge,'-');

[nugget,sill,range,rms] = variogram_model(1.1,1.25,200,'quadratic',r,10.^gamma);
[h,gq] = variogram_model(nugget,sill,range,'quadratic',r);
plot(h,gq,'-');

[nugget,sill,range,rms] = variogram_model(1.1,1.25,200,'wave',r,10.^gamma);
[h,gq] = variogram_model(nugget,sill,range,'wave',r);
plot(h,gq,'-');


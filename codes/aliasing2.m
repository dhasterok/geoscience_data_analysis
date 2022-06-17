close all;
clear all;
% aliasing2.m  3/3/06 L Braile
% Illustrate aliasing and folding about the nyquist frequency, 
% fnyq = 1/(2*dt) where dt is the sample interval.
% Changes to explore the effects of aliasing:
%   1. Change frequency of original cosine wave in line 12,
%      vary f from 1 to 11.
%   2. Change cos to sin in lines 13 and 16, repeat step 1.
% calculate cosine wave at very small sample interval
% to represent continuous (analog) data.

dt = 0.001;     % sampling interval - 1 ms
t = [0:dt:3];   % time 0 to 3 sec.


dts = 0.1;      % sampling interval - 100 ms
ts = [0:dts:3]; % Nyquist for resampled data is 5 Hz.

f = [1:2:11];   % frequencies of input wave from 1 to 11 Hz

phi = pi/4;

figure;
for n = 1:length(f)

    % input wave
    x = sin( 2*pi*f(n)*t + phi );

    % sampled wave
    % using a significantly larger sampling interval than input wave is
    % defined.
    xs = sin( 2*pi*f(n)*ts + phi );

    xi = interp1(ts,xs,t,'spline');

    subplot(3,2,n); hold on;
    p = plot(t,x,'b-');
    ps = plot(ts,xs,'ro-');
    pr = plot(t,xi,'g-');

    set(p,'linewidth',2);
    set(ps,'markersize',8,'linewidth',2);
    set(pr,'markersize',8,'linewidth',2);

    ylabel([num2str(f(n)),' Hz'],'fontsize',16);
    if n > 4
        xlabel('Time (s)','fontsize',16);
    end
    axis([0 2 -1.1 1.1]);
    set(gca,'Box','on','fontsize',16,'linewidth',2);

    if n ~= length(f)
        pause;
    end
end

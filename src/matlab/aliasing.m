% Demonstration of aliasing (SAGE 2000 -- L. Braile)
close all;
clear all;


% 100 samples per second, Nyquist = 50 Hz
dt = 0.01;
t = [0:dt:1.0];

% signal 1
f1 = 12;  % 12 Hz sinusoid
s1 = sin( 2*pi*f1*t );

% signal 2
f2 = 30;  % 30 Hz sinusoid
s2 = sin( 2*pi*f2*t );

% combine signal 1 and 2
s3 = s1 + s2;


% calculate Fourier transform
n = 2*length(s3);
S = fft(s3,n);

% amplitude spectrum
Sxx = S.*conj(S)/n;

% frequencies contained in Fourier transform
f = (0:1/((n-1)*dt):1/(2*dt));


%plot sinusoids
figure;
subplot(321);
p = plot(t,s1,'r-');
set(p, 'LineWidth',2);
title('12 Hz sinusoids and sum, sampled at 0.01 s','Fontsize',16);
ylim([-2 2]);
set(gca,'Box','on','XTickLabel',{},'fontsize',16,'linewidth',2)

subplot(323);
p = plot(t,s2,'r-');
set(p, 'LineWidth',2);
title('30 Hz sinusoids and sum, sampled at 0.01 s','Fontsize',16);
ylabel('Amplitude','fontsize',16)
ylim([-2 2]);
set(gca,'Box','on','XTickLabel',{},'fontsize',16,'linewidth',2)

subplot(325);
p = plot(t,s3,'r-');
set(p, 'LineWidth',2);
title('12 Hz and 30 Hz sinusoids and sum, sampled at 0.01 s','Fontsize',16);
xlabel('Time (s)','fontsize',16)
ylim([-2 2]);
set(gca,'Box','on','fontsize',16,'linewidth',2)


% Amplitude spectrum
subplot(222);
p = plot(f,Sxx(1:n/2));
set(p,'LineWidth',2);
title('FFT of sum of 12 and 30 Hz sinusoids sampled at 0.01 s','Fontsize',16)
xlabel('Frequency (Hz)','fontsize',16)
ylabel('Amplitude','fontsize',16)
set(gca,'fontsize',16,'linewidth',2)

subplot(224);
p = plot(f,log10(Sxx(1:n/2)));
set(p,'LineWidth',2);
xlabel('Frequency (Hz)','fontsize',16);
ylabel('Log Amplitude','fontsize',16);
ylim([-4 2]);
set(gca,'fontsize',16,'linewidth',2);

pause;



% 50 samples per second, Nyquist = 25 Hz
dt = 0.02;
t = [0:dt:1.0];

% signal 1
f1 = 12;  % 12 Hz sinusoid
s1 = sin( 2*pi*f1*t );

% signal 2
f2 = 30;  % 30 Hz sinusoid
s2 = sin( 2*pi*f2*t );

% combine signal 1 and 2
s3 = s1 + s2;


% calculate Fourier transform
n = 2*length(s3);
S = fft(s3,n);

% amplitude spectrum
Sxx = S.*conj(S)/n; % calculate periodogram

% frequencies contained in Fourier transform
f = (0:1/((n-1)*dt):1/(2*dt));


%plot sinusoids
figure;
subplot(321);
p = plot(t,s1,'r-');
set(p, 'LineWidth',2);
title('12 Hz sinusoids and sum, sampled at 0.02 s','Fontsize',16);
ylim([-2 2]);
set(gca,'Box','on','XTickLabel',{},'fontsize',16,'linewidth',2)

subplot(323);
p = plot(t,s2,'r-');
set(p, 'LineWidth',2);
title('30 Hz sinusoids and sum, sampled at 0.02 s','Fontsize',16);
ylabel('Amplitude','fontsize',16)
ylim([-2 2]);
set(gca,'Box','on','XTickLabel',{},'fontsize',16,'linewidth',2)

subplot(325);
p = plot(t,s3,'r-');
set(p, 'LineWidth',2);
title('12 Hz and 30 Hz sinusoids and sum, sampled at 0.02 s','Fontsize',16);
xlabel('Time (s)','fontsize',16)
ylim([-2 2]);
set(gca,'Box','on','fontsize',16,'linewidth',2)


% Amplitude Spectrum
subplot(222);
p = plot(f,Sxx(1:n/2));
set(p,'LineWidth',2);
title('FFT of sum of 12 and 30 Hz sinusoids sampled at 0.02 s','Fontsize',16)
xlabel('Frequency (Hz)','fontsize',16)
ylabel('Amplitude','fontsize',16)
xlim([0 25]);
set(gca,'fontsize',16,'linewidth',2)

subplot(224);
p = plot(f,log10(Sxx(1:n/2)));
set(p,'LineWidth',2);
xlabel('Frequency (Hz)','fontsize',16);
ylabel('Log Amplitude','fontsize',16);
ylim([-4 2]);
xlim([0 25]);
set(gca,'fontsize',16,'linewidth',2);

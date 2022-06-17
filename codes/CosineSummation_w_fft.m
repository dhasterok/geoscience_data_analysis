close all;
clear all;

% Calculate summation of cosines to illustrate synthesis of wavelet
% (signal) and analysis of signal (frequency content).

% Original: L. Braile (Purdue Univ.) 03/25/06
% Revised: D. Hasterok (Univ. Adelaide) 6 May 2019

% create a set of 32 cosine waves (X) with frequencies (f) from 1 to 32 Hz
nt = 2^8;
t = linspace(-0.5,0.5,nt);
dt = t(2) - t(1);
for i = 1:32
    f = i; % frequency
    X(i,:) = cos(2*pi*f*t); % compute time series
end

figure;
hold on;
for i = 1:32
    % plot each cosine wave one above the other (blue)
    plot(t,X(i,:)+2*i+4,'b-');
    if i == 1
        x = X(1,:);
    else
        x = sum(X(1:i,:))'; % compute time series
    end
    
    if i == 1
        % plot the sum of the visible cosine waves
        p = plot(t,x,'r-','linewidth',2);

        axis([-0.5 0.5 -10 70]);
        set(gca,'fontsize',14,'linewidth',2)
        xlabel('Time (s)','fontsize',14)
        ylabel('1 Hz to 32 Hz Cosines','fontsize',14)
        title('Summation of Cosines to Generate Wavelet','fontsize',14)
        text(-0.42,-3,'Wavelet (summation; bold line) scaled by 0.25','fontsize',14)
        set(gca,'Box','on');
        drawnow
        
        % update the sum with each additional cosine
        linkdata on

        p.XDataSource = 't';
        p.YDataSource = 'x';
    else
        refreshdata;
        drawnow;
    end    
    %pause;
end
linkdata off;

% fourier transform of cosine sum
X = fft(x,nt);


f = 1/dt*(0:(nt-1)/2)/nt;

Pxx = X.*conj(X)/nt; % Amplitude

figure;
subplot(211);
stem(f,Pxx(1:nt/2))
xlabel('Frequency (Hz)');
ylabel('Power');
title('FFT of Cosine sum');

Phi = atan(imag(X)./real(X));

subplot(212);
stem(f,Phi(1:nt/2)*180/pi)
xlabel('Frequency (Hz)');
ylabel('Phase');
title('FFT of Cosine sum');

pause;




% same as previous scheme, except there is a random phase added to each
% cosine wave
clear all;

phi = pi/2*randn([32,1]); % phase

nt = 2^8;
t = linspace(-0.5,0.5,nt);
dt = t(2) - t(1);
for i = 1:32
    f = i; % frequency
    X(i,:) = cos(2*pi*f*t - phi(i));  % compute time series, w/ phase shift
end

figure;
hold on;
for i = 1:32
    % plot each cosine wave one above the other (blue)
    plot(t,X(i,:)+2*i+4,'b-');
    if i == 1
        x = X(1,:);
    else
        x = sum(X(1:i,:))';
    end
    
    if i == 1
        % plot the sum of the visible cosine waves
        p = plot(t,x,'r-','linewidth',2);

        axis([-0.5 0.5 -10 70]);
        set(gca,'fontsize',14,'linewidth',2)
        xlabel('Time (s)','fontsize',14)
        ylabel('1 Hz to 32 Hz Cosines','fontsize',14)
        title('Summation of Cosines to Generate Wavelet','fontsize',14)
        text(-0.42,-3,'Wavelet (summation; bold line) scaled by 0.25','fontsize',14)
        set(gca,'Box','on');
        drawnow
        
        % update the sum with each additional cosine
        linkdata on

        p.XDataSource = 't';
        p.YDataSource = 'x';
    else
        refreshdata;
        drawnow;
    end    
end
linkdata off;

% fourier transform of phase shifted cosines sum
X = fft(x,nt);

f = 1/dt*(0:(nt-1)/2)/nt;

Pxx = X.*conj(X)/nt;

figure;
subplot(211);
stem(f,Pxx(1:nt/2))
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('FFT of Cosine sum');

Phi = atan(imag(X)./real(X));

subplot(212);
stem(f,Phi(1:nt/2)*180/pi)
xlabel('Frequency (Hz)');
ylabel('Phase');
title('FFT of Cosine sum');

pause;



% now lets add a random amplitude as well as a random phase added to each
% cosine wave
clear all;

A = 2*abs(randn([32,1])); % amplitude
phi = pi/2*randn([32,1]); % phase

nt = 2^8;
t = linspace(-0.5,0.5,nt);
dt = t(2) - t(1);
for i = 1:32
    f = i; % frequency
    X(i,:) = A(i)*cos(2*pi*f*t - phi(i));  % compute time series, w/ phase shift
end

figure;
hold on;
for i = 1:32
    % plot each cosine wave one above the other (blue)
    plot(t,X(i,:)+2*i+4,'b-');
    if i == 1
        x = X(1,:);
    else
        x = sum(X(1:i,:))';
    end
    
    if i == 1
        % plot the sum of the visible cosine waves
        p = plot(t,x,'r-','linewidth',2);

        axis([-0.5 0.5 -10 70]);
        set(gca,'fontsize',14,'linewidth',2)
        xlabel('Time (s)','fontsize',14)
        ylabel('1 Hz to 32 Hz Cosines','fontsize',14)
        title('Summation of Cosines to Generate Wavelet','fontsize',14)
        text(-0.42,-3,'Wavelet (summation; bold line) scaled by 0.25','fontsize',14)
        set(gca,'Box','on');
        drawnow
        
        % update the sum with each additional cosine
        linkdata on

        p.XDataSource = 't';
        p.YDataSource = 'x';
    else
        refreshdata;
        drawnow;
    end
end
linkdata off;

% fourier transform of phase shifted cosines sum
X = fft(x,nt);

f = 1/dt*(0:(nt-1)/2)/nt;

Pxx = X.*conj(X)/nt;

figure;
subplot(211);
stem(f,Pxx(1:nt/2))
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('FFT of Cosine sum');

Phi = atan(imag(X)./real(X));

subplot(212);
stem(f,Phi(1:nt/2)*180/pi)
xlabel('Frequency (Hz)');
ylabel('Phase');
title('FFT of Cosine sum');

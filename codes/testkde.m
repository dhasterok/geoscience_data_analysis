close all;
clear all;

%q = [22.8999 36.7673 48.0719 57.2124 62.0089 52.7217 49.8121 ...
%    62.2342 48.6655 55.1692 51.6421 102.7009 97.7499 67.4710 ...
%    81.6313 53.2811 68.0000 46.0000 93.0000 31.0000 65.1560 38.4523];

q = [13.4422 66.7867 71.2933 65.1138 230.6376 54.5544 57.9651 ...
    88.3711 76.2190 74.2160 76.2190 43.1246 73.2112 78.2233 ...
    124.3647 139.4114 64.1847 71.0020 84.9332 65.2123 11.7440 ...
    5.0142 73.4977 73.4977 49.2708 60.8740 42.0181 63.6141 ...
    61.7730 66.2222 24.1135 82.9802 63.6141 107.0536 76.1102 ...
    71.5181 42.0825 155.8104 60.3992 50.7345 38.1148 58.3914 ...
    75.7895 60.5020 72.4622 57.8900 75.5054 65.4846 26.8762 ...
    30.8231 32.3623 81.0534 139.2559 63.1160 82.2511];
dq = 0.1*q;
dq(dq < 2) = 2;

emp = edf(q,[0 max(q)]);

step = 2.5;
logn = kde(q,[2.5 max(q) step],{'lognormal',10,4.09});
gauss = kde(q,[2.5 max(q) step],'gaussian','+');
igauss = kde(q,[2.5 max(q) step],{'invgauss',6,4});


pdfplot(emp.xPDF,emp.yPDF,[0.3 0.3 0.3],1);
hold on;
plot(logn.xPDF,logn.yPDF,'r');
plot(gauss.xPDF,gauss.yPDF,'b');
plot(igauss.xPDF,igauss.yPDF,'g');
legend('Observed','Log-normal','Gaussian','Inverse Gaussian');

[f,xi] = ksdensity(q);
plot(xi,f,'c');
[f,xi] = ksdensity(q,'Weights',1./dq.^2);
plot(xi,f,'m');
%pdfplot(logn.xPDF,logn.yPDF,'r',0);
%pdfplot(gauss.xPDF,gauss.yPDF,'b',0);
%pdfplot(igauss.xPDF,igauss.yPDF,'g',0);

clc
close all
N = 6;
T = 5e-4; % period
f = -0.5/T:10:0.5/T; % frequency
for k = 0:N-1
    H = (sin(pi*N*(f*T-k/N)))./(sin(pi*(f*T-k/N))); %filter expression for standing clutters
    plot(f,abs(H),'linewidth',2);
    hold on;
end
title('Narrow band Doppler filter banks');
xlabel('f/Hz');
ylabel('|H(f)|');
clc
close all
alpha = 0.8;
T = 1e-4; % period
f = -1/T:10:1/T; % frequency
w = 2*pi*f; % angular frequency
z = exp(1j*w*T); % map to z domain
H = 1-alpha*z.^(-1); % filter expression for standing clutters
figure
sgtitle('Single Delay Line Canceller');
subplot(1,2,1)
plot(f,(abs(H)));
title('\alpha = 0.8')
xlabel('f/Hz')
ylabel('|H(f)|')
subplot(1,2,2)
alpha = 1;
H = 1-alpha*z.^(-1); % filter expression for moving clutters
plot(f,(abs(H)));
title('\alpha = 1')
xlabel('f/Hz')
ylabel('|H(f)|')


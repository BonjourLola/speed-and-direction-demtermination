clc
close all
alpha = 1.8;
T = 1e-4; % period
f = -1/T:10:1/T; % frequency
w = 2*pi*f; % angular speed
z = exp(1j*w*T); % map to z domain
H = 1-alpha*z.^(-1)+z.^(-2); 
figure
subplot(1,2,1)
plot(f,(abs(H)));
title('\alpha = 1.8')
xlabel('f/Hz')
ylabel('|H(f)|')
subplot(1,2,2)
alpha = 2;
H = 1-alpha*z.^(-1)+z.^(-2); 
plot(f,(abs(H)));
title('\alpha = 2')
xlabel('f/Hz')
ylabel('|H(f)|')
sgtitle('Double Delay Line Canceller')

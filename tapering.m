% Typical windows
clc; clear; close all
eps = 0.00001;
N = 32;
rect(1:32) = 1;
ham = hamming(32);
han = hanning(32);
blk = blackman(32);
k3 = kaiser(32,3);
k5 = kaiser(32);
b = bartlett(32);
RECT = 20*log10(abs(fftshift(fft(rect, 1024)))./32 +eps);
HAM =  20*log10(abs(fftshift(fft(ham, 1024)))./32 +eps);
HAN =  20*log10(abs(fftshift(fft(han, 1024)))./32+eps);
BLK = 20*log10(abs(fftshift(fft(blk, 1024)))./32+eps);
K5 = 20*log10(abs(fftshift(fft(k5, 1024)))./32+eps);
K3 = 20*log10(abs(fftshift(fft(k3, 1024)))./32+eps);
B = 20*log10(abs(fftshift(fft(b, 1024)))./32+eps);
x = linspace(-1,1,1024);
figure;

subplot(2,3,1)
plot(x,RECT);
title("Rectangular")
subplot(2,3,2)
plot(x,HAM);
title("Hamming")
subplot(2,3,3)
plot(x,HAN);
title("Hanning")
subplot(2,3,4)
plot(x,BLK);
title("Blackman")
subplot(2,3,5)
plot(x,B)
title("Bartlett")
subplot(2,3,6)
plot(x,K5);
title("Kasier at \beta = 0.5")
axis tight


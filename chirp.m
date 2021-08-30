% Chirp
T = 10e-6;        
B = 90e6;                         
K = B/T;                          
fs = 2*B;
Ts = 1/fs;                 
N = T/Ts;
t = linspace(-T/2,T/2,N);
S = exp(-1i*pi*K*t.^2);   % Chirp expression -1 down 1 up
figure;
sgtitle("B = 90 MHz, T = 10 microseconds")
subplot(311)
plot(t*1e6,real(S));
xlabel('Time in microsecond');
title('LFM waveform (real)');
subplot(312)
plot(t*1e6,imag(S));
xlabel('Time in microsecond');
title('LFM waveform (imaginary)')
subplot(313)
freq = linspace(-fs/2,fs/2,N);
plot(freq*1e-6,fftshift(abs(fft(S))));
xlabel('Frequency in MHz');
title('Spectrum for an LFM waveform');

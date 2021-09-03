% MTI and MTD
close all; clear; clc;
%% Initilization
c = 3.0e8;  % light speed
f0 = 2.6e9;  % RF
lambda = c/f0; % wavelength
B = 2.0e6;  % bandwidth 
T = 40.0e-6; % time duration
fr = 1/250e-6;   % PFR
fs = 2.0e6;  % sampling frequency
Pn = -6; % noise power in dB
Ps = 1; % signal power
L = fix(fs/fr); % number of samples in a pulse
M = 25;   % number of pulses
ML = L*M; % total samples；
range = 8000;
speed = 40;
n_delay = fix(fs*2*range/c); 
fd = 2*speed/lambda; % Doppler shift
n = fix(fs*T); % echo sample number = transient number - 1
%% Chirp Signal
for i = -fix(n/2):fix(n/2)-1
   Chirp(i+fix(n/2)+1) = exp(1i*(pi*(B/T)*(i/fs)^2));%exp(j*fi)*，产生复数矩阵Chirp
end
coeff = conj(fliplr(Chirp)); % pulse compression ratio
figure(1);
subplot(2,1,1);
plot(real(Chirp),'linewidth',1.5);
title("Chirp Signal Waveform (real part), BT = 80");
subplot(2,1,2);
plot(imag(Chirp),'linewidth',1.5);
title("Chirp Signal Waveform (imaginary part), BT = 80");
%% Target signal and Echo signal
S = zeros(1,ML);
S_temp = zeros(1,L); 
S_temp(n_delay+1:n_delay+n) = sqrt(Ps)*Chirp;   
s = zeros(1,ML);
for i = 1:M 
   s((i-1)*L+1:i*L) = S_temp;   
end
FD = exp(1i*2*pi*fd*(0:ML-1)/fs); 
s = s.*FD; % adding doppler shift
S = S+s; 
fi = pi/3;
S_temp = zeros(1,L); 
S_temp(n_delay+1:n_delay+n) = sqrt(Ps)*exp(1i*fi)*Chirp;   
s = zeros(1,ML);
for i = 1:M
    s((i-1)*L+1:i*L) = S_temp;
end
fd = exp(1i*2*pi*fd(1)*(0:ML-1)/fs); 
s = s.*fd;
S = S+s;
figure(2);
subplot(2,1,1);
plot(real(S));
title('target signal (real)');
xlabel("t (sample)");
ylabel("Power");
axis([0 12600 -1.5 1.5])
subplot(2,1,2);
plot(imag(S));
title('target signal (imaginary)');
xlabel("t (sample)");
ylabel("Power");
axis([0 12600 -1.5 1.5])
Noise = normrnd(0,10^(Pn/10),1,ML)+1i*normrnd(0,10^(Pn/10),1,ML);
echo = S+Noise; 
for i = 1:M  % Lock-up period = 0
      echo((i-1)*L+1:(i-1)*L+n) = 0; 
end
figure(3);
subplot(211);
plot(real(echo));
title('Echo signal (real)'); 
xlabel("t (sample)");
ylabel("Power");
axis([0 12600 -1.5 1.5])
subplot(212);
plot(imag(echo));
title('Echo signal(imaginary)');
xlabel("t (sample)");
ylabel("Power");
axis([0 12600 -1.5 1.5])

%% Matched filter
x1 = conv(echo,coeff); %pc_time0 = convolution of Echo and coeff
x2 = x1(n:ML+n-1); % remove the transient points
figure(4); 
subplot(211);
plot(abs(x1));
title('x(t) \otimes h(t) (with transient points)'); 
xlabel("t (sample)");
xlim([0 12600])
subplot(212);
plot(abs(x2));
xlim([0 12600])
title('x(t) \otimes h(t) (without transient points)'); %pc_time1 wave
xlabel("t (sample)");
Echo_fft = fft(echo,ML+n-1); % do FFT, 
coeff_fft = fft(coeff,ML+n-1);
y_fft = Echo_fft.*coeff_fft;
% pc_fft = fft(pc_time1,TotalNumber+number-1);
y1 = ifft(y_fft); % do ifft
figure(5)
subplot(211);
plot(abs(y1(1:ML+n-1)));
xlim([0 12600])
title('y(t) = IFFT[X(f) \cdot H(f)] (with transient points)');
xlabel("t (sample)");
y2 = y1(n:ML+n-1);
for i = 1:M
   pc(i,1:L) = y2((i-1)*L+1:i*L); % pulse compression results
end
subplot(212);
plot(abs(pc(1,:)));
title('y(t) = IFFT[X(f) \cdot H(f)] (without transient points)');
xlabel("t (sample)");
%% MTI and MTD result
figure(6);
subplot(2,1,1);
for i = 1:M-1  
   mti(i,:) = pc(i+1,:)-pc(i,:); % MTI results
end
s = mesh(abs(mti),'FaceAlpha','0.99');
s.FaceColor = 'flat';
grid on;
title('MTI result');
ylabel('Slow Time (pulse #)')
xlabel('Fast Time (range bin #)')
zlabel('MTI output')
ylim([0 25])
mtd = zeros(M,L);
for i = 1:L
   temp(1:M) = pc(1:M,i);
   temp_fft = fft(temp);
   mtd(1:M,i) = temp_fft(1:M); % MTD results
end
subplot(2,1,2);
s=mesh(abs(mtd),'FaceAlpha','0.9');
s.FaceColor = 'interp';
title('MTD result');
grid on;
ylabel('Slow Time (pulse #)')
xlabel('Fast Time (range bin #)')
zlabel('MTD output')
ylim([0 25])

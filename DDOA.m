clear; close all;
n_x = 16;
n_y = 16;
L = 286;
M = 286;
theta = linspace(-90,90,L).'*pi/180;
f = linspace(-0.5,0.5,M).';
% Transmitted Signal
N = 100;
X = (sign(randn(n_x,N)) + 1j*sign(randn(n_x,N)))/sqrt(2);

% Target
fd = 0.2; % Doppler shift, normalized
thetat = -50*pi/180;
d = exp(1j*2*pi*fd*(0:N-1)).';
a_x = exp(1j*pi*(0:n_x-1)*sin(thetat)).';
a_y = exp(1j*pi*(0:n_y-1)*sin(thetat)).';
Noise = a_y*a_x.'*X*diag(d);

% Noise
sigma = 1;
Noise = Noise + sqrt(sigma)*(randn(n_y,N) + 1j*randn(n_y,N));
y = Noise(:);

% Detection
P = zeros(L,M);
for i = 1:L
    a_x = exp(1j*pi*(0:n_x-1)*sin(theta(i))).';
    a_y = exp(1j*pi*(0:n_y-1)*sin(theta(i))).';
    A = a_y*a_x.';
    for k = 1:M
        dk = exp(1j*2*pi*f(k)*(0:N-1)).';
        vk = A*X*diag(dk);
        vk = vk(:);
        P(i,k) = abs(y'*vk + vk'*y) / (2*N*n_x*n_y);
    end
end
figure(1);
mesh(f,theta*180/pi,P)
xlabel('Frequency')
ylabel('DOA (degree)')
zlabel('Power')
figure(2);
velocity = linspace(-0.5*200,0.5*200,M).';
mesh(velocity,theta*180/pi,P)
xlabel('Radial Speed (m/s)')
ylabel('DOA (degree)')
zlabel('Power')
title("Joint estimation of DOA and radial speed")
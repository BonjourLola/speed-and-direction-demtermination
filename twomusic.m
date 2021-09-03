clear; close all;
rad = pi/180;
deg = 180/pi;
n_element = 8;   % X-axis and Y-axis number of elements
snr = 10; % Signal to noise ratio
n_target = 3; % number of targets
doa1 = [10 30 50]; 
doa2 = [10 30 50];
n = 100;
dd = 0.5;
dx = 0:dd:(n_element-1)*dd;
dy = dd:dd:(n_element-1)*dd;
ax = exp(-1i*2*pi*dx.'*(sin(doa1*rad).*cos(doa2*rad)));
ay = exp(-1i*2*pi*dy.'*(sin(doa1*rad).*sin(doa2*rad)));
A = [ax; ay];
S = randn(n_target, n);
X = A*S; % received signal
X1 = awgn(X, snr, 'measured'); % added with Gaussian noise signal
Rxx = X1*X1'/n; % Autocorrelation function
[EV, D] = eig(Rxx);
[EVA, I] = sort(diag(D).');
EV = fliplr(EV(:,I));
Un = EV(:, n_target+1:end); % noise subspace

% 2-D MUSIC
for ang1 = 1:90
    for ang2 = 1:90
        theta(ang1) = ang1 -1;
        phim1 = theta(ang1)*rad;
        f(ang2) = ang2 -1;
        phi = f(ang2)*rad;
        a1 = exp(-1i*2*pi*dx.'*(sin(phim1).*cos(phi)));
        a2 = exp(-1i*2*pi*dy.'*(sin(phim1).*sin(phi)));
        a = [a1; a2];
        P(ang1, ang2) = 1/(a'*Un*Un'*a);
    end
end
   
P=abs(P);
Pmax=max(max(P));
P = P/Pmax;
h = mesh(theta, f, P);
set(h, 'Linewidth',2);
colorbar;
xlabel('elevation(degree)');
ylabel('azimuth(degree)');
zlabel('magnitude(dB)');
title("2-D MUSIC spatial spectreum")

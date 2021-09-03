%% single pulse
close all; clear;
eps = 1e-6;
T = 0.1;
count = 0;
for t0 = -T:2*T/150:T
   count = count + 1;
   j = 0;
   fd = linspace(-5/T,5/T,151);
   temp1 = 1. - abs(t0) / T;
   temp2 = pi * T .* (1.0 - abs(t0) / T) .* fd;
   x(:,count) = abs(temp1 .* sin(temp2+eps)./(temp2+eps));
end
Tx = linspace(-T,T, size(x,1));
fy = linspace(-5/T+eps,5/T-eps, size(x,1));
mesh(Tx,fy,x);
xlabel ('Normalized Delay t/T')
ylabel ('Normalized Doppler frequency f_d/B')
zlabel('Ambiguity Function')
title("Single pulse, T = 0.1s")
colorbar
figure(2)
contour(Tx,fy,x);
xlabel ('Normalized Delay t/T')
ylabel ('Normalized Doppler frequency f_{d}/B')
title("Single pulse, T = 0.1s")
%% down-chirp
clear;
eps = 1e-6;
T = 0.5;
B = 10;
down = -1.;
mu = down * B / T;
del = 2*T/200;
count = 0;
for t0 = -1*T:del:T
   count = count + 1;
   j = 0;
   fd = linspace(-1.5*B,1.5*B,201);
   temp1 = 1. - abs(t0) / T;
   temp2 = pi * T * (1.0 - abs(t0) / T);
   temp3 = (fd + mu * t0);
   k = temp2 * temp3;
   x(:,count) = abs( temp1 .* (sin(k+eps)./(k+eps))).^2;
end
Tx = linspace(-1*T,T,size(x,1));
fy = linspace(-1.5*B,1.5*B,size(x,1));
figure(3)
mesh(Tx,fy,sqrt(x))
xlabel ('Normalized Delay t/T')
ylabel ('Normalized Doppler frequency f_d/B')
zlabel ('Ambiguity function')
title("Down-chirp TB = 5");
axis tight
colorbar
figure(4)
contour(Tx,fy,sqrt(x))
xlabel ('Normalized Delay t/T')
ylabel ('Normalized Doppler frequency f_d/B')
title("Down-chirp TB = 5");

theta = 45*pi/180; % angle
d = 10; % element spacing,m
N = 16; % the number of elements
lambda = 10; % signal wavelength,m
c = 3e8; % speed of light
f = c/lambda; % signal frequency
dR = d.*sin(theta); %  distance difference
dphi = 2*pi.*dR./lambda; % phase difference between adjacent element
% phi = 0; % phase shifter
phi = -1.84;   % optimal phase shifter

T = 3e-7; % time width
fs = 1e10; % sampling frequency
n = round(T.*fs); % sampling points
t = linspace(0,T,n); % time 
s = @(t,k) exp(1j*2*pi*f.*t).*exp(-1j.*k.*dphi).*exp(1j.*k.*phi); % signal of each element

figure(1)
subplot(311)
plot(t,real(s(t,0)))
xlabel("t/s")
title("The first element")
subplot(312)
plot(t,real(s(t,1)))
xlabel("t/s")
title("The second element")
subplot(313)
plot(t,real(s(t,2)))
xlabel("t/s")
title("The third element")

figure(2)
sum_s = zeros(1,length(t));
for k = 0:N-1
    sum_s = sum_s+s(t,k); % summation
end
plot(t,real(sum_s))
xlabel("t/s")
title("Summation")

% one wavelength
figure(3)
E = @(theta,phi) sin(N*(phi-(2*pi*d*sin(theta)/lambda))/2)./sin((phi-(2*pi*d*sin(theta)/lambda))/2);%方向增益
test_phi = linspace(-pi,pi,1000); 
subplot(211)
plot(test_phi,abs(E(0,test_phi)))
xlabel("\phi /rad")
ylabel("Intensity pattern")
title("Intensity pattern, N = 16, d = \lambda, \theta = 0")
subplot(212)
plot(test_phi,abs(E(pi/4,test_phi)))
xlabel("\phi /rad")
ylabel("Intensity pattern")
title("Intensity pattern, N = 16, d = \lambda, \theta = 45")
% half wavelength
d = 5; 
figure(4)
E = @(theta,phi) sin(N*(phi-(2*pi*d*sin(theta)/lambda))/2)./sin((phi-(2*pi*d*sin(theta)/lambda))/2);%方向增益
test_phi = linspace(-pi,pi,1000); 
subplot(211)
plot(test_phi,abs(E(0,test_phi)))
xlabel("\phi /rad")
ylabel("Gain")
title("Intensity pattern, N = 16, d = \lambda/2, \theta = 0")
subplot(212)
plot(test_phi,abs(E(pi/4,test_phi)))
xlabel("\phi /rad")
ylabel("Intensity pattern")
title("Intensity pattern, N = 16, d = \lambda/2, \theta = 45")


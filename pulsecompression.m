% Pulse compression
close all; clear;
N = 3; % number of targets
T = 10e-6; % pulse duration
B = 90e6; % bandwidth
n_window = 200; % window size
range = [30 70 100];
eps = 1.0e-16;
c = 3.e8;  % speed of light
n = fix(2 * T * B); % number of samples

x(N,1:n) = 0;
y(1:n) = 0;
S(1:n) = 0;
t = linspace(-T/2,T/2,n);
S = exp(1i * pi * (B/T) .* t.^2); % Chirp signal
 for j = 1:1:N
    new_range = range(j); 
    x(j,:) = 1 .* exp(1i * pi * (B/T) .* (t +(2*new_range/c)).^2) ;
    y = x(j,:)  + y;
end
figure(3) 
win(1:n) = 1;
y = y .* win;
plot(t,real(y))
xlabel ('Relative delay in seconds')
ylabel ('Uncompressed echo')
grid
out =xcorr(S, y);
out = out ./ n;
s = T * c /2;
Npoints = ceil(n_window * n /s);
dist =linspace(0, n_window, Npoints);
delr = c/2/B;
figure(4)
plot(dist,abs(out(n:n+Npoints-1)))
xlabel ('Target relative position in meters')
ylabel ('Compressed echo')
grid
% x=[1 1 1 1 1 -1 -1 1 1 -1 1 -1 1];%13Î»°Í¿ËÂë
% Barker codes
x = [+1 +1 +1 -1 +1];
y=[x 1];
t=[0:1:5];
figure(1);
subplot(2,1,1);
stairs(t,y);
axis([0 5 -1.5 1.5]);grid on;
[a,b]=xcorr(x);%Autocorrelation
title('Barker code with length 5');
subplot(2,1,2);
d=abs(a);
plot(b,d);
title('Autocorrelation function of Barker code with length 5');


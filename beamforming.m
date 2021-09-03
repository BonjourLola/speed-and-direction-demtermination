% Simulation of MUSIC, ESPRIT, MVDR and Classical DOA for a uniform linear array.
clc
clear;
close all;

doas = [10, 30]*pi/180;   %DOA's of signals in rad.
P = [1 1];   %Power of incoming signals
N = 10;    %Number of array elements
K = 1024;   %Number of data snapshots
d = 0.5;   %Distance between elements in wavelengths
sigma  =  10;   %Variance of noise
n = length(doas);   %Total number of signals

a  =  exp(-1i*2*pi*d*(0:N-1)'*sin([doas(:).'])); % Steering vector
s  =  round(rand(n,K))*2-1;    % Signal generation
noise  =  sqrt(sigma/2)*(randn(N,K)+1i*randn(N,K));  % Noise Generation
Ps  =  sum(abs(s).^2)/length(s);
Pn  =  sum(abs(noise).^2)/length(noise);
SNR = 10*log10(Ps/Pn);

X = a*diag(sqrt(P))*s+noise;   % data matrix
R = X*X'/K;  % covariance matrix
[Q ,D] = eig(R);   % Compute eigendecomposition of covariance matrix
[D,I] = sort(diag(D),1,'descend');   % Find r largest eigenvalues
Q = Q(:,I);   %S ort the eigenvectors to put signal eigenvectors first
Qs = Q(:,1:n);   % signal eigenvectors
Qn = Q(:,n+1:N);   % noise eigenvectors

% MUSIC algorithm
angles = (-90:0.1:90); 
a1 = exp(-1i*2*pi*d*(0:N-1)'*sin([angles(:).']*pi/180));
for i = 1:length(angles) 
    music_spectrum(i) = (a1(:,i)'*a1(:,i))/(a1(:,i)'*Qn*Qn'*a1(:,i));
end
figure(1)
subplot(4,1,3)
music_spectrum  = abs(music_spectrum);
plot(angles,music_spectrum/max(music_spectrum)); % plot MUSIC spectrum
title('MUSIC')
xlabel('Broadside angle')
ylabel('Normalized P')
[pks1,MUSIC_doas]  =  findpeaks(abs(music_spectrum),angles); % find peaks
MUSIC_doas  =  MUSIC_doas(find(MUSIC_doas>0));
sprintf("DOA estimate by MUSIC: %.3f, %.3f, %.3f", MUSIC_doas)

%
IR  =  inv(R); %Inverse of covariance matrix
for i = 1:length(angles)
    mvdr(i) = 1/(a1(:,i)'*IR*a1(:,i)); % angle search
end
subplot(4,1,2)
mvdr_spectrum  =  abs(mvdr);
plot(angles,mvdr_spectrum/max(mvdr_spectrum));
xlabel('Broadside angle')
ylabel('Normalized P')
title('MVDR')
[pks2,MVDR_doas]  =  findpeaks(abs(mvdr),angles);
MVDR_doas = MVDR_doas(find(MVDR_doas>0));
sprintf("DOA estimate by MVDR: %.3f, %.3f, %.3f", MVDR_doas)

%Estimate DOA's using the classical beamformer
for i = 1:length(angles)
    Classical(i) = (a1(:,i)'*R*a1(:,i)); % angle search
end
subplot(4,1,1)
Classical  =  abs(Classical);
plot(angles,Classical/max(Classical));
plot(angles,abs(Classical))
xlabel('Broadside angle')
ylabel('Normalized P')
title('Classical Beamformer')

%ESPRIT Algorithm
subplot(4,1,4);
phi =  linsolve(Qs(1:N-1,:),Qs(2:N,:));
ESPRIT_doas = asin(-angle(eig(phi))/(2*pi*d))*180/pi;
sprintf("DOA estimate by ESPRIT: %.3f, %.3f, %.3f", ESPRIT_doas)
xline(ESPRIT_doas,"Color",'#0072BD','linewidth',2);
title('ESPRIT')
xlim([-90 90])
xlabel('Broadside angle')
ylabel('Normalized P');

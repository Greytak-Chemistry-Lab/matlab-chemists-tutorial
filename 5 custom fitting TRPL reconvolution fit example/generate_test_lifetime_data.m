%% generate fake multiexponential decay with IRF and noise to test reconvolution fit
% Generates and saves fake data and IRF based on selected parameters

%% make fake lifetime data

% specify A's and tau's and background
max_signal=10000;
bkgd_level=200;
A=(max_signal-bkgd_level)*[0.65 0.35];
tau=[0.5 5.5];


time=linspace(0,20,2001)'; % range of times in ns, column vector
R=ones(size(time)); % initialize intensity: set to 1 everywhere so log doesn't break

figure(1);clf
% generate response

for(j=1:length(time))
    for(k=1:length(A))
        R(j)=R(j)+A(k)*exp(-(time(j))/tau(k));
    end
end

% plot response
figure(1);clf
plot(time,log10(R),'k')

%% Define irf

% gaussian
t0 = 2; % ns
sigma = 0.1; % sigma^2 is variance

% calculate normalized irf
irf_f=@(t) (sigma*sqrt(2*pi()))^-1 * exp(-(t-t0).^2/(2*sigma^2));
for(t=time(:))
    irf=irf_f(t); 
end

% scale to max signal value
irf=irf.*max_signal/max(irf);

% add noise and make integer valued
% irf=irf-0.5*sqrt(irf)+sqrt(irf).*rand(size(irf));
% irf=round(irf);
% irf=poissrnd(irf);

figure(2);clf
subplot(2,1,1)
plot(time,irf)
subplot(2,1,2)
plot(time,log10(irf));

%% convolve

signal= conv(R,irf./sum(irf)) ;

% scale to max_signal
signal=signal*max_signal/max(signal);

% add background
signal=bkgd_level + signal*(max_signal - bkgd_level)/max_signal;
% add noise
% signal=signal-0.5*sqrt(signal)+sqrt(signal).*rand(size(signal));
signal=poissrnd(signal); % if you have statistics toolbox
% round
signal=round(signal);


figure(3);clf
subplot(2,1,1)
plot(time,signal(1:length(time)))
subplot(2,1,2)
plot(time,log10(signal(1:length(time))))



%% make noisy version of irf to save

% add background
bkgd_level=10;
irf=bkgd_level + irf*(max_signal - bkgd_level)/max_signal;
% add noise
% signal=signal-0.5*sqrt(signal)+sqrt(signal).*rand(size(signal));
irf=poissrnd(irf); % if you have statistics toolbox
% round
irf=round(irf);
% re-plot irf
figure(2);clf
subplot(2,1,1)
plot(time,irf)
subplot(2,1,2)
plot(time,log10(irf));

%% save test data
signal=signal(1:length(time));
save fake_data.mat time irf signal 

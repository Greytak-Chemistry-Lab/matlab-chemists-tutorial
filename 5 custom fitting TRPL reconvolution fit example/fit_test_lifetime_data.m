%% load data
clear

load('fake_data.mat')

%% propose starting values
A1=max(signal)/2;
tau1=1; % ns
A2=max(signal)/2;
tau2=10; % ns
c=200;

% fit

fit_times = time >= 2;
X = [A1 tau1 A2 tau2 c];
badness = @(x) norm(  signal(fit_times) - mymodel(x,irf,time,fit_times) );

X_fit = fminsearch(badness,X);

figure(4);clf
subplot(3,1,1)
plot(time,signal,'k',time(fit_times)',mymodel(X_fit,irf,time,fit_times),'b', ...
    time,irf,'m')
subplot(3,1,2)
plot(time,log10(signal),'k',time(fit_times)',log10(mymodel(X_fit,irf,time,fit_times)),'b', ...
    time,log10(irf),'m')
subplot(3,1,3)
plot(time(fit_times)',signal(fit_times)-mymodel(X_fit,irf,time,fit_times),'b')

A1=X_fit(1) ;
tau1=X_fit(2) ;
A2=X_fit(3) ;
tau2=X_fit(4) ;
c=X_fit(5) ;

disp('A1/Atot')
disp(A1/(A1+A2))
disp('tau1')
disp(tau1)
disp('A2/Atot')
disp(A2/(A1+A2))
disp('tau2')
disp(tau2)
disp('background')
disp(c)

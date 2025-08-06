%% test arbitrary waveform fit with fake waves
clear

%% create fundamental waveforms
t=linspace(0,100,101)';
f1=double(size(t));
f2=double(size(t));
f3=double(size(t));
f1=exp(-t./10);
f2=-exp(-t./20);
f3=f1;
f3(2:end)=sin(t(2:end)/10)./(t(2:end)/10);
figure(1);clf
plot(t,[f1 f2 f3])
legend('f1','f2','f3')
%% create fake data
A=[f1 f2 f3];
x_fake=[2 -1 1]';
y_fake=A*x_fake;
fuzzy=0.1;
y_fake=y_fake - 0.5*fuzzy + fuzzy*rand(size(t));
figure(2);clf
plot(t,y_fake)
legend('fake data')

%% try fitting the data as linear combination of original or modified components
% for a simple linear combination fit, fitting with components that are
% linear combinations of the original components should always generate
% equally good fits. Here, making p non-zero will create new components
% that are linear combinations of the ones we originally defined.
p=0;
w1=f1;
w2=f2+p*f3;
w3=f3-p*f2;
A=[w1 w2 w3];

% fit fake data with matrix division
x_fit=A\y_fake;
fitstring=['x=[' num2str(x_fit(1),2) ' ' num2str(x_fit(2),2) ' ' num2str(x_fit(3),2) ']'];

% fit fake data with lsqnonneg: insists on positive coefficients
% x_fit=lsqnonneg(A,y_fake);
% fitstring=['x=[' num2str(x_fit(1),2) ' ' num2str(x_fit(2),2) ' ' num2str(x_fit(3),2) ']'];

disp(norm(y_fake-A*x_fit))

figure(2);clf
plot(t,y_fake,'b',t,A*x_fit,'k-')
legend('fake data',fitstring)

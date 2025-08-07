%% Linear combination of atomic orbitals description of H2 energy levels
% See Orbital Interactions in Chemistry (Albright, Burdette, and Whangbo
% 1985)

e0=0;
H11=e0; 
H22=e0;
H12=-1;       % transfer integral
S12=-0.1*H12; % overlap integral (scaled)
S12=0.2;      % overlap integral (try changing)

e1=(e0+H12)/(1+S12);
e2=(e0-H12)/(1-S12);

figure(1);
plot([-1 1],[H11 H22],'bs',[0 0],[e1 e2],'kd')

%% linear chain of s orbitals, with overlap and next-nearest neighbor
a=1;
kx=[-1:0.01:1].*pi()/a;
alpha=0;        % orbital energy
beta1=-1;       % transfer integral
S1=-0.2*beta1;  % nearest-neighbor overlap
beta2=-0.2;     % next-nearest neighbor transfer
S2=-(S1/beta1)*beta2; % next-nearest-neighbor overlap

Ek=(alpha + 2*beta1*cos(kx.*a) + 2*beta2*cos(kx.*(2*a)) ) ...
    ./(1 + 2*S1*cos(kx.*a) + 2*S2*cos(kx.*(2*a)) );

plot(kx,Ek)
set(gca,'XAxisLocation','origin')
set(gca,'YAxisLocation','origin')

%% linear chain of s orbitals, with basis (Jahn-Teller)
a=1;
b=1.0*a/2;

beta_nnn=-0.1;
beta1=-1.0;
beta2=-1.5;

Ek1=alpha + 2*beta_nnn*cos(kx.*a) + (beta1^2 + beta2^2 + 2*beta1*beta2*cos(kx.*a)).^(1/2);
Ek2=alpha + 2*beta_nnn*cos(kx.*a) - (beta1^2 + beta2^2 + 2*beta1*beta2*cos(kx.*a)).^(1/2);

plot(kx,Ek1,'b',kx,Ek2,'r')

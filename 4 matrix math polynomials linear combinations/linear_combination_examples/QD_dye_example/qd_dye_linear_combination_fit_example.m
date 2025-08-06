%% A demonstration of how to fit an absorption spectrum in terms of 2 components
% Data in this example is from Andrew's MIT samples 4-8, in which a
% carboxyrhodamine dye was combined with CdSe QDs.

% The peak molar extinction coefficient of this dye is 97000 M^-1 cm^-1
% Molar extinction coefficient of the QDs at 350 nm is 971000 M^-1 cm^-1

% We will determine the concentration of QDs and dye in a mixed sample
% using a linear combination fit, powered by lsqnonneg

% In particular, we want to find the (positive) coefficients to multiply
% the spectra for pure dye and QD by in order to match the measured
% absorption spectrum of a mixture. If we scale the spectra of each
% component to match their molar extinction coefficients, then the linear
% combination fit will directly give the concentration of each component
% that is present. 

% In this example, we have two spectra available to fit: a mixture of the
% QDs and dye, that should give a very close fit, and a covalent QD-dye
% conjugate, in which the dye component shows a measurable shift and will
% not fit as well.

% For this fit to work, we need the set of x values (wavelength points) to
% match among all of the spectra being compared. If they don't, you will
% need to resample them first (for example with interp1). The tools in the
% matlab-abs-emis toolbox make this easy, but this demo script does not
% use them.

%% load data: wavelength scale in nm (wl) and four sets of absorbance values
load qd_dye_example_data.mat

thesample=abg4_8c_mix_abs;
% thesample=abg4_8a_conjugate_abs;
comp1=abg4_8b_qd_abs;
comp1_name='QDs';
% comp2=rox_se_dye_abs;
comp2=rox_se_dye_abs-mean(rox_se_dye_abs(451:491)); % baseline correction
comp2_name='rox dye';

% find out which wavelength index corresponds to 350 nm, and the limits of
% the spectrum region in which we plan to do the fit
wl_idx=dsearchn(wl,350);
fit_wl_lo=350; % we will only do the fit over a limited wavelength range
fit_wl_hi=650;
plot_wl_lo=300; % wavelength range for plots
plot_wl_hi=800;
fit_idx_lo=dsearchn(wl,fit_wl_lo); 
fit_idx_hi=dsearchn(wl,fit_wl_hi);

% scale component spectra
comp1_e=comp1*971000/comp1(wl_idx);
comp2_e=comp2*97000/max(comp2(fit_idx_lo:fit_idx_hi));

% plot sample spectrum and extinction spectra
figure(1);
plot(wl,[comp1_e comp2_e]); xlim([plot_wl_lo plot_wl_hi])
legend('Component 1','Component 2')

figure(2);
plot(wl,[thesample]); xlim([plot_wl_lo plot_wl_hi])

%% Let's do the fit -- for mixture
thesample=abg4_8c_mix_abs;
thesample_name='mixture';

y=thesample(fit_idx_lo:fit_idx_hi); % make sure this is a column vector
x=[ comp1_e(fit_idx_lo:fit_idx_hi) comp2_e(fit_idx_lo:fit_idx_hi)];
% A=x\y;
A=lsqnonneg(x,y);

comp1_c=A(1);
comp2_c=A(2);
% fit_y = x*A;

% plot result
figure(2);clf
handles=plot(wl, ...
    [thesample ...
    comp1_c*comp1_e+comp2_c*comp2_e ...
    comp1_c*comp1_e ... 
    comp2_c*comp2_e ...
    (thesample - (comp1_c*comp1_e+comp2_c*comp2_e)) ...
    ]);
set(handles(1),'Color','k');
set(handles(2),'Color',0.7*[0 1 1]);
set(handles(3),'Color',[0 0.6 0],'LineStyle','-.');
set(handles(4),'Color','r','LineStyle','-.');
set(handles(5),'Color',[0 0 0.3],'LineStyle',':');
set(handles(:),'LineWidth',1.0);
xlim([plot_wl_lo plot_wl_hi]);
ylim(1.25*ylim); % so legend will fit
            
legend(thesample_name,'fit',...
    ['comp1\_factor ' num2str(comp1_c*1e6,'%.3f')],...
    ['comp2\_factor ' num2str(comp2_c*1e6,'%.3f') '; ratio ' num2str(comp2_c/comp1_c)],...
    'residual')

%% Let's do the fit -- for conjugate
thesample=abg4_8a_conjugate_abs;
thesample_name='purified conjugate';

y=thesample(fit_idx_lo:fit_idx_hi); % make sure this is a column vector
x=[ comp1_e(fit_idx_lo:fit_idx_hi) comp2_e(fit_idx_lo:fit_idx_hi)];
% A=x\y;
A=lsqnonneg(x,y);

comp1_c=A(1);
comp2_c=A(2);
% fit_y = x*A;

% plot result
figure(2);clf
handles=plot(wl, ...
    [thesample ...
    comp1_c*comp1_e+comp2_c*comp2_e ...
    comp1_c*comp1_e ... 
    comp2_c*comp2_e ...
    (thesample - (comp1_c*comp1_e+comp2_c*comp2_e)) ...
    ]);
set(handles(1),'Color','k');
set(handles(2),'Color',0.7*[0 1 1]);
set(handles(3),'Color',[0 0.6 0],'LineStyle','-.');
set(handles(4),'Color','r','LineStyle','-.');
set(handles(5),'Color',[0 0 0.3],'LineStyle',':');
set(handles(:),'LineWidth',1.0);
xlim([plot_wl_lo plot_wl_hi]);
ylim(1.25*ylim);
            
legend('sample','fit',...
    ['comp1\_factor ' num2str(comp1_c*1e6,'%.3f')],...
    ['comp2\_factor ' num2str(comp2_c*1e6,'%.3f') '; ratio ' num2str(comp2_c/comp1_c)],...
    'residual')

%% Can we estimate the absorption spectrum of bound dye?
thesample=abg4_8a_conjugate_abs;
thesample_name='purified conjugate';

y=thesample(fit_idx_lo:fit_idx_hi); % make sure this is a column vector
x=[ comp1_e(fit_idx_lo:fit_idx_hi) comp2_e(fit_idx_lo:fit_idx_hi)];
% A=x\y;
A=lsqnonneg(x,y);

comp1_c=A(1);
comp2_c=A(2);
% fit_y = x*A;

% here, we consider the case that the contribution from one component is
% determined correctly, but the other one has undergone a change in
% lineshape versus the reference. We can subtract the contribution from the
% first component from the sample to determine the absorbance due to
% everything else. In practice, if the spectrum of the second component has
% changed, its oscillator strength might well have changed also, so
% assigning a concentration, as needed to determine the extinction
% spectrum, is necessarily an estimate. Here, we consider the case that the
% spectrum hasn't changed that much and so the initial concentration
% estimate for the second component is about right. But you could take
% another approach, such as scaling the difference spectrum to have the
% same peak area or same maximum extinction coefficient as the reference.
comp2_diff_e=(thesample - comp1_c*comp1_e)/comp2_c;  

% plot result
figure(2);clf
handles=plot(wl, ...
    [thesample ...
    comp1_c*comp1_e+comp2_c*comp2_diff_e ...
    comp1_c*comp1_e ... 
    comp2_c*comp2_diff_e ...
    (thesample - (comp1_c*comp1_e+comp2_c*comp2_diff_e)) ...
    ]);
set(handles(1),'Color','k');
set(handles(2),'Color',0.7*[0 1 1]);
set(handles(3),'Color',[0 0.6 0],'LineStyle','-.');
set(handles(4),'Color','r','LineStyle','-.');
set(handles(5),'Color',[0 0 0.3],'LineStyle',':');
set(handles(:),'LineWidth',1.0);
xlim([plot_wl_lo plot_wl_hi]);
ylim(1.25*ylim);
            
legend('sample','fit',...
    ['comp1\_factor ' num2str(comp1_c*1e6,'%.3f')],...
    ['comp2 (diff) factor ' num2str(comp2_c*1e6,'%.3f') '; ratio ' num2str(comp2_c/comp1_c)],...
    'residual')

figure(1);clf
plot(wl,[comp1_e comp2_e comp2_diff_e]); xlim([plot_wl_lo plot_wl_hi])
legend('Component 1','Component 2','Component 2 (diff)')

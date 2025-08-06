%% Fit an absorption spectrum in terms of 2 components, using custom functions
% This follows the QD-dye linear combination fit example, but makes use of
% the Greytak lab's "qysetup" structures and custom functions to speed
% things up. The functions can be found in the matlab-abg-core and
% matlab-abs-emis toolboxes (currently available only to Greytak lab
% members and collaborators though a publicly accessible version is in
% development).

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

% we can often load raw absorbance data into structures using a version of
% the "uvvis" command but here we will do so manually for simplicity and
% flexibility if you choose to adapt this template to other problems.
abg4_8c_mix=qysetup;
abg4_8a_conjugate=qysetup;
comp1=qysetup;
comp2=qysetup;

abg4_8c_mix.abs_wl=wl;
abg4_8c_mix.abs=abg4_8c_mix_abs;
abg4_8c_mix.absfile='mixture';
qyupdate(abg4_8c_mix)

abg4_8a_conjugate.abs_wl=wl;
abg4_8a_conjugate.abs=abg4_8a_conjugate_abs;
abg4_8a_conjugate.absfile='conjugate';
qyupdate(abg4_8a_conjugate)

abg4_8b_qd.abs_wl=wl;
abg4_8b_qd.abs=abg4_8b_qd_abs;
abg4_8b_qd.absfile='QD ref';
qyupdate(abg4_8b_qd)

rox.abs_wl=wl;
rox.abs=rox_se_dye_abs;
rox.absfile='dye ref';
qyupdate(rox)

thesample=abg4_8c_mix;
% thesample=abg4_8a_conjugate;

% select and scale reference spectra
% We want to multiply the absorbance of each reference sample by the 
% known extinction coefficient divided by the measured absorbance at the
% reference wavelength. Then, the y value will be the extinction
% coefficient at every wavelength, or, the absorbance you'd have for a
% hypothetical 1 molar sample. For the QD, the reference wavelength is 350
% nm. For the dye, they quote a value at the absorption peak, but we will
% need to find where that is. These steps are easy to do with the qysetup
% structures and functions in matlab-abs-emis
comp1_e=uvscale(abg4_8b_qd,971000/abg4_8b_qd.absf(350));
rox=uvbase(rox,[640 700]); % baseline correction
comp2_e=uvscale(rox,97000/max(rox.absf(500:650)));


% find out which wavelength index corresponds to 350 nm, and the limits of
% the spectrum region in which we plan to do the fit
fit_wl_lo=350; % we will only do the fit over a limited wavelength range
fit_wl_hi=650;
fitrange=fit_wl_lo:fit_wl_hi;
plot_wl_lo=300; % wavelength range for plots
plot_wl_hi=800;
plotrange=plot_wl_lo:plot_wl_hi;

% plot sample spectrum and extinction spectra
figure(1);
uvplot([comp1_e comp2_e],[],1,[plot_wl_lo plot_wl_hi])
% legend('Component 1','Component 2')

figure(2);
plot(thesample.abs_wl,[thesample.abs]); xlim([plot_wl_lo plot_wl_hi])

%% Let's do the fit -- for mixture
thesample=abg4_8c_mix;

y=thesample.absf(fitrange); % make sure this is a column vector
x=[ comp1_e.absf(fitrange) comp2_e.absf(fitrange)];
% A=x\y;
A=lsqnonneg(x,y);

comp1_c=A(1);
comp2_c=A(2);
% fit_y = x*A;

% plot result: we could use uvsum and uvscale to assemble to component
% spectra and fit, especially if the raw data was sampled on different
% wavelength scales. For simplicity, we are not doing that here.
figure(2);clf
handles=plot(thesample.abs_wl, ...
    [thesample.abs ...
    comp1_c*comp1_e.abs+comp2_c*comp2_e.abs ...
    comp1_c*comp1_e.abs ... 
    comp2_c*comp2_e.abs ...
    (thesample.abs - (comp1_c*comp1_e.abs+comp2_c*comp2_e.abs)) ...
    ]);
set(handles(1),'Color','k');
set(handles(2),'Color',0.7*[0 1 1]);
set(handles(3),'Color',[0 0.6 0],'LineStyle','-.');
set(handles(4),'Color','r','LineStyle','-.');
set(handles(5),'Color',[0 0 0.3],'LineStyle',':');
set(handles(:),'LineWidth',1.0);
xlim([plot_wl_lo plot_wl_hi]);
ylim(1.25*ylim); % so legend will fit
            
legend(thesample.absfile,'fit',...
    ['comp1\_factor ' num2str(comp1_c*1e6,'%.3f')],...
    ['comp2\_factor ' num2str(comp2_c*1e6,'%.3f') '; ratio ' num2str(comp2_c/comp1_c)],...
    'residual')

%% Let's do the fit -- for conjugate
thesample=abg4_8a_conjugate;

y=thesample.absf(fitrange); % make sure this is a column vector
x=[ comp1_e.absf(fitrange) comp2_e.absf(fitrange)];
% A=x\y;
A=lsqnonneg(x,y);

comp1_c=A(1);
comp2_c=A(2);
% fit_y = x*A;

% plot result: we could use uvsum and uvscale to assemble to component
% spectra and fit, especially if the raw data was sampled on different
% wavelength scales. For simplicity, we are not doing that here.
figure(2);clf
handles=plot(thesample.abs_wl, ...
    [thesample.abs ...
    comp1_c*comp1_e.abs+comp2_c*comp2_e.abs ...
    comp1_c*comp1_e.abs ... 
    comp2_c*comp2_e.abs ...
    (thesample.abs - (comp1_c*comp1_e.abs+comp2_c*comp2_e.abs)) ...
    ]);
set(handles(1),'Color','k');
set(handles(2),'Color',0.7*[0 1 1]);
set(handles(3),'Color',[0 0.6 0],'LineStyle','-.');
set(handles(4),'Color','r','LineStyle','-.');
set(handles(5),'Color',[0 0 0.3],'LineStyle',':');
set(handles(:),'LineWidth',1.0);
xlim([plot_wl_lo plot_wl_hi]);
ylim(1.25*ylim); % so legend will fit
            
legend(thesample.absfile,'fit',...
    ['comp1\_factor ' num2str(comp1_c*1e6,'%.3f')],...
    ['comp2\_factor ' num2str(comp2_c*1e6,'%.3f') '; ratio ' num2str(comp2_c/comp1_c)],...
    'residual')

%% Can we estimate the absorption spectrum of bound dye?
thesample=abg4_8a_conjugate;

y=thesample.absf(fitrange); % make sure this is a column vector
x=[ comp1_e.absf(fitrange) comp2_e.absf(fitrange)];
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
comp2_diff_e=uvscale(uvdiff(thesample,uvscale(comp1_e,comp1_c)),1/comp2_c);
comp2_diff_e.absfile=[comp2_e.absfile '_diff'];

% plot result: we could use uvsum and uvscale to assemble to component
% spectra and fit, especially if the raw data was sampled on different
% wavelength scales. For simplicity, we are not doing that here.
figure(2);clf
handles=plot(thesample.abs_wl, ...
    [thesample.abs ...
    comp1_c*comp1_e.abs+comp2_c*comp2_diff_e.abs ...
    comp1_c*comp1_e.abs ... 
    comp2_c*comp2_diff_e.abs ...
    (thesample.abs - (comp1_c*comp1_e.abs+comp2_c*comp2_diff_e.abs)) ...
    ]);
set(handles(1),'Color','k');
set(handles(2),'Color',0.7*[0 1 1]);
set(handles(3),'Color',[0 0.6 0],'LineStyle','-.');
set(handles(4),'Color','r','LineStyle','-.');
set(handles(5),'Color',[0 0 0.3],'LineStyle',':');
set(handles(:),'LineWidth',1.0);
xlim([plot_wl_lo plot_wl_hi]);
ylim(1.25*ylim); % so legend will fit
            
legend(thesample.absfile,'fit',...
    ['comp1\_factor ' num2str(comp1_c*1e6,'%.3f')],...
    ['comp2\_factor ' num2str(comp2_c*1e6,'%.3f') '; ratio ' num2str(comp2_c/comp1_c)],...
    'residual')

figure(1);clf
uvplot([comp1_e comp2_e comp2_diff_e],[],1,[plot_wl_lo plot_wl_hi])
% legend('Component 1','Component 2','Component 2 (diff)')

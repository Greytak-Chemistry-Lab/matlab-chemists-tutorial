%% matrix math tutorial: linear combinations, polynomial fits: part 2
% Continues from part 1: here, we will create some waveforms, generate fake
% data using a linear combination of them (plus noise and background), and
% then see if we can do a linear combination fit to recover the
% coefficients for each waveform component.

%% create fundamental waveforms
x=linspace(0,100,101)';
w1=double(size(x));
w2=double(size(x));
w3=double(size(x));
w1_x0=10;
w1_sigma=5;
w2_x0=30;
w2_sigma=10;
w3_x0=50;
w3_sigma=15;
w1=exp(-((x-w1_x0).^2)./w1_sigma^2);
w2=exp(-((x-w2_x0).^2)./w2_sigma^2);
w3=exp(-((x-w3_x0).^2)./w3_sigma^2);
figure(1);clf
plot(x,[w1 w2 w3])
legend('w1','w2','w3')
%% create fake data
% M=[w1 w2 w3];
% A_fake=[200 0 100]'; % coefficient vector we will choose to make fake data
% y_fake=M*A_fake;

% now, y_fake is a linear combination of the 3 component waves. You can make
% things more interesting by adding various kinds of noise. First,
% initialize the random number generator
% rng('shuffle');
% y_noisy=y_fake;

% add random noise
% noise_level=10;
% y_noisy=y_noisy + noise_level*(-1.0 + 2.0*rand(size(x)));

% add Gaussian distributed noise (requires Matlab's Statistics toolbox)
% noise_level=20;
% y_noisy=y_noisy + normrnd(0,noise_level,size(y_noisy));

% add background
% bkgd=10;
% y_noisy=y_noisy+bkgd;

% choose Poisson distributed values, typical of photodetector count signals
% (requires Statistics toolbox)
% y_noisy(y_noisy<1)=1; % get rid of zero or negative values 
% y_noisy=poissrnd(y_noisy);

% let's see what we made
% figure(2);clf
% plot(x,[y_fake y_noisy])
% legend('y (simulated components)','y (noisy data to fit)')

%% See if we can fit this data with the known waveforms
% As a reminder, we are looking for the set of fit coefficients A_fit that
% minimize the error in the following equation:
% y_noisy = M*A_fit

% Do this with left-divide:
% A_fit=M\y_noisy;
% disp(A_fit)

% That was easy! It will be nice to add a list of the fit coefficients to
% the figure and put the fit curve, waveform components, and residual
% (difference between data and fit) on the plot.

% The following expression builds up a title for the figure with the
% coefficient values. Actually, it only does the first two. Edit it to
% include the third!
% fitstring=['A=[' num2str(A_fit(1)) ' ' num2str(A_fit(2)) ']' ];

% Let's use the fit coefficients we got to generate a fit curve and a
% scaled version of each component, and add them to the plot:
% y_fit=M*A_fit;

% Now plot everything: using h=plot() gives a set of "handles" (Matlab
% objects) for each plotted line, with properties that you can adjust to
% change the appearance.
% figure(3)
% h=plot(x,[y_noisy y_fit w1*A_fit(1) w2*A_fit(2) w3*A_fit(3) (y_noisy-y_fit)]);
% set(h(1),'Color','b')
% set(h(2),'LineWidth',1,'Color','k')
% set(h([3 4 5]),'LineStyle','-.')
% 
% title(fitstring)  % add the title we prepared before to our plot
% legend('y (noisy data to fit',...
%     'fit result',...
%     'w1 component',...
%     'w2 component',...
%     'w3 component',...
%     'residual')

% Try changing the component waveforms, and the amount and type of noise,
% to see if the coefficients you obtain in the fit are similar to what you
% specified when creating the fake data. Also try changing the plot
% appearance.

%% Enforcing non-negative fit coefficients
% The example above will work even if some of the fit coefficients are
% negative (try changing the sign of one of the component waveforms or its
% coefficient -- note the Poissonian noise won't work for negative data
% values and you may want to comment it out for this).
%
% For some types of experiments/data, this is good: there could be a reason
% for fit coefficients to be negative. In other cases, such as coefficients
% for different component waveforms in an absorption spectrum that should
% each be proportional to the molar concentration of some chemical
% constituent, we are very confident that the fit coefficients should not
% be negative, and we want Matlab to find the best fit with this constraint
% in mind. 

% lsqnonneg does exactly this, and you call it with the same syntax as the
% functional form of \ (namely mldivide):
% A_nonneg_fit=lsqnonneg(M,y_noisy);
% disp(A_nonneg_fit)
% y_nonneg_fit=M*A_nonneg_fit;

% and now plot:
% figure(4)
% h=plot(x,[y_noisy ...
%     y_nonneg_fit ...
%     w1*A_nonneg_fit(1) ...
%     w2*A_nonneg_fit(2) ...
%     w3*A_nonneg_fit(3) ...
%     (y_noisy-y_nonneg_fit)]);
% set(h(1),'Color','b')
% set(h(2),'LineWidth',1,'Color','k')
% set(h([3 4 5]),'LineStyle','-.')
% 
% legend('y (noisy data to fit',...
%     'fit result',...
%     'w1 component',...
%     'w2 component',...
%     'w3 component',...
%     'residual')

% fitstring=['A=[' num2str(A_nonneg_fit(1)) ' ' num2str(A_nonneg_fit(2)) ' ' num2str(A_nonneg_fit(3)) ']' ];
% title(['Non-negative coeffs: ' fitstring])

%% More examples
% You can come up with some goofy waveforms and coefficient values to test
% the effect of this, but for an example of where it comes up, try keeping
% the 3 Gaussian waveforms, set one of the coefficients to zero (so there
% should not be any there), and then give the data a slightly negative
% background value. When you fit with \ , you might see a negative
% coefficient value show up for the one that's supposed to be zero. If you
% fit the same data with lsqnonneg, there will not be negative
% coefficients. For cases where \ gives all positive coefficent values in
% the fit, lsqnonneg should give the exact same result.

% Additional examples: 
% lsqnonneg_demo: an additional demo with synthesized data: complete

% QD_dye_example: determines average ratio of dyes to QDs in a QD-dye
% conjugate, using built-in Matlab functions or Greytak lab custom
% functions




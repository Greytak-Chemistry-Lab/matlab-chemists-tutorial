% Exercise for plotting in Matlab: isotherms and adiabats for ideal gas
%
% Plot lines of pressure versus volume for an ideal gas sample at constant
% temperature (isotherms) and constant entropy (adiabats, following
% adiabatic compression/expansion). Adiabatic compression shows a steeper
% rise in pressure as the volume is decreased. Lines are prepared for a
% series of initial temperatures at some common starting volume.

%% constants
% here are some constants I frequently use. The only one we actually need
% here is the appropriate form of the gas constant.

% h=6.6261e-34; % J-s
% hbar=h/(2*pi());
% m0=9.109e-31; % kg
% mp=1.66e-27; % kg
% kB=1.3806503e-23; % J/K
% e0=8.854e-12; % SI units = F/m 
% q=1.602e-19; % C
% % kB=8.617?3; % eV/K
% N_A=6.02214e23; % mol^-1
% F=q*N_A;
% 
% J_per_eV=1.602e-19;
% J_per_Latm=8.31447/8.20574e-2;
% R_H=-13.6; % eV

% R=8.31447; % J / mol-K
% R=8.31447e-2; % L-bar / mol-K
R=8.20574e-2; % L-atm / mol-K
% R=6.23637e1; % L-Torr / molk-K
% R=8.20574e-5; % m^3-atm / mol-K

%% Initial volume and gas properties
f = 3; % classical degrees of freedom per molecule: 3=atomic, 5=linear, 6=poly
V1=0.5; % initial molar volume, Liters/mol

%% plots
% we will make a single plot with overlayed isotherms (lines of pressure vs
% volume at constant temperature) and adiabats (lines of pressure vs volume
% at constant entropy, but starting at the same initial temperatures as the
% isotherms, at the initial volume we have specified)
 Temps=[200 300 400]; 

% we generate a logarithmically spaced set of volumes: logarithm of volume
% will be evenly spaced. This lets us have more points at low volume where
% the pressure is changing rapidly.
% Vols=10.^[-2:0.01:2]; 

% The code below is designed to work automatically for the set of volumes
% and initial temperatures we set above

% isotherms

% make a matrix where each column is a set of volumes, and there is a
% column for the curve at each temperature
%
% Here, we use "zeros" to get a matrix of type double of the right size,
% but with every element equal to zero. We don't have to do this (you can
% add elements as you go) but Matlab runs faster if you do it this way.
%
% isotherm=zeros(length(Vols),length(Temps));

% Next we initialize a cell array we will use for the legend
% legendstr=cell(length(Temps),1); 

% We will use a "for" loop to step through the series of temperatures.
% "for" expects a variable to be set to a vector (list) of values, and will
% execute what's in the loop once for each value. You have to end
% conditional statements with 'end' in Matlab. It is typical, but not
% required, to indent code that is within a conditional statement.
for(j=1:length(Temps))
    T=Temps(j);
    % The following will fail because R and T are scalars, while Vols is a
    % vector. When something fails in a loop, it can be tricky to de-bug.
    % But you can try selecting the code and running it a piece at a time.
    % Can you add a dot to make it do an elementwise calculation for every
    % volume?
    p_isotherm=R*T/Vols;
    % The following will fail with an error: why? can you fix it? We are
    % trying to place the entire series of pressure values you calculated
    % above into one column (the j'th column) of the isotherm matrix
    isotherm(:,j)=p_isotherm; 
    % Now add a label for the legend. You can concatenate strings by
    % putting them in brackest like this. num2str converts a number to a
    % string. You can specify the format with a c-like format descriptor,
    % if you want, but for integers you don't need that.
    legendstr{j}=['T = ' num2str(T) ' K'];
end
figure(1);clf
% This will plot all of our curves:
% plot(Vols,isotherm,'b'); % you can try changing the color or linespec
% xlim([0 2])
% ylim([0 100])
% ylabel('Pressure (atm)')
% xlabel('Molar volume (L/mol)')
% set(gca,'yscale','log') % set scale to log if you prefer
% set(gca,'xscale','log') % set scale to log if you prefer

% You can pass a cell array of strings to legend, with each string being
% the label for one of the lines plotted on the current axes
% legend(legendstr);

% hold on so we can add more 
% hold on;

% adiabats
gamma_c=(f+1)/f;
adiabat=zeros(length(Vols),length(Temps));
for(j=1:length(Temps))
    T=Temps(j);
    p1=R*T/V1; % get inital pressure (scalar) at initial volume V1
    % Dots for element-wise math
    p_adiabat=p1*(V1./Vols).^gamma_c;
    % The following will (again) fail with an error: why? can you fix it?
    adiabat(:,j)=p_adiabat;
    % Add a legend element for each curve
    legendstr{length(Temps)+j}=['Adiabatic, T_i = ' num2str(T) ' K']; 
end
% plot(Vols,adiabat,'k:'); % plot as dashed black lines
% legend(legendstr);
% hold off

% add title to the plot. 
% title('Comparing isothermal and adiabatic pressure changes, ideal gas')

%% Annotate the plot
% you can add lines, text annotations, and other shapes to plots. Here, add
% a line to indicate the inital volume, at which the isotherms and adiabats
% should cross

% It's line([x1 x2],[y1 y2],property-value pairs). You give vectors of equal lengths for the
% x points and y points of the line. Here, we want a vertical line at the
% inital volume. We give this here as [V1 V1], but you could also do 
% V1*[1 1]. Here, I've specified the y limits, but often you want to simply
% use 'ylim' to capture the current y limits on the axes and use those. Can
% you make this change?
line([V1 V1],[0 80],'Color','m')

% Now try adding a horizontal green line: 'Color','g' at each of the
% pressures corresponding to each of the inital temperatures at the initial
% volume. Use a for loop to make sure we do it for each one, even if we've
% added more than 3. Then try changing the temperatures, or adding a fourth
% temperature, and re-run the whole script to make sure it works.

% The line commands might add extra entries to the legend. We probably
% don't want that, so we can run legend again to only include the entries
% for the curves:
% legend(legendstr);

%% Find 'tie lines' for liquid-gas phase transitions van der Waals equation of state
% an example using anonymous function handles
%
% note there are some things in here that could be done more efficiently in
% other ways: for example, I use for loops in some places where I could use
% element-wise notation to calculate things for a series of volumes, etc.
% I am a chemist, not a programmer! It's OK to have inefficient code if it
% lets you get what you want, faster. I'm rather proud of how I detect
% the range of volumes corresponding to the phase transition though.

clear

% define some fundamental constants

J_per_eV=1.602e-19;
J_per_Latm=8.31447/8.20574e-2;

% R=8.31447; % J / mol-K
% R=8.31447e-2; % L-bar / mol-K
R=8.20574e-2; % L-atm / mol-K
% R=6.23637e1; % L-Torr / molk-K
% R=8.20574e-5; % m^3-atm / mol-K

%% van der Waals parameters
% uncomment the gas you wish to plot

% CO2
% a = 3.610; % (atm-L^2)/mol^2
% b = 4.29e-2; % L/mol

% C2H2
% a = 4.55; % (atm-L^2)/mol^2
% b = 5.82e-2; % L/mol

% N2
% a = 1.352; % (atm-L^2)/mol^2
% b = 3.87e-2; % L/mol

% H2O
a=5.464; % (atm-L^2)/mol^2
b=3.05e-2; % L/mol

% ideal
% a = 0;
% b = 0;

%% Figure 1 -- plot pressure vs molar volume for a series of temps
Temps=[0:40:400]+273;
% Temps=120;
Vols=10.^[-3:0.01:2]; % actually molar volumes
isotherm=zeros(length(Vols),length(Temps));
legendstr=cell(length(Temps),1);
for(j=1:length(Temps))
    T=Temps(j);
    % build pressure as function of Vm using a, b, and T as parameters
    p_vdW=@(Vm) R*T/(Vm - b) - a/Vm^2;
    for(k=1:length(Vols))
        isotherm(k,j)=p_vdW(Vols(k));
    end
    legendstr{j}=['T = ' num2str(T)];
end
figure(1);clf
% set(gcf,'colororder',[0 0 0]);
plot(Vols,isotherm,'b');
xlim([0 10])
ylim([0 250])
ylabel('Pressure (atm)')
xlabel('Molar volume (L/mol)')
% set(gca,'yscale','log')
% set(gca,'xscale','log')
legend(legendstr);
hold on;

% ideal gas, for comparison
% a=0;
% b=0;
% p_vdW=@(Vm) R*T/(Vm - b) - a/Vm^2;
% isotherm=zeros(length(Vols),length(Temps));
% for(j=1:length(Temps))
%     T=Temps(j);
%     p_vdW=@(Vm) R*T/(Vm - b) - a/Vm^2;
%     for(k=1:length(Vols))
%         isotherm(k,j)=p_vdW(Vols(k));
%     end
% end
% plot(Vols,isotherm,'k-.'); % plot as dashed lines
% hold off

%% Figure 2: tie lines, Maxwell construction, for corresponding states 
% The vdW equation of state predicts a region of negative compressibilty
% (pressure decreases with lower volume) that is un-physical, when the
% temperature is below the critical temperature of the fluid. What really
% happens is you have a region of constant pressure as volume is decreased,
% in which the system contains both high-density liquid and low-density gas
% at equilibrium. We want to know, for a particular temperature, what the
% pressure will be when this happens. Maxwell suggested that it should be
% the pressure such that, if you integrate -p dV over the phase transition
% region (i.e. calculate the work to compress), you get the same value
% whether following the "tie line" or the predicted isotherm. In other
% words, we need the difference between the "tie line" and the predicted
% vdW isotherm to integrate to zero. We will use Matlab to find the
% pressure that makes that true, for each of the temperatures we are given.
%
% It is easier to do this calculation for "corresponding states": using the
% vdW equation of state expressed in terms of a scaled relative temperature
% T_r=T/Tc, relative pressure p_r=p/pc, and relative molar volume V_mr=V_m/V_mc

% Then, we can scale the results back for our specific gas of interest.
figure(2);clf
clear isotherm_r
T_rs=[ 0.4529 0.6:0.1:1.1]; % series of relative temperatures
Vols_r=10.^[-0.47:0.01:3.0]; % logarithmic series of relative molar volumes
isotherm_rs=zeros(length(Vols_r),length(T_rs));
isotherm_rs_corrected=isotherm_rs;
p_ties=zeros(1,length(T_rs));
Vm_ties=zeros(2,length(T_rs));

for(j=1:length(T_rs))
    T_r=T_rs(j);
    legendstr_maxwell_r{j}=['Tr = ' num2str(T_r)];
    % anonymous function for relative pressure 
    p_r=@(Vm_r) 8*T_r/(3*Vm_r - 1) - 3/Vm_r^2;
    % now use it to build up 
    for(k=1:length(Vols_r))
        isotherm_r(k)=p_r(Vols_r(k));
    end
    % isotherm_r is now a matrix of relative pressures for each relative
    % volume and temperature point
    plot(Vols_r,isotherm_r)
    % initialize a similar matrix that will contain corrected values once
    % tie line positions are determined.
    isotherm_corrected=isotherm_r;

    % locate region of positive slope
    if( find( diff(isotherm_r) > 0 ) )
        % if it exists, find the pressure at the low extreme
        p_lo=p_r(Vols_r(find(diff(isotherm_r) > 0,1)));
        % find the pressure at the high extreme
        p_hi=p_r(Vols_r(find(diff(isotherm_r) > 0,1,'last')));
        if(p_lo<0)
            p_lo=0;
        end
        
        % make pressure at high-volume end go to zero
        isotherm_r(end)=0;
        % generate an anonymous function handle that will calculate the
        % difference in work betweent the tie line, and vdW, for any
        % pressure selected as the phase transition pressure. Then we just
        % have to figure out the best pressure so this function handle
        % returns zero.
        work_error_f=@(p) local_simpson(Vols_r(find(diff(isotherm_r-p>0)<0,1):find(diff(isotherm_r-p>0)<0,1,'last')), ...
            -(isotherm_r(find(diff(isotherm_r-p>0)<0,1):find(diff(isotherm_r-p>0)<0,1,'last'))-p) );
        % fzero is a Matlab built-in function that will find the value of x
        % where any function crosses zero. You give it a function handle
        % (or define one via anonymous function handle as shown) and a
        % starting value to search near (as shown) or range to search between.
        p_tie=fzero(@(p) work_error_f(p),p_lo+(p_hi-p_lo)*0.5);
        % sanity check: make sure tie pressure is > 0
        if(p_tie<0)
            p_tie=0;
        end
        % using some logic to detect the volumes at the end of the tie
        % line: as the volume increases from zero, the low-volume end is        % the first place where the vdW pressure goes from being above the
        % tie line pressure to below it. The high-volume end is the second
        % place that happens.
        Vm_tie=find(diff(isotherm_r-p_tie>0)<0);
        % set all pressures in the phase transition region to the constant
        % tie line pressure (vapor pressure at this temperature)
        isotherm_corrected(Vm_tie(1):Vm_tie(2))=p_tie;
%         disp(p_tie)
        p_ties(j)=p_tie;
        Vm_ties(:,j)=Vm_tie;
    end
    isotherm_rs(:,j)=isotherm_r;
    isotherm_rs_corrected(:,j)=isotherm_corrected;
    
end

plot(Vols_r,isotherm_rs_corrected,'r',Vols_r,isotherm_rs,'r:')
ylim([0 1.5])
xlim([0 10])
legend(legendstr_maxwell_r)
xlabel('Relative molar volume V_{mr} = V_m/V_{m,c}')
ylabel('Relative pressure p_r = p/p_c')

%% Figure 3: plot with tie-lines on real scale for the selected gas
% calculate critical values based on vdW parameters
Tc=8*a/(27*b*R);
pc=a/(27*b^2);
Vc=3*b;
figure(3); clf
plot(Vols_r*Vc,isotherm_rs_corrected*pc,'k',Vols_r*Vc,isotherm_rs*pc,'k:')
ylim([0 1.5]*pc)
xlim([0 10]*Vc)
Temps=T_rs*Tc;
for(j=1:length(T_rs))
    legendstr_maxwell{j}=['T = ' num2str(Temps(j),'%.0f') ' K'];
end
legend(legendstr_maxwell)
ylabel('p/atm')
xlabel('V_m / (L/mol)')

%% local function definition(s)
function a=local_simpson(x,y)
% Simpsons rule integration of y with respect to x
%
% Simpson's rule is the area under a linearly interpolated curve and is a
% good approach for integration of discrete data.
% A=SIMPSON(X,Y)
% Returns Simpson's rule integral of Y(X)dX
% See also qyplot

x=reshape(x,length(x),1);
y=reshape(y,length(y),1);

x=diff(x);
y=(y(1:end-1)+y(2:end))/2;
a=sum(x.*y);
end
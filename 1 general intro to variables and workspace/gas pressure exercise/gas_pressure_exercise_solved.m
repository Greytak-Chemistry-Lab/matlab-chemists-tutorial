% Exercise: gas law calculator

% The ideal gas law predicts the pressure of a gas, in atmospheres,
% is p=n*R*T/V, where n is the number of moles, T is the absolute
% temperature in K, V is the volume in liters, and R=0.0821 L-atm/(mol-K).
%
% The van der Waals equation of state can more accurately predict the pressure of a gas (in
% atm) based on the volume (in Liters), number of moles, and temperature
% (in K), with the gas constant R (=0.0821 L-atm/(mol-K)), and two
% gas-specific parameters a (in atm-L^2/mol^2) and b (in L/mol) as
% parameters, as p=R*T/(Vm-b) - a/Vm^2, where the "molar volume" Vm=V/n
%
% First, write a script that defines V, T, n, R, a, and b as scalar
% variables (type double), and then write an expression to find the
% pressure p in terms of them. Display p with disp(p). Make sure it gives
% the value you expect for the ideal gas when a=0 and b=0. Then look up
% values of a and b for N2 and for CO2, and put these as options at the top
% of the script (so a user can un-comment the appropriate a and b for the
% gas they are interested in).

% CO2
a = 3.610; % (atm-L^2)/mol^2
b = 4.29e-2; % L/mol

% % ideal gas
% a = 0;
% b = 0;

T = 330; % Kelvin
V = 2.0; % L
n = 1.0; % mol
Vm=V/n;
p= R*T/(Vm - b) - a/Vm^2;
disp(p)

% Then, modify it so that V is defined as a row vector of volumes from some
% low to high limit, using linspace. Modify your expression for p, as
% needed, to do element-wise math so that p ends up as a vector of
% pressures corresponding to each volume. Also calculate a vector of molar
% volumes Vm.
%
% Hint: Vm=V/n; % if you take an array and add, subtract, multiply or
% divide by a scalar value, Matlab will automatically do it elementwise.
% However, where an array appears in the denominator, or is taken to an
% exponent, you need to explicitly say you want it to an element-wise
% calculation. For the ideal gas you would have
% p=R*n*T./V;

T = 330; % Kelvin
V = 1.0 : 0.5 : 5.0; % L
n = 1.0; % mol
Vm=V./n;
p= R*T./(Vm - b) - a./Vm.^2;
disp(p)

% Test it: for CO2 with T=330 K, V=2.0 L, and n = 1.0 mol, you should get a
% pressure of 13.54 atm. Using van der Waals, you should get 12.93 atm.

% Next: make a plot of p versus V, or Vm. The 'plot' command goes plot(x,y): 
plot(Vm,p)
% We will look more at plots in the next unit.



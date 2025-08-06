function out=ev_demo(nm)
% return electron volts for input in nm

% the first comment line above will be printed when someone types "help ev"

h=4.135668e-15;  % Planck's constant in eV-s
c=299792458;  % m/s

% using element-wise notation
lambda=nm*1e-9;
out=h*c./lambda;


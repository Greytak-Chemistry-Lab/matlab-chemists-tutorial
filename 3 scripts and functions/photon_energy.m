function out=photon_energy(nm,varargin)
% return photon energy in eV or cm^-1 for input wavelength in nm
% 
% accept a second input indicating mode 

% nargin is a special variable giving the TOTAL NUMBER of input arguments
% varargin is a special variable, of type cell array, in which each of the
% "variable" (non-required) input arguments is an element.
% First try a demo:
% if(nargin>1)  
%     for(k=1:length(varargin))
%         disp(varargin{k})
%     end
% end

% now some real code:
% outputmode='eV'; % set a default
% if(nargin>1)
%     outputmode=varargin{1}; % replace with specified mode if given by user
% end

% h=4.135668e-15;  % Planck's constant in eV-s
% c=299792458;  % m/s

% The code below contains a mistake, see if you can fix it

% switch outputmode
%     case 'eV'
%         % using element-wise notation
%         lambda=nm*1e-9;
%         out=h*c./lambda;
%     case 'wavenumber'
%         % element-wise again. There are 10^7 nm in 1 cm
%         out=1e7./lambda; 
%     otherwise
%         error('Unknown output mode. Available: eV, wavenumber.')
% end



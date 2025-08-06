function assign_h(varargin)
units='eV-s';
if(nargin>=1)
    units=varargin{1};
end

switch units
    case 'eV-s'  % this is case sensitive by the way
        h=4.1357e-15;
    case 'J-s'
        h=6.6261e-34;
    otherwise
        error('Unknown units')
end

assignin('caller','h',h)

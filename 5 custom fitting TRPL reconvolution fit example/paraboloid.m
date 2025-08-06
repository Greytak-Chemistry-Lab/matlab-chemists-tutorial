function y=paraboloid(x,varargin)

c=6;
x10=2;
x20=3;

if nargin==3
    x10=varargin{1};
    x20=varargin{2};
end

y=((x(1)-x10)/1)^2 + ((x(2)-x20)/1)^2 + c;


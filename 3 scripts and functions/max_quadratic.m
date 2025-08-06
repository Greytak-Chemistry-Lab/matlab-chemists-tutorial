function out=max_quadratic(a,b,c)
% a x^2 + bx + c = 0
% return the maximum value

% the extreme occurs when the derivative is equal to zero
% that's when 2*x - b = 0
% so, when x = b/2

% let's check if a, b, and c define a proper parabola
if(a>0)
    out=Inf; % if curvature is up, max value is infinity
elseif(a<0)
    % call nested_quadratic to determine the value of the function when
    % derivative is equal to zero (x=b/2):
    out=nested_quadratic(b/2);
else
    warning('a=0, function specified is a line');
    if(b~=0)
        out=Inf;
    else
        out=c;
    end
end

function y=nested_quadratic(x)
    % x is the only input to this function, y the only output, but it is
    % able to use a, b, and c as parameters.
    y=a*x^2 + b*x + c;
end

end
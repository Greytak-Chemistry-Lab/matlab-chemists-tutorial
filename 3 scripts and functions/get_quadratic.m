function out=get_quadratic(a,b,c)
% gives a function handle for a quadratic built using the input coefficients:
% y = a x^2 + bx + c 

% You can do some cleanup of input parameters up here if desired
if(a==0)
    warning('This is going to be a linear function, not quadratic!')
end

% this is all we need in the main function: set output variable equal to a
% function handle for the nested function
out=@nested_quadratic;
    
% now define the function we are trying to build
function y=nested_quadratic(x)
    % x is the only input to this function, y the only output, but it is
    % able to use a, b, and c as parameters.
    y=a*x^2 + b*x + c;
end % end of nested function

end % end of main function

%% Custom curve fitting by minimizing error with fminsearch
% Illustrates use of fminsearch, and its use in curve fitting by minimizing
% error with respect to several parameters. Points to examples based on
% multiexponential decays, including reconvolution fitting

% Approaches to curve fitting in Matlab include matrix math to solve linear
% combinations and polynomial fits (covered in previous tutorial segment)
% and the builtin 'cftool' graphical user interface for fitting custom
% functions. This tutorial will not describe cftool, which is covered in
% its own documentation ('doc cftool' for help). However, some situations
% encountered in chemistry may encounter complex models, such as fitting a
% time-resolved decay that has been smeared out by an instrument response
% function, that are not easily dealt with by cftool. In these cases,
% using 'fminsearch' to find the set of fitting parameters that minimize
% the total error ("badness of fit") can be a helpful approach. We will
% also briefly look at 'fzero' to find when an arbitrary 1-D function
% crosses zero.

% fminsearch, fzero, cftool

%% fminsearch demo: find minimum value of quadratic function
% The basic behavior of fminsearch is to find the parameter(s) that
% minimize a function. You need to pass it a *function handle*, a starting
% guess, and optionally some settings generated with 'optimset'.

% The function handle can be one that you defined in your workspace
% previously, or an anonymous function handle, but not simply the name of a
% function .m file. But, you can use an anonymous function handle that
% simply calls a .m file, as we will see below.

% The function handle given to fminsearch will always be a function of ONE
% variable, but that variable can be an array with multiple elements that
% you can index in the usual way in the function definition (inline or in
% the .m file)


%% fminsearch demo: find parameters for polynomial 




%% fminsearch example application: multiexponential fit



%% fminsearch example application: reconvolution fit


%% Tutorial on functions in matlab (part 2)

% Go through part 1 of this tutorial first, which covers the basics of
% scripts, functions defined in .m files, and conditional statements

% Before starting this tutorial, clear your current workspace using one of
% the following:

% clear  % by default only clears variables
% clear functions % this will clear cached function definitions as well
clear all  % this will clear both

%% function handles
% A "function handle" is a type of variable that refers to a function. The
% function it refers to can be a built-in function, one you defined in a
% file, or defined in other ways. Put an @ in front of the keyword you
% would normally use for the function to define a function handle for it:

% test_function_handle=@ver;  % built-in that tells you what's installed
% test_function_handle=@license; % built-in that gives license number

% run it:
% test_function_handle()

% I usually like to give function handles names ending in f or fcn
% energy_f=@ev_demo;
% energy_f(500); % should give energy of 500 nm photon in electron-volts

% You'll see what use this has later, but it lets you change which function
% is used in a section of code without renaming every instance, and you can
% pass function handles to other functions, which is extremely useful.

%% inline function definitions (anonymous functions)
% You can also create a function handle for a function defined in a single
% line of code: called an "anonymous function" because the code isn't
% stored anywhere except in memory once the function handle is defined.

% specify the input variables inside the parentheses, then write the
% function definition. The input variable(s) are just placeholders: they do
% not need to exist in your workspace and won't be created there when you
% create or use the function handle:
squared_f=@(x) x^2;
squared_f(5) % should give 25
% squared_f=@(x) x.^2; % probably better, works for array inputs

%% You can use variables from your workspace that ARE NOT listed as inputs
% to the anonymous function in the definition. Their current values will be
% baked into the function handle: its behavior will not change even if you
% later change the value of these parameters.
a=2;
powerlaw_f=@(x) x^a;
powerlaw_f(5) % should give 25
% a=3;
% powerlaw_f(5) % try it now
% powerlaw_f=@(x) x^a;
% powerlaw_f(5) % try it now

%% If you need to pass multiple variables to an anonymous functions, you can
% either use a vector input, or put list multiple variables as inputs
% powerlaw_f = @(x) x(1)^x(2);  % will work for two scalars
% powerlaw_f([5 2]) % should give 25
% powerlaw_f([5 3]) % should give 125
% powerlaw_f = @(x,b) x.^b; % will work for array x's
% powerlaw_f(5,3)
% powerlaw_f([1:5],3)

% anonymous functions are very useful for solving simple math problems,
% defining errors in custom curve fitting, or anything else you can fit on
% one line

%% local functions (subroutines)
% Normally a .m file contains a single function, defined on the first line,
% that's called when you type in the name of the file. Likewise a script
% contains code that is run from the top when you call the name of the
% file. But both types of .m file can host additional functions defined
% below the main code: these additional functions are only available to
% other functions within the same file, or while running code from the same
% script. For this reason I call them "subroutines" though Mathworks does
% not use this term and calls them "local functions".

% It is a good idea to give them a name like "my_somefunction" or
% "local_somefunction" that makes it obvious that the code for it should be
% found in the same file and not elsewhere in the search path.

% Here's a call to a local function defined at the end of this script. If
% you "Run Section" on this code block it will work. Entering the function
% name on the command line or "select and run" won't work.
my_celtics_championships(2024)

% Whenever there is more than one function in a file, each function's
% definition must end with an 'end' statement. This is not required in .m
% files defining a single function.

%% local functions CANNOT see variables in the workspace of the main
% function or script: just like functions defined in a separate file they
% typically only know what is passed to them.
my_powerlaw([1:4],4) % raise a series of numbers to some power

% using a local function in a .m file you've made can make your scripts
% easier to read, and can reduce the dependency of your code on other
% functions. For example, the Greytak lab toolbox "matlab-abs-emis" has a
% Simpson's rule integration function for general use, but in some other
% cases where I wish to use Simpson's rule integration to calculate a peak
% area etc, I copy the code into a local function local_simpson that I'm
% sure will be available.

%% variable scope
% A variable's scope means the range of code from which it is visible.
% Matlab purposely restricts the scope of most variables to the workspace
% in which they are defined: scripts operate in the 'base' workspace that you
% see, functions operate in their own workspace while they are running and
% you pass the values of variables to/from them. There are exceptions!

% You can purposely assign variable values in a different workspace. The
% most common use is to assign a variable in the 'caller' workspace: the
% workspace of whomever has called the function we are in now. You can also
% assign in the 'base' workspace regardless of where you are in the code.
% like this: assignin('caller','variablename',variablevalue)
% I created an example that assigns a value for Planck's constant:
assign_h('eV-s')
assign_h('J-s')
% Check out the .m file to see how it works. Try making it also assign
% Boltzmann's constant kB in the matching energy units.

%% You can use global variables to share data among different functions. 
% The variable must be declared as global before you use it in each
% function or script where it appears. Global variables should be used
% rarely, but can be useful for timing flags, and for keeping track of
% "objects" associated with ActiveX controls, data acquisition, etc.

% Uncomment the following code and run this cell. The use of a function
% handle here will let us call my_powerlaw_global from the command line,
% even though we can't normally do that with a local function defined in a
% script:
global b;
b=2;
powerlaw_f=@my_powerlaw_global;

%% Now run the following things (via the command line or select-and-run):
powerlaw_f([2:5]) % will give squares with global variable b=2
% update value of b and try again 
b=3;
powerlaw_f([2:5]) % should give cubes

% This is a neat demo, but also illustrates the problem with global
% variables: they could change without warning if you reuse the name in
% some remote part of the code.

% A special kind of "global variable" are Matlab preferences, which can be
% set and read using setpref and getpref -- doc setpref for more info

% The next exception is nested functions, which deserve their own segment
% here.

%% nested functions
% It's possible to define a function *inside* of another function (that's
% defined in a .m file), instead of listing it afterward. This is called a
% "nested function" and it has the special property that a nested function
% can see all variables in the workspace of the enclosing function.

% We usually use this in one of two ways: you can use a nested function to
% solve some part of a problem, often one that requires iteration in a way
% that is difficult to achieve with a simple loop.

% Also, it is actually possible to declare a function handle that points to
% a nested function, and then pass it back to the user as an output
% argument of the main function, and all the info the nested function needs
% to run (code, parameters) is baked into that function handle and remains
% usable after the main function has completed. This is very powerful
% because it lets you build functions with customized parameters.

% We will look at two examples built around quadratic functions.
a=-1;
b=4;
c=0;
% The following function, defined in a .m file in which you will need to
% edit and uncomment some code, will return the maximum value of a
% quadratic function defined using the three input arguments as
% coefficients: y = a*x^2 + b*x + c
peakval=max_quadratic(a,b,c)
% once you've fixed max_quadratic, try calling it with different values of
% a, b and c so you can see it works

%% Now an example where we get a function handle returned to us 
% get_quadratic will build you a function that calculates y for any value
% of x, using the input arguments as the coefficients:
a=-1;
b=-1;
c=0;
qf=get_quadratic(a,b,c)
% This function is already built for you and should work. Open the code
% to see what it is doing.

%% Trying out the function handle we got from get_quadratic
qf(1) % should give value of y = a*x^2 + b*x + c when x=1
qf(2) % should give value of y = a*x^2 + b*x + c when x=1
a=2;
b=2;
c=1;
qf(1) % should give the same value as before even though a, b, and c have changed in our workspace
qf2=get_quadratic(a,b,c)
qf2(1) % we've built another instance of the same function, with the new parameters
qf2(2)

% The following will fail because the nested function was not written to
% accept array inputs for x. Can you fix it?
qf([1 2 3]) 

% Interestingly, if you fix the code, qf will immediately be able to accept
% array inputs and give the desired values, still using the values of a, b,
% and c we gave when we created it in the first place. The function handle
% you get is a combination of the code in the nested function (which Matlab
% still needs access to) and a 'static workspace' attached to the function
% handle that contains the values for any variables that were set outside
% of the nested function and that it will need access to.

% The nested function in the above example was very simple: we could have
% implemented this more rapidly using an anonymous function handle (try
% it?). But the nested function approach can be applied to much more
% complicated functions, such as calculation of an ITC isotherm for a set
% of thermodynamic parameters.

%% local function definitions
function out=my_celtics_championships(year)
switch year
    case {1957 1959 1960 1961 1962 1963 1964 1965 1966 1968 1969 1974 1976 1981 1984 1986 2008 2024}
        disp(['The Boston Celtics were NBA champions in ' num2str(year)]);
    otherwise
        disp('The Celtics did not win the championships that year.');
end % end of switch statement
end % end of function definition

function out=my_powerlaw(x,a)
    out=x.^a;
end

function out=my_powerlaw_global(x)
    global b;
    out=x.^b;
end

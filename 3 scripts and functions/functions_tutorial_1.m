%% Tutorial on functions in matlab (part 1)

% The simplest way to use Matlab is to enter commands in the command
% window. However, most of the time, in order to be able to reproduce or
% share what you did (and correct your mistakes), you will want to write
% commands into a .m file with the editor. 
%
% The simplest way to use these is to run a script interactively, a cell at
% a time, as you've been doing in this tutorial.
%
% However, often you will want to be able to write a series of commands, a
% program, that do something useful with your data or instrument and that
% you don't have to edit all the time. You can do this with scripts and
% functions. 
% 
% Scripts are pretty simple, but there are lots of ways to define and use
% functions in Matlab.

% Before starting this tutorial, clear your current workspace using one of
% the following:

% clear  % by default only clears variables
% clear functions % this will clear cached function definitions as well
clear all  % this will clear both

%% running scripts
% You can run an existing script that is in your current directory (shown
% in the "Current Folder" window in the Matlab layout, or returned by the
% 'pwd' [print working directory] command), or elsewhere in your Matlab
% search path (more on this later), by simply typing the name of the
% script. You don't need to include '.m'. It is clearer to readers if you
% write 'run scriptname' instead, and if you do that, you can also run a
% script that's not in your current path by specifying its complete
% pathname.
% 
% I've already written an example script called hello_world.m You might
% want to open it in the editor and look at the code before you run it

% uncomment and run one of the following
% hello_world
% run hello_world

% Here's how you would run a script that's not in your path:
% run 'C:\Users\andrew\Documents\aaa_svn\matlab-sandbox\andrew\tutorial\3 scripts and functions\hello_world.m'

% When you run the above, you should see:
% - a text announcement in the command window
% - two variables, and integer 'cat_paws' and a random number called
% 'a_random_number' show up in your Workspace

% The commands in the script run in your Workspace: all the variables you
% have defined are visible to the commands in the script, and any variables
% it creates remain after it has completed. 
% It runs ALMOST as though you typed the commands in yourself, but (1) it
% does not show the commands in the command history and (2) if the 'return'
% command appears in the script, it immediately stops execution and quits.

% The demo script I gave you is a little bit fancy: it checks to see if
% 'cat_paws' already exists as a variable. If it does, it quits with
% 'return' and does not set a new value for either of the variables.
% Try it: if you run it a second time, it will print a Warning, and the
% value of the random number won't change. Then, type 'clear', and run it
% again. Now, it won't print the warning, and will set new values,
% including a random number that's probably different.

%% function in .m file simple example and exercise
% It is often more convenient to use a Matlab function: a bit of code that
% (usually) accepts an input and (usually) generates an output, but
% operates in its own workspace and does not know or care about the other
% variables you've created. This is the behavior of a function. It is also
% the behavior of Matlab commands (many of which are defined as functions)
% and you will call your custom functions in much the same way as you call
% Matlab commands. Functions are a central concept in computer science, and
% Matlab has many ways to define and use them.

% Here we'll start with the simplest approach which is to define a function
% in a .m file.

% You create a function .m file by making a .m file with the name you want
% the function to have, and writing a 'function' command at the top. Each
% .m file will typically only define ONE function that can be called
% externally (local subroutines and nested functions are described below).

% The first line of 'ev_demo.m' is as follows:
% function out=ev_demo(nm)

% Here, 'out' is a variable whose value will be returned (you could call it
% anything) when the function is called, 'ev_demo' is the name of the
% function (should match the filename), and 'nm' is to indicate that this
% function takes exactly one input variable, and its value will be given to
% 'nm' within the function.

% This demo function converts a photon wavelength (in vacuum) in nm to the
% corresponding photon energy in electron-volts. Try it:
% ev_demo(500)  % returns about 2.48 (eV)
% ev_demo(600)
% ev_demo([500 600])
 
% Now take a look at the code. The expression to do this
% is E=h*c/lambda but we need to be mindful of units. Also, note that the
% function does an elementwise division (./) This means that if you enter a
% vector or matrix of wavelength values, it will do the calculation for
% each one in turn and return an array of the same size. In Matlab, you are
% strongly encouraged to write functions this way (to work on vector or
% array inputs), rather than having to write a loop to call the function
% separately on each element.

% But also, note that variables h, c, and lambda that were created within
% the ev_demo function DO NOT appear in your workspace when you run the
% function. And even if you have a variable called h or c defined already
% in your workspace, ev_demo won't touch them: they are created in the
% function's own workspace and are destroyed when it finishes running. More
% on variable "scope" later.

% NOW TRY writing a similar function called wavenumber that returns the
% wavenumber in cm^-1 for an input as a wavelength in nm.



%% conditional statements: if/else
% An essential part of programming is conditional statements: you control
% whether code is run or not depending on a logical test.

% Conditional statements in Matlab include if, else, while, for,
% switch/case, and try/catch. These usually require an 'end' statement to
% conclude the code block.

% for the logical tests, "An expression is considered true if the real part
% has all non-zero elements"

% examples
x=5;
if(x<7) 
    disp('Your value of x was less than 7')
end

% You don't need the () but I like it for commonality with other languages
% like C. Below works, but is harder for people to read/debug:
if x<7 disp('Your value of x was less than 7'), end

x=5;
if(x<7)
    disp('Your value of x was less than 7')
else
    disp('Your value of x was not less than 7')
end

x=5;
y=7;
if(x==y) % Only use == with values known to be integers, use <, <=, for doubles
    disp('You got it right!!')
elseif(x<y)
    disp('Your value of x was too low')
else
    disp('Your value of x was too high')
end

x=5;
y=7;
if(x>10 && y>10)  % Use && for logical and
    disp('You like big numbers')
end
if(x<0 || y<0)  % Use || for logical or
    disp('No negative numbers, please')
end


%% conditional statements: while
% Matlab has two types of loops: for and while

% while runs the code continously as long as the logical test is true.
% The test is made before the code block is run each time
x=0;
while (x^2<24)
    disp([num2str(x) ' squared is ' num2str(x^2)])
    x=x+1;
    disp('Keep going')
end

% The code above displays 'Keep going' after saying x^2 is 16, even though
% by the time it says that, x=5 and so x^2 is not less than 24. If you want
% to break out of a loop partway though, you can use a 'break' statement
% that immediately jumps out of the current loop:
x=0;
while (x^2<24)
    disp([num2str(x) ' squared is ' num2str(x^2)])
    x=x+1;
    if(x^2>24)
        disp('STOP!')
        break
    end
    disp('Keep going')
end

% For cases like the one above, where we are essentially running for a
% certain number of times or until a variable reaches a certain value, it's
% often simpler to use a for statement as described below. However,
% while statements can be very useful in watching for elapsed time or for
% checking the condition of a global variable
t1=tic;   % this command starts a stopwatch timer that you can check later
while(toc(t1)<1.0)   % check elapsed time since t1 was started in seconds
    fprintf(1,'.');   % fprintf is a fancier way to output text than disp
    pause(0.1)  % pauses for the specified time in seconds
end
fprintf('\r')  % print a "return" (new line)


%% conditional statements -- for
% A for statement is used when you want to iterate a value -- execute the
% loop once for every member of a list. (This is a bit different than how
% for statements work in C)

% Firstly, remember that many Matlab statements work on array inputs and
% it's easy to use the : command to generate lists:
a=[1:5].^2
a=[5:5:20].^2
a=[4:-1:-4]
a=[4:-1:-4].^2
x=linspace(0,2*pi(),100)
plot(x,sin(x))

% but sometimes you want more control, and a for statement is needed
x=linspace(-1,1,100)
figure(1);clf
for(a=0:4)
    plot(x,x.^a)
    ylim([-1 1])
    xlim([-1 1])
    title(['y=x^' num2str(a)])  % Matlab will interpret ^ as superscript in title string
    pause(1.0)
end
% Run this code. Try changing for(a=0:4) to for(a=0:2:4)

% Note that in programming, people frequently use i or j as indexes for for
% statements, but this isn't great in Matlab since it uses i for the
% imaginary number (and uses j for that too, which engineers do for some
% reason). You can still use them, because Matlab lets you overwrite
% command names (more below), but it isn't good practice. Or, use j and k,
% but leave i alone.

% The values given to the interating variable in a for statement don't have
% to be a simple series. It can be any list of numbers or a cell array:
for(animal={ 'cat' 'dog'}) disp(animal), end
for(animal={ 'cat' 'dog'}) disp(cell2mat(animal)), end

% logical tests, and logical addressing, is very useful here:
xvals_available=1:10;
for(x=xvals_available(xvals_available<5)) 
    disp(x)
end
% to see what's going on above, try selecting just the argument to the for
% statement and running that: x is a list of only those values of
% xvals_available that pass the test

% This will pick out only even values of xvals_available
for(x=xvals_available(mod(xvals_available,2)==0)) 
    disp(x)
end

% This will pick out only odd values of xvals_available: ~ is logical "not"
for(x=xvals_available(~mod(xvals_available,2)==0)) 
    disp(x)
end

%% conditional statements -- switch
% A 'switch' statement considers several tests for a variable, and runs the
% 'case' that matches. Optionally, you can include an 'otherwise' block for
% anything that doesn't match

% example with numerical value
a=5;
switch a
    case 5
        disp('you guessed 5')
    case 7
        disp('you guessed 7')
    otherwise
        disp('guess again')
end

% even more useful with strings
element='hydrogen';
switch element
    case 'hydrogen'
        disp('Element 1')
        disp('Mass usually 1')
    case 'helium'
        disp('Element 2')
        disp('Mass usually 4')
    case 'carbon'
        disp('Element 6')
        disp('Mass usually 12')
    otherwise
        disp('I do not really know that much chemistry')
end


%% the matlab search path
% When you type a word in Matlab, it has to decide if it's a variable, a
% builtin command, a function you defined, etc. 
% 
% It follows a logical progression:
% - if it is defined as a variable or function handle (see below) in the
% current workspace, it uses that
% - if not, it looks to see if there is a .m file in the current directory
% with that name
% - if not, it searches your Matlab path to look for a .m file with that
% name. Your Matlab path, which you can see if you type 'path', is a list
% of directories to search in, which includes a bunch of folders for the
% built-in functions and Mathworks toolboxes.
% - The 'path' is searched from top to bottom, and your personal Matlab
% startup directory (Documents/MATLAB on Windows) normally appears at the
% top
% - If you set up the Greytak lab Matlab custom toolboxes, the 'functions' folders
% for each toolbox will be added to the top of your path, so it will look
% there first. 
% - If the word does not exist as a .m file anywhere in your path, then it
% will see if it is a Matlab builtin command
% - If it still hasn't found anything with that name, it will give an
% error.

% In this way, Matlab will, by design, allow you to override the
% definitions of existing commands, with a few exceptions (you can't rename
% 'if' or various other conditional statements, for example). They use this
% with their own toolboxes: If you don't have the symbolic math toolbox,
% 'diff' takes the difference of neighboring values in a vector. If you do
% have the symbolic math toolbox, 'diff' can be used with a string input to
% to differentiation of a function, but also reverts to the earlier
% behavior if the input is a vector.

% To see which version of a variable, function handle, or function is being
% used, use the 'which' command
clear
which pi
sin(pi/2)
pi=3; % we just re-defined pi!
sin(pi/2)
which pi
% but we didn't destroy it:
clear pi
which pi
sin(pi/2)

% When collaborating with other people and you might have several folders
% in your Matlab path that could contain custom functions, it can be
% helpful to check which version you are running, especially if things are
% behaving strangely.
which ev_demo

% You can also use the 'which' command to check if some name already exists
% before you choose to use it for your own function
which image  
% this already exists! In general, try to avoid making a variable or
% function with a name that is already used, to avoid confusion; the
% exception being if you want to try your own modification of one of our
% group's functions, perhaps, but even so you should probably either add
% your changes to the group's version (perhaps via a branch in source
% control) or make a special version with a different name just for you.

%% variable input and output arguments
% Sometimes you want to have optional input or output arguments for a
% function. 
ones(3) % generates a 3x3 square matrix of ones
ones(3,2) % generates a matrix of ones with 3 rows and 2 columns

% Let's see how to run a command with multiple output arguments: 
x=10*rand(1,5) % get a row vector of 5 random numbers
% with one output argument, max gives the maximum value of x
x_max=max(x) 
% with two output arguments, separated by comma, first is maximum value,
% second is the index of x that had the maximum value:
[x_max,xmax_idx]=max(x) 
% check
x(xmax_idx)

% You can make your own functions do this using varargin and varargout
% I started to set up an example with varargin in photon_energy.m, where
% the user will be able to choose whether it should output the photon
% energy in eV or in wavenumbers (wave per cm, cm^-1) for an input
% wavelength in nm.
% Try uncommenting/editing code so you can do:
% photon_energy(500,'eV')
% photon_energy(500,'wavenumber')
% and it will error out if you do:
% photon_energy(500,'joules')

% note: disp() displays a text notification, warning() displays a text
% notification in orange but the program keeps running, and error()
% displays a text notification in red and stops the program. 

%% in the next segment we will talk about:

% variable scope

% function handles

% inline function definitions

% anonymous functions

% subroutines

% nested functions

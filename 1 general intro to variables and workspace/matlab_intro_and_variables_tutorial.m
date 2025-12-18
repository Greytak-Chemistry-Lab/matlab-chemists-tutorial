% variables in Matlab: types and arrays
%
% A script template for the Greytak lab's Matlab tutorial

% Matlab is a computer interface for mathematical calculations (especially
% matrix math and related discrete mathematics), a plotting program, and a
% computer language.
%
% You can interact with it by entering commands one at at time via the
% command line (command window), by running a list of commands saved in a
% text file (a script), or by defining a new Matlab function containing one
% or more commands and then calling that function. Functions can be defined
% in a text file, or defined within a command. We will learn more about
% functions later. Scripts and functions live in text files ending in '.m'.
% As these are just text files, you can open them in the Matlab editor, but
% also in any other text editor such as Notepad, Notepad++, or VSCode.
%
% It is also possible to save Matlab variables in a .mat file. These are
% binary files, and are only readable by Matlab. (Examples below)
%
% This file is a .m file and is a Matlab script, but rather than run the
% whole thing you will probably want to use it by uncommenting and/or
% modifying the example commands below, and then either selecting them and
% running just the selection (press F9) or copying and pasting them to the
% command window.
%
% Generally each line of code (ending in a return) will contain a single
% command. You can suppress the output of a command by entering a ';' at
% the end. It is technically possible to enter more than one command on
% a line by separating them with ',' or ';', but this makes your code
% harder to read. Matlab mostly does not care about 'white space' but it is
% common to indent code within a conditional statement or a loop, and I
% personally like to add spaces around '+' and '-' in math expressions to
% make it easier to see what I'm doing.
%
% Comments are indicated by the % symbol. A double %% at the start of a
% line indicates a "section break" and you can easily run one section at a
% time in the Matlab interface. However, for simplicity, we will not use
% section breaks here. You can also use ... to continue a statement on the
% next line, and everything after ... will be considered as a comment
%
% For brief help on a command, type 'help command' in the command line. For
% custom scripts or functions that you've made, this will print the comment
% block at the top of the file. For more detailed help, type 'doc command'
% which will bring up the Matlab help center. Try it below!
%
% In our lab, we also have a Matlab reference book for Version 7 (still
% pretty good), and an electronic reference book for Version 6 (I think,
% which is somewhat outdated and doesn't include some current function
% capabilities)

help sin
doc sin
help variables_demo

% Now try using some commands
5+5
5^3

% Matlab knows about order of operations
5^3/2 
(5^3)/2 % This is still easier to read for later
5^(3/2) % if this is what you meant to do

% sqrt is a matlab command (a built-in function): The arguments for a
% command go in parentheses
sqrt(2) 

% 'pi' is a matlab command that returns the value of pi. I always like to
% write it as pi() to emphasize that I am using 'pi' as a command with no
% arguments, not a variable.
pi() 
sin(pi()/2)  % trig functions are normally in radians: use sind for degrees

% Matlab (the MATrix LABoratory) knows about matrix math
% a row vector with two components
[2 5]

% two column vectors: the ; separates row in a matrix, ' transposes
[2 ; 0]
[2 0]'

% let's take the dot product (inner product)
[2 5]*[2 0]  % this will generate an error
[2 5]*[2 ; 0] % this will work and give the scalar result we wanted
[2 ; 0]*[2 5] % this gives the 'outer product': order matters for matrices

% you can do elementwise math by putting a . before most operators:
[2 5].*[2 0] % multiplies each element together for two matrices of equal size
[2 5]*2  % you can always multiply by a scalar
[2 5]^2  % will fail, you can't square a vector
[2 5].^2  % squares each element
[2 1 ; 1 2]^-1  % you can raise a square matrix to a power: here, invert it

% many matlab commands are designed to accept arrays (vectors and matrices)
% as inputs
mean([2 5 9]) % takes the average
sin([0 1 2 3 4 5 6 7 8]*pi()/4)  % takes the sin of each value

% Iteration operator ':' lets you specify a list in shorthand
[0 1 2 3 4 5 6 7 8]  % enter a list manually
[0:8]   % values spaced by 1 by default
[0:1:8]  % does the same as above
[0:2:8]  % increment by 2 from the initial to the final value
[0:-2:-10] % increment can be negative
[0:8]'   % if you wanted a column vector
sum(1:100) % add up numbers 1 thru 100

% linspace command automatically generates a series of evenly spaced values
linspace(0,10,11) % generate 11 values evenly spaced between 0 and 10
sin(linspace(0,8,9)*pi()/4)

% make a plot
% without getting too far ahead, we can use this approach to easily plot a
% result
plot(linspace(0,8,101),sin(linspace(0,8,101)*pi()/4))

% VARIABLES 
% You're going to want to save results and access them later and
% for that we use variables. You've already seen the variable 'ans' that
% holds the result of a command you just entered, if you didn't end it in ;
% 
% Define them with =
a=5;
% You can see variables you've defined in the Workspace. Unlike in C, you
% usually don't have to declare variables and their types before using
% them.

% Three things to know are variable type, variable size, and variable scope

% Variable TYPE is, what type of data does it contain. This affects what
% kinds of functions or math operations can use it
% 'double' (double precision floating point) = default and most common type
a=5;
% doubles can be integers, non-integers, positive, negative, or complex
a=sqrt(-2)

% 'logical' values can only be 0 or 1, and show up as the results of
% conditional tests. We also use them for logical addressing, and for a
% number of steps in image processing
5>2 % ans will be a logical 1
results=[4 5.5 6 7]>5  % applies test to each element
results=[4 5.5 6 7] == [4.4 5 6 8]  % == to test equality, = to define
results=[4 5.5 6 7] > [4.4 5 6 8] 

% integer data types can only hold integer values, are signed (can be
% negative) or unsigned (can only be 0 or positive), and have a defined
% number of binary bits used to store them. We most often encounter them in
% the context of image data, which is frequently defined as a matrix of
% unsigned integer values (type uint8: 0 to 255 or uint16: 0 to 65535
test=[-4 4 5.2 6 7]  % will create test as a vector of doubles
test2=uint8(test)  % this will "cast" test as unsigned 8-bit integer 

% In many cases you can cast one type as another, sometimes necessary:
results=[4 5.5 6 7] > [4.4 5 6 8] 
sin(results) % fails
sin(double(results)) % succeeds

% Strings are arrays of type 'char' (character)
name='Andrew'
class(name) % 'class' command called this way will return the variable type

% There are many more complex data types, such as structures, function
% handles, and objects. Struct's have several fields, identified by field
% names, that may each be of (nearly) any type:

% you can define a struct with the struct command:
student1_info=struct('name','Andrew','major','Chemistry','year',2000)

% but you can also just start defining or adding field names. You'll
% address these with the variable name, '.', and the field name:
student2_info.name='Hilary';
student2_info.major='Chemical Engineering';
student2_info.year=2000;
student2_info  % will display the current value of each field

% Variable SIZE refers to the ability to create an array of variable
% values, and then address any element(s) of that array using the
% appropriate index, or indices for multiple elements.

% In simple arrays, all elements have the same type, and for certain types,
% you can do math on them including matrix operations
a=[2 5]
b=[2; 0]
c=a*b

% An array can have any number of dimensions. To see the size of an array,
% use the size command. For 2-dimensional arrays, size will show the number
% of rows first, number of columns second:
size(b)

% You can address elements of a simple array using parentheses. VERY
% IMPORTANT: in Matlab, unlike most computer languages, the first index is
% 1, not 0. This is because Matlab is designed for matrix math, and the
% first element is on the 1st row or column of the matrix.
b(1)
b(2)
b(0) % gives an error

% For a 2-D array, the first number is the row, second number is the
% column:
a=[2 4 6 8]';
b=[3 5 7 9]';
c=[a b]  % this concatentates (connects) two column vectors to get a matrix
c(2,1) % returns 4

% You can use the : operator within an index to pull out a row or column:
c(2,:) % gets the second row
c(:,2) % gets the second column

% the 'end' operator gives the last available index in that dimension
c(2:end,1)  % second thru last element of 1st column
c([2 3 4],1) % get the same result manually

% Linear addressing: even for arrays with more than 1 dimension, you can
% choose to address elements with a single index. This is 'linear
% addressing' and will read down each column, for each row, in that order
c(4)
c(6)
c(:)

% Logical addressing: instead of passing the index numbers, you can pass an
% array of logical values (0's and 1's) that has the same size as the array
% you're interested in. This is especially useful in selecting just those
% elements whose values pass some logical test. Logical addressing can also
% be done using a vector of logical values with the same total number of
% elements as your array. In either case, what is returned is simply a
% column vector of values; the dimensions of the original array are
% ignored.
my_logical_array=c>4
c(my_logical_array)

d=c;
d(d>6)=6; % set all values larger than 6 equal to 6
disp(d)  
% I used the disp command to display a variable value: more elegant than
% simply not putting a ;

% consider you have some assignment scores and want an average for all the
% ones that aren't zero:
scores=[76 79 83 77 95 89 0 67 0 81];
mean(scores)
mean(scores(scores~=0)) % ~ is the logical not operator, ~= is not-equal-to 

% find will return the indices for which a logical result is true
find(scores==0) 
c>4  % gives a logical array the same size as c
find(c>4) % but this only gives the linear index values

% If you just want to determine if there are any elements that aren't zero, you
% can use the 'any' command. It will produce a logical 1 (true) or 0 (false) if 
% there are any non-zero elements.
% try:
any(scores)
any(scores>90)

% All elements in an array have to have the same data type. You can make an
% array of structs, but they all have to have the same field names and in
% the same order:
student_info=[student1_info student2_info]
student_info.year  % this actually works to show the year field for each element
student_info(1).name % how to access a field from just one of the elements

% It is also possible to make a CELL ARRAY. These are able to accommodate
% any data type in any element, but addressing is done in curly braces and
% there are limitations on what functions/operators will work on a cell
% array:
silly_cell_array={ 'Andrew' 2000}
silly_cell_array{1}
silly_cell_array{2}

% Variable SCOPE
% The scope of a variable refers to the range of places within Matlab from
% which it is accessible. Matlab refers to 'Workspaces'. When you define
% variables on the command line or in a script, they appear in the home (or
% root) workspace and are visible to, and vulnerable to being overwritten
% by, any other commands that are run in the same workspace.

% Functions usually have a separate workspace. They cannot normally see the
% info in your home workspace, and any variables they created within their
% own workspace are destroyed when the function exits. You can get around
% this, if you need to, with the assignin command, which lets you assign
% variables in a different workspace:
% example:    assignin('caller','h',6.6261e-34)

% You can also use global variables that are accessible to all running
% Matlab scripts and functions. These you need to declare at the top of any
% function or script that is using them, like so:
global moving
moving=0;
% It's good practice to limit your use of global variables, and only use
% them when they offer a lot of value (for example, in some timer callback
% functions)

% Clearing variable
% The 'clear' command will clear all variables: be careful, as it won't warn
% you before doing so. You can clear specific variables by name:
clear silly_cell_array

% Some things are not cleared by default. To clear global variables you
% need to explicitly say so:
clear global moving
% clear global % would clear all global variables
% clear all % would clear an even larger number of data types
% check 'doc clear' for more info

% Check out the exercise for calculating the pressure of a van der Waals
% gas in this folder.

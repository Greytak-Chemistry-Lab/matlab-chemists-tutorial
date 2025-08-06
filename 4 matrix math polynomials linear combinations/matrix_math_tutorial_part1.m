%% matrix math tutorial: linear combinations, polynomial fits: part 1
% Matlab is the "Matrix Laboratory": It is designed to do matrix math
% quickly and easily. This includes things like matrix multiplication,
% inversion, transpose, inversion, determinants, eigenvalues, but there are also a number of
% commands for assembling and manipulating matrices including 'reshape',
% 'flipud', and so on.

% A very powerful feature of Matlab is that overdetermined matrix math
% calculations automatically give a least-squares solution. This makes it
% easy and very fast to do certain kinds of curve fitting, in particular
% determining a polynomial fit function for experimental data, and fitting
% a curve with linear combination of known components. The second case
% comes up frequently in interpreting NMR and UV-vis spectra of samples
% containing two or more chemical components with known reference spectra.

% Before beginning this tutorial, read (and try out the simple examples in)
% the accompanying "matrix_math_polynomials_linear_combinations.pdf" guide,
% which is found in this folder. That document is prepared in LaTeX, which
% is a markup language that's very useful for making publication-quality
% documents with mathematical and chemical schemes. I've included the
% source code (.tex file) in case you would like to inspect it and learn
% more.

%% matrix math demo:  multiply out
% Consider a square matrix:
%     1.0000    0.1000
%    -0.1000    1.0000
% and a vector:
%     10        20

% Write matlab expressions to calculate the two matrix multiplication
% products that are possible with these matrices. For matrix
% multiplication, the number of columns in the first matrix must equal the
% number of rows in the second matrix. You may have to transpose the vector
% (use ') to make it a column vector when it appears second. 

% Now calculate and display the inverse of the square matrix by raising it
% to the -1 power. (Matlab uses ^ for exponents). Check that you get the
% identity matrix (diagonal set of 1's with all other elements 0) when you
% multiply the square matrix by its inverse.

% now see if you can mutliply the inverse of the square matrix by one of
% the answers you got for multiplication with the vector to obtain the
% original vector. Extra challenge: see if you can do this using left
% divide (\) instead of inverting the square matrix.


%% polynomial plots and fits via matrix multiplication: linear example
% A polynomial function (a linear function being the simplest) can be
% represented by matrix multiplication. When you plot some polynomial y as
% a function of x, you are using the same small set of polynomial
% cofficients to multiply the various powers of x, at every value of x.

% Let's define a set of x values:
% x=linspace(-2,2,16);
% x=reshape(x,length(x),1);  % ensures that we have a column vector
% disp(x)

% Now let's plot y = 0.5*x + 0.75. At every value of x, we must multiply x by
% 0.5, and then add 0.75. We can do this with a matrix expression. We make
% a matrix where there is a row for each x value, and in each row x appears
% raised to a different power in each column. Here, the first column has x
% raised to power 1 (so, just x) and the second/last column has x raised to
% power 0 (so, just a 1 in every row).
M=[x ones(size(x))];  % makes clear to novices what you are doing
% M=[x x.^0 ];  % a more concise way to obtain the column of 1's.
A=[0.5 0.75]' ; % column vector of coefficients
disp(M)
disp(A)
y=M*A; % matrix multiplication
disp(y)
figure(1); clf
plot(x,y,'ks')
xlim([-2 2])
ylim([-2 2])

%% a quadratic function: plot y = x.^2 - x - 1
figure(2); clf
% Write out what you need here:
M=[x.^2 x.^1 x.^0 ];
A=[1 -1 -1]';
y=M*A;
figure(1); clf
plot(x,y,'ks')
xlim([-2 2])
ylim([-2 2])

%% recovering polynomial coefficients with matrix division
% If you have the y values and x values already, and they all satisfy the
% polynomial equation, it should be possible to solve for the polynomial
% coefficients. If we had 3 data points for a quadratic function (with 3
% coefficients), there will always be exactly one quadratic function that
% fits all 3 perfectly. 
% 
% Also, the matrix M will be square, and so it seems you could just solve
% for A as: A = M^-1 * y 
% 
% But we have 16 x values, so M is a 16x3 matrix. Taking M^-1 will give an
% error in this case. But Matlab WILL allow you to do a matrix division
% with M on the left side, and when you do so it will give you the
% least-squared-error solution (see the PDF):
% B=M\y;  % left divide: can also write as mldivide(M,y)
% disp(B)
% You should find that B is the same as A defined above, since in this case
% the data exactly corresponded to the function.

%% Adding noise: illustration of least-squares solution
% Now let's add noise and do a polynomial fit.
rng('shuffle'); % initializes random number generator with random seed
noise_level=0.5;
y_noisy = y + noise_level*( -0.5 + rand(size(y)) );
figure(1)
hold on
plot(x,y_noisy,'r+')

% get coefficients for least-squares fit of noisy data
% B=M\y_noisy;
% disp(B)

% plot the fit function
% y_fit=M*B;
% plot(x,y_fit,'r-')  

% The coefficients in B are slightly different that what we specified in A
% due to the noise. Try re-running this cell to get B with a different set
% of random noise contributions.

% Because they can be calulated quickly and the functions are easy to
% understand, linear and polynomial fits are widely used, especially if the
% actual physics of the problem being studied is not known. An exercise is
% provided 'polynomial_fit_intensity_profile' in which you will use a
% linear or quadratic fit of background levels in a curve, in order to
% obtain an accurate value for the area of a peak above that background.


%% Linear combination fits: moved to part 2


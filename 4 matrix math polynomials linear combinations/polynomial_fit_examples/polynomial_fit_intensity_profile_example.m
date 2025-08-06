%% polynomial fit example: fit background for intensity profile
% Use a polynomial fit to model the background level of an intensity profile

% Often we are interested the area of a peak in some signal above a
% background. We can estimate the background contribution from the signal
% level on either side of the peak. If the background isn't constant, we
% can try fitting it with a polynomial function.

% The data for this example is in intensity_profile_example_data.txt
% Load this data into two column vectors 'position' and 'intensity'
% I suggest using the "Import Data" wizard on the Home tab, but there are
% multiple ways you could do this.

% This data is an intensity profile from a microscope image. The 'position'
% is just the number of pixels along the profile (we don't actually need
% it), and the 'intensity' vector is our data.

%% plot raw data
% make a plot of intensity versus position. Choose a color for the line.
figure(1); clf
plot(position,intensity,'k')  

% use your judgement to choose a range of pixel positions that correspond
% to the peak. Make a column vector that contains only the pixel numbers
% corresponding to background. Use the iteration operator (:) to construct
% this. Remember that ' can be used to transfer a row vector into a column
% vector

background_pixels=[1:11 24:39]';

% now make a copy of the data that contains only the values corresponding
% to these pixels

background_intensity=intensity([background_pixels]);

% if you wish, you can make a separate plot of just the background points
% on the same or different axes
figure(2); clf
plot(background_pixels,background_intensity,'bs')

%% polynomial fit
% we need to construct a matrix of the x values raised to 0 and 1 power
% (for linear) or 0, 1, and 2 power (for quadratic)

%%%% linear
M=[background_pixels.^1 background_pixels.^0];

% Now, use left divide (\) to obtain best-fit polynomial coefficients

A=M\background_intensity

% Now, to see the fit, calculate the predicted background level at EVERY
% pixel location. 

background_fit=[position.^1 position.^0]*A;


%%%% quadratic
% your turn

%% Add the background fit to the plot
figure(1);
hold on
plot(position,background_fit,'b')
hold off

figure(2);
hold on
plot(position,background_fit,'b')
hold off

%% Plot background-substracted data and add up area
% Make a new figure on which you plot the difference between the data and
% the background calculated based on the fit
figure(3)
intensity_corrected=intensity - background_fit;  
plot(position,intensity_corrected,'r')

% To get the peak area, you can just add up the corrected intensity values,
% or use a simpsons-rule integration using the local function provided
% below.
peak_area1=sum(intensity_corrected)
peak_area2=local_simpson(position,intensity_corrected)

%% local functions
function a=local_simpson(x,y)
% Simpsons rule integration of y with respect to x
%
% Simpson's rule is the area under a linearly interpolated curve and is a
% good approach for integration of discrete data.
% A=SIMPSON(X,Y)
% Returns Simpson's rule integral of Y(X)dX
% See also qyplot

x=reshape(x,length(x),1);
y=reshape(y,length(y),1);

x=diff(x);
y=(y(1:end-1)+y(2:end))/2;
a=sum(x.*y);
end


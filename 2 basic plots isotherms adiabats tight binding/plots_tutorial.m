%% Intro to making plots in Matlab
%
% Tutorial on making plots using imported and calculated data sets

% Matlab has numerous tools for making plots and adjusting their
% appearance, including 2D graphs and 3D surface plots.
%
% This script will use Sections, which are separated by lines starting %%
% and you can run all the code in any Section by clicking "Run Section" or
% "Run and Advance" in the Editor menu bar.

% let's make some fake data
x1=linspace(0,5,21);
y1=x1.^2;
y2=x1.^3 / 5;
x3=linspace(-5,5,21);
y3=x3.^3 / 5;

% The plot command makes 2D graphs. You usually call it in one of 2 modes:

% triples of vector of x values, vector of y values, and a Linespec string
% Linespec is a code that tells what color and style to make the line: see
% doc plot for more info on Linespec
% plot(x1,y1)
% plot(x1,y1,'r') 
% plot(x1,y1,'r',x1,y2,'b') % overlay 2 curves
% plot(x1,y1,'r',x3,y3,'b') % overlay 2 curves with different x data
% plot(x1,y2,'r',x3,y3,'rs') % overlay 2 curves with different x data

% or, a vector of x values and matrix of y values, with each row
% corresponding to a curve you want to plot. Here the x values have to be
% the same, and one dimension of the y matrix has to be the same length as
% the x data
% plot(x1,[y1 ; y2])
% This is more concise. You usually don't specify the Linespec this way,
% but you can adjust the appearance of the plot after it is made.

%% figures and axes
% By default your artwork appears in the active figure window, or if none
% exists, it opens a new one. You can have multiple figure windows, so that
% you can update one without ruining others:
figure(2); 
clf % clf is "clear figure": clears existing content in fig 2
gcf  % will display current figure number and properties in command window
my_figure2=gcf;

% you can edit the appearance of a plot manually via the figure window
% (details change in every version of Matlab) or using commands, which is
% useful in a script so it appears the same way every time.

% plot creates a set of 'axes' within the figure
plot(x1,y1,'r')
xlabel('X')
% Matlab lets you use LaTeX-style markup to style text displayed in plots
ylabel('Y=X^2') 
gca  % will display a "handle" for the current set of axes, a data type you can use to refer to this set of axes later

% To put a plot in an existing set of axes, list axes first:
% ax1=gca;
% plot(ax1,x1,y1,'b')

% Even thought the plot command generates an "axes", the command returns a
% handle for the line, or an array of handles for the multiple lines, that
% it has created. You can use these to set properties later.
% ax1=gca;
% h1=plot(ax1,x1,y1,'b')
% set(h1,'color','k','LineWidth',2) % make line black ('b' is blue, 'k' black) and 2 points thick

%% If you run plot again, it writes over what you had, without asking!
plot(x3,y3)

% If you want a different figure, call the "figure" command to make another

% or, you can use "hold on" and "hold off" to add additional lines to
% existing axes

% plot(x1,y2,'r')
% hold on
% plot(x3,y3,'rs')
% hold off

%% set limits

% to get or set axis limits, use 'xlim' and 'ylim' commands. 
% It's really helpful sometimes to both get the current value if you just
% want to adjust the upper or lower limit
% ylim
% ylim([0 25]) % set min and max as a 2-element vector
% ylim('auto') % automatically covers your data range
% ylim([0 max(ylim)]) % I do this a lot

%% change axis mode

figure(2); 
clf

handles=plot(x1,y1,'r',x1,y2,'b');
set(handles,'LineWidth',2)
set(handles(2),'LineStyle','-.')
legend('square','cube/5')
% If you plot a power law function on a log-log scale you should be able to
% read off the exponent from the slope
set(gca,'YScale','log') % log scale
set(gca,'XScale','log')
axis equal  % forces equal X and Y scale on current axes, seems to not work right with log axis scale though
set(gca,'XGrid','on','YGrid','on')

% try again
% note that in Matlab, as in c, 'log()' does natural logarithm, 'log10()'
% for base 10 logs
% handles=plot(log10(x1),log10(y1),'r',log10(x1),log10(y2),'b');
% set(handles,'LineWidth',2)
% set(handles(2),'LineStyle','-.')
% legend('square','cube/5')
% axis equal
% set(gca,'XGrid','on','YGrid','on')
% Xlabel('Log X')
% Ylabel('Log Y')

% see doc plot or doc axes for help on all the various plot settings you
% can change

%% overlay plots

figure(3);
clf

% create axes objects
ax1=axes;
ax2=axes;
% create first plot on first set of axes
plot(ax1,x1,y1,'r')
% specify x limits to make sure they will be the same as for the next plot
xlim([0 5])
% create second plot
plot(ax2,x1,log(y1),'k.')
xlim([0 5])
% bring focus back to ax1 to adjust its appearance
axes(ax1)
set(gca,'Box','off','YColor','r') 
% 'Box' is whether ticks show up on opposite side, 'YColor' is color of axis and its labels
xlabel('X')
ylabel('X^2')
% bring focus to ax2 to adjust its appearance
axes(ax2)
set(gca,'Color','none','YAxisLocation','right','Box','off')
% 'Color' is the color of the plot background: want 'none' so we can see
% the other plot that's behind it. 
ylabel('Ln(X^2)')

%% Subplot
% subplot command makes a grid of plots

% figure(1);
% clf
% first number is rows, second is columns, 3rd is a linear index
% subplot(2,2,1) 
% plot(x1,y1)
% subplot(2,2,2)
% plot(x1,y2)
% subplot(2,2,3)
% plot(x3,y3)
% ylabel('X^3 / 5')

% you can go back and adjust panels individually by using the subplot
% command to bring attention to one of the plots. Just be sure to use the
% same number of rows and columns or it might redraw the whole figure and
% erase your work.
% subplot(2,2,1)
% ylabel('X^2')
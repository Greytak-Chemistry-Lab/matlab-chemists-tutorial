%% Tutorial on image formats and analysis with Matlab
% This tutorial require the Image Processing Toolbox

% Matlab has many capabilities for generating, displaying, analyzing, and
% saving images. We will learn about some of these tools, and we will also
% start with a few remarks about computer graphics in general.

% Image data can first be broken down into "vector graphics" (constructed
% as sets of lines/shapes defined by coordinates) and "pixel graphics"
% (described by a matrix of values that describe the intensity/color in one
% or more channels on an evenly spaced rectangular grid).

% Examples of vector graphics are the axes, labels and lines you make with
% the 'plot' command; artwork you make by drawing shapes in Powerpoint,
% Adobe Illustrator, or Inkscape; analog oscilloscope displays; and the
% original Asteroids arcade game. Vector graphics can be arbitrarily scaled
% and still look sharp, and require only a small amount of data for simple
% line art, but can be unwieldy for highly detailed artwork and are
% unsuited to describing images collected with a camera. Vector graphics
% can be stored in many custom or proprietary formats: examples of
% standardized formats are EPS (encapsulated Postscript) and EMF (Windows
% Enhanced Metafile).

% Examples of pixel graphics are digital photos, television and modern
% computer monitor displays, and so on. By convention, pixels are addressed
% by their X (horizontal) position with X increasing from left to right,
% and their Y (vertical) position with Y increasing FROM THE TOP DOWN
% (opposite of a typical graph: pixels with Y=0 is the top line of the
% image). In Matlab, in matrices describing image data, X position is the
% column number and Y position is the row number, and maticies are
% addressed as (row,column) so this will be like (Y,X).

% Within pixel graphics, there are several ways to represent images, and
% there are several file formats in which those representations can be saved.

% BITMAP: Black and white, every pixel is a logical 0 or 1, often used as a
% "mask" to indicate regions of interest in other images.

% Grayscale: Every pixel is an integer (usually 8-bit: 0 to 255, or 16-bit:
% 0 to 65535) indicating a (gray) value on a monatonically increasing
% scale. Often encountered for data collected from monochrome scientific
% imaging cameras, as a channel separated from a true color image, or as a
% "heat map" calculated to represent spatial variation of some value in
% data analysis or simulation.

% Indexed color: Similar to grayscale, but instead of directly representing
% an intensity value, each pixel value is translated to a particular true
% color using a "look-up table" (LUT). The appearance of the image can be
% changed by specifying a different LUT. Indexed color images are commonly
% used to represent line art (plots etc) where there are relatively few
% colors present in the image, because such images can be easily compressed
% with data compression (as is done in PNG and GIF images); to bring out
% greater contrast in experimental images (such as AFM, which commonly uses
% the 'hot' LUT); and to store "label images" for images of particles in
% which all pixels belonging to a particular particle are given the same
% index value. The lowest index is 0; images are commonly stored with 8-bit
% or 16-bit formats allowing many different color indices to be used,
% though only a few of them may be needed for a particular image. 

% True color: Attempts to represent full color by using 3 different values
% (channels) at each pixel. On computer displays, and as collected by color
% digital cameras, these channels are red, green, and blue (RGB, in that
% order), but it is possible to represent true color in other ways such as
% hue/saturation/intensity, CMY, etc. Matlab true color images are
% generally RGB, stored as a n x m x 3 matrix where n is the row (Y), m is
% the column (X), and the third coordinate is the channel index; the values
% can be floating point numbers between 0 (min) and 1 (max), 8-bit
% integers, or 16-bit integers.

% Formats: There are many formats for storing pixel graphics, and Matlab
% can read from most of them and write to many of them. Most-used are: 

% TIFF (.tif): Stores bitmap, grayscale, or true color images, usually without
% any compression (so, large file size). Can accommodate multiple images
% (slices) per file. 

% PNG (.png): Indexed color, with data compression (no loss of spatial
% resolution)

% JPEG (.jpg): True color images, with *image compression* (a Fourier
% transform based algorithm that results in some loss of spatial
% resolution, but can give much smaller file sizes for large images with
% lots of colors such as typical photographs). Intensity values are almost
% always sRGB encoded.

% "Camera Raw" (.CR2): "Raw" image format saved by Canon digital cameras;
% linearly encoded true-color sensor data can be obtained from it.

% As a scientist, you will use many other tools as well, and if you do not
% already have Image-J (a free Java program distributed by NIH, also
% re-packaged as "FIJI") installed, you should get it now! Consider also
% installing GIMP, an open-source, Photoshop-like tool. (You don't need
% either of them for this tutorial).

% This tutorial gives some examples of different image types, how to define
% colormaps and X and Y scales for images, and how to select regions of
% interest. The 'particle_analysis_basic.m' files goes into more detail as
% an example of analyzing the properties of particles in a microscope
% image (something we do a lot).

%% Show an image: true color
% Read a true color image from a file.

% The Image Processing Toolbox includes a number of example images that
% they refer to in their documentation, and you can load them also. In
% Windows they are found in:
% C:\Program Files\MATLAB\R2022a\toolbox\images\imdata

% try this:
% help 'C:\Program Files\MATLAB\R2022a\toolbox\images\imdata'

% The easiest way to load an image is with imread. Here, we will load one
% of the built-in images, which happens to be a true-color image. You don't
% need to change to the directory above: the following should just work.
builtin_image=imread('yellowlily.jpg');

% You can see the image is a 3-dimensional matrix of type uint8 (unsigned
% 8-bit integer: each element can take an integer value 0-255)

%% 'image' command
% There are several ways to display images in Matlab. The most basic is the
% 'image' command (doesn't require Image Processing Toolbox):
h1=image(builtin_image)

% This produces a figure showing the image data, and returns a handle to
% the Image object that is produced, which contains the data to display and
% additional properties. It is smart enough to make the Y axis 'reverse'
% get(gca,'YDir')

% but it does not ensure the same scale for the x and y axis, so the
% picture may appear distorted.

%% A better option is 'imshow' in the IPT. 
% By default, 'imshow' displays the image with 'axis equal' enabled, and
% the axis labels suppressed, though you can change this and it accepts
% many optional arguments. (doc imshow for more) Still returns an Image
% object.
h1=imshow(builtin_image)

%% Sometimes you might not need to actually save the image data to your
% workspace: just pass it from imread to imshow:
imshow(imread('car2.jpg'))

%% Now let's load a custom example: 
% Here are fluorescently labeled silica microspheres imaged through a
% widefield fluorescence microscope (from John Lavigne lab, USC)
truecolor_image=imread(fullfile('fluorescence','1-1-2s-1.jpg'));

% You can see in the workspace that this image is a true-color image, with
% 8 bits per channel.

clf
h1=imshow(truecolor_image);

%% Indicating a scale
% Usually, the X and Y scales in an image are just the pixel number (you
% can use 'Data Tips' tool from the Figure toolbar -> Tools menu to see the
% RGB values at any pixel position), and the axis labels are not shown to
% avoid cluttering the figure.

% But sometimes, especially for microscope images or maps, you have a known
% scale in the X and Y direction. For example, we might know the image on
% this microscope at this magnification is 40 microns across and 30 microns
% high. You can specify this by giving 2-element vectors for the 'XData'
% and 'YData' properties of the image, either by passing these as optional
% arguments to imshow, or setting them manually on the Image object after
% it is created.
% set(h1,'XData',[0 40],'YData',[0 30])  % if you already made the Image
h1=imshow(truecolor_image,'XData',[0 40],'YData',[0 30]); % other way
% Now, the Data Tips will show the [X,Y] position in microns instead of
% pixels.
xlabel('Microns')
ylabel('Microns')

% If you want to see the axes, you still have to make them visible:
set(gca,'Visible','on')

% By default, the axis limits are the same as the limits of the image data,
% but you can change this to zoom in or out (you can also use the figure
% tools to do this):
% xlim([5 25])
% ylim([10 25])
% xlim('auto')
% ylim('auto')

%% Addressing image data
% You can access, or replace, a subset of the image data by addressing it
% as you would any matrix. But, you'll need to either re-run imshow, or
% replace the CData field in the Image object, to see your changes.
altered_image=truecolor_image;
altered_image(:,:,3)=uint8(2*altered_image(:,:,3)); % multiply blue channel by 2
h1.CData=altered_image; % doing it this way is very fast

%% Saving
% We can also save our changes
imwrite(altered_image,'altered_image.tif'); % largest file size
imwrite(altered_image,'altered_image.jpg'); % compressed, lossy
imwrite(altered_image,'altered_image_better.jpg','Quality',90); % compressed, lossy
imwrite(altered_image,'altered_image_lossless.jpg','Mode','lossless'); % compressed, lossless
% compare the resulting file sizes!

% see the doc page for imwrite for much more info and some examples of how
% to save images of Matlab plots (Edit-> Copy Figure also works)

%% Grayscale images
% Images with a single channel can be thought of as grayscale; they might
% come from a monochrome camera, represent a single channel of a RGB image,
% or represent any kind of 2-dimensional data.

% While Matlab will usually consider channel values in a true-color image
% to represent a fraction of full-scale, it is common to adjust both the
% display range and color map used to display "grayscale" images to bring
% out contrast. You can indicate this when your reporting results by
% showing a colorbar.

figure(2);clf
% We will look at an example SEM image. 
gray_image=imread(fullfile('sem','JB1-13e_crop.tif'));
% you can see this is an 8-bit grayscale image: matrix of type uint8

% with no arguments, imshow will show the image in grayscale with the
% limits at 0 and 255. You can check values with the Data Tips.
imshow(gray_image)

%% But you can enter lower and upper limits. 
imshow(gray_image,[100 200])

%% if you give an empty matrix for the limits, it auto-scales 
% to the lowest and highest pixel.
imshow(gray_image,[])

% Add a color scale
colorbar

%% stretchlim
% However, auto-scaling can be distorted by a single unusually bright or
% dark pixel. 'stretchlim' can find the 1st and 99th percentile values, but
% it returns them as a fraction of full-scale. Can you figure out how to
% make the following command show the image with high contrast? 
imshow(gray_image,255*stretchlim(gray_image))
colorbar

%% Add scale
% The field of view in this image happens to be 1652 nm across and 1115 nm
% high. We can add axes for distance.
clf
% imshow(gray_image,'XData',[0 1652],'YData',[0 1115])
imshow(gray_image,255*stretchlim(gray_image),'XData',[0 1652],'YData',[0 1115])
set(gca,'Visible','on')
xlabel('Nanometers')
colorbar

%% Look-up tables (LUT's)
% You might decide that a "false" color scale will help bring out contrast,
% or for some kinds of data. Matlab does this by using colormaps: color
% lookup tables defined as a 3-column matrix of RGB values (from 0 to 1):
% the row number is the color index, and the color range can be scaled to
% your data. There are many built-in colormaps and you can also define your
% own.

% Try different colormaps: You can pick them with Edit->Colormap from the
% Figure menu. You can also pick some built-in ones by name: try 'hot',
% 'jet', 'cool': default grayscale is of course 'gray'
% colormap('jet')
colormap('hot')

% The image data itself and the XData and YData scales are part of the
% Image object, while the colormap and color scale limits are properties of
% the axes that they are displayed on:
ax2=gca; % gca = "get current axes handle"
% display CLim property (data values corresponding to low and high end of
% colormap)
ax2.CLim  
%% create a colormap
% any nx3 matrix can be a colormap. Here's a simple colormap where the
% lowest value is black ([0 0 0]) and the highest is pure red ([1 0 0])
redmap=zeros(256,3);
redmap(:,1)=linspace(0,1,256);
colormap(redmap)  % use quotes to specify the names of builtin maps: no quotes here

%% splitting an image
% sometimes it is helpful to split out the channels of a true color image
% to analyze them separately: see if you can create 3 separate 2-D matrices
% with the red, green, and blue data from our true color image. Then make
% four plots: 

figure(1);clf 
imshow(truecolor_image,'XData',[0 40],'YData',[0 30])

% now get the different color channels each as a 2D matrix:
red=truecolor_image(:,:,1); % channel 1 = red
% green=truecolor_image(:,:,1); % channel 1 = red
% blue=truecolor_image(:,:,1); % channel 1 = red

figure(2);clf
imshow(red,255*stretchlim(red,[0.01 0.999]),'XData',[0 40],'YData',[0 30])
colormap(redmap)
colorbar

% you can repeat this for the other channels


%% you can save a grayscale or indexed-color image in a .PNG file:
imwrite(red,'red.png')

% note that if you open that file in Windows, it looks gray, because you
% did not save the colormap data. 
imwrite(red,redmap,'red.png')
% the above command saves the colormap and the levels, but it will look
% dark if it is not displayed with the color limits as is done above.




%% Selecting regions of interest automatically by threshold
% You may want to know about the data within a particular region of
% interest. It is easy to do this by logical addressing -- selecting data
% using a logical array the same time as your image, with 1's at the
% positions of pixels you want to include, and 0's for those you don't.

% A logical array (a 1-bit image) is also called a bitmap, and is called a
% 'mask' when used to select regions of another image. There are several
% ways to create one, such as by applying a logical test to the image data:

% We might be interested in the average red intensity within each particle.
% In that case we only want data where the intensity is above some
% threshold.
mymask=red>25;
figure(5)
imshow(mymask)

redavg=mean(red(mymask))

%% selecting regions of interest manually
% There are also a number of interactive tools that can be used to draw
% shapes and create regions of interest based on them.

figure(1); % bring true color image back to the foreground / current figure

% 'roipoly' allows user to draw a polygon: click back on the first point to
% complete it. 
roimask=roipoly;
[roimask,roix,roiy]=roipoly; % get vectors of x and y positions for outline

% Note there are a number of updated functions for creating
% interactive ROI shapes that have been introduced in Matlab recently:
% check "Create ROI Shapes" in Documentation.
% my_roi_polygon=drawpolygon; 

% note the above command creates a polygon ROI object, which you can re-size,
% and you can inspect its properties at any time, but it does not create a
% mask. You can create a binary mask from it at any time:
% roimask=createMask(my_roi_polygon);


figure(5);
imshow(roimask)

%% You can use logical operations on these masks!
figure(5);
imshow(~roimask) % invert
imshow(roimask & mymask) % logical 'and'

%% You can also draw lines, for example to measure distance

figure(1);
my_line=drawline()
% this will create a line object, which you can re-size by dragging the
% anchor points. The Position property be a 2-column matrix: 1st column x
% values, 2nd column y values, according to the XData abnd YData scales you
% set for the image, or in pixels if you did not set these. 
disp(my_line.Position)  % view Position
% Calculate length of the line 
sqrt( diff(my_line.Position(:,1))^2 + diff(my_line.Position(:,2))^2)

% Check the distance between some particles. Check the distance between the
% two lines of assembled particles in the SEM image we looked at before.

%% delete annotation
my_line.delete  

% note the variable continues to exist in the workspace even though the
% line object is deleted from the figure. You can remove the variable with
% 'clear' if desired, or re-create the line by using 'drawline' again.

%% Overview of additional image analysis tutorials and examples

% PARTICLE ANALYSIS
% Matlab has many tools for analyzing particles and areas of images --
% basically, using some sort of thresholding algorithm to turn a grayscale
% or color image into a binary (black-and-white) classification, and then
% learning something about the various islands of connected pixels
% (particles or "labels") that are identified by doing this. It's very
% helpful for analyzing cells, beads, nanoparticles, etc. 

% An example of particle image analysis is in:
% particle_analysis_basic.m
% and uses images of fluorescent beads from a collaboration with the John
% Lavigne lab (in the "fluorescence" folder) as example data
% TODO: It works, but needs more comments to explain


% IMAGE REGISTRATION AND COMPARISON: Polarization of reflected light
% Sometimes you want to compare information between two similar images.
% The "polarization" folder has examples of this built around specular
% reflection of light from a noble metal surface (silver) vs. base metals
% with a native oxide (aluminum, stainless steel).

% You will learn to use the "cpselect" tool to select control points in two
% images that purportedly contain the same scene, but may be offset,
% rotated, or distorted, and use them to transform one of the images so it
% can be overlaid on the other and compared.

% control_point_image_registration.m 
% Demonstrates use of cpselect with a "fake" pair of images (two images
% cropped differently from the same original photo). "master" is the
% original source image. "Fixed" and "Moving" are the two images we will
% try to overlay and compare. Specifically, a transform will be developed
% for the "Moving" image that is used to generate a new version of it that
% can be overlaid on "fixed".

% linear_encoding_demo_cr2.m 
% Demonstrates 1) how to obtain linear-encoded images (values in matrix are
% directly proportional to light intensity) from full-color camera images
% in two ways: loading linear channel from a CR2 "camera raw" image file
% saved by a Canon DSLR camera, and using rgb2lin on images saved as color
% .JPG's; and 2) how to use a pair of images taken through horizontal and
% vertical polarizers to determine the polarization of light that is
% specularly reflected from a noble-metal surface (rim of a silver-lined
% bowl) and from a dielectric surface (glaze on the bowl and
% native-oxide-coated stainless steel knife and aluminum windowsill). In
% the latter cases, reflection of vertically-polarized (p-polarized) light
% should be suppressed in the case of the dielectric surfaces.



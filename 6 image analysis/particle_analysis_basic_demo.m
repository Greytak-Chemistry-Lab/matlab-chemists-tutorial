% For analysis of fluorescent images -- demo updated 2025-08-06


%% setup

% Define colormaps (all length 256)
redmap = zeros(256,3);
redmap(:,1)=linspace(0,1,256);
greenmap = zeros(256,3);
greenmap(:,2)=linspace(0,1,256);
bluemap = zeros(256,3);
bluemap(:,3)=linspace(0,1,256);

% sets the bins used to track pixel or average brightness
levels = 0:255;
% levels=(levels(1:end-1)+levels(2:end))./2; % gets midpoints between level centers
 

       
%% show an image 
rgbpath='fluorescence';  % full or relative path to folder where image is
rgbfile = '1-1-2s-1.jpg'; % name of RGB image file
titlestr = ['Input file ' rgbfile];

% load image from file(s)
clear red green blue merged
merged = imread(fullfile(rgbpath,rgbfile));
red = merged(:,:,1);        
green = merged(:,:,2); 
blue = merged(:,:,3); 

if(~exist('myroi','var'))
    myroi = true(size(red)); % initialize all-on, pick subregion only if we want
end

% merged
figure(1);clf;
%imshow(merged(:,:,:).*(2^16/(double(max(merged(myroi))))))
imshow(merged)
title(titlestr);
text(0.02*max(xlim),0.02*max(ylim),titlestr,'color','w')

% % red slice
figure(2);clf;
%imshow(red,[0 max(stretchlim(red,0.00001))]*2^16)
imshow(red,[0 max(red(myroi))])
colormap(redmap); colorbar;
title(titlestr);
% 
% % green slice
figure(3);clf;
%imshow(green,[0 max(stretchlim(green,0.00001))]*2^16)
imshow(green,[0 max(green(myroi))])
colormap(greenmap); colorbar;
title(titlestr) 

% % blue slice
figure(4);clf;
    %imshow(blue,[0 max(stretchlim(blue,0.00001))]*2^16)
    imshow(blue,[0 max(blue(myroi))])
    colormap(bluemap); colorbar;
    title(titlestr)


% cut to crop area
if(exist('cropx','var') && length(cropx)>1)
    for(i=find(ishandle(1:4)))
        figure(i);
        xlim(cropx);
        ylim(cropy); % assume this exists too
    end
end

% display ROI outline
if(exist('roix','var') && length(roix)>2)
    for(i=find(ishandle(1:4)))
        figure(i);
        line(roix,roiy,'color','w','linestyle','-','linewidth',2);
        line(roix,roiy,'color','k','linestyle',':','linewidth',2);
    end
end

%% Pick crop area
figure(1) % brings figure 1 to front
cropx = [];
cropy = [];
croprect=imrect; % NOTE: imrect is now discouraged, Rectangle() is preferred
croppos=ceil(croprect.getPosition); % [ xmin ymin width height]
cropx = [ croppos(1) ( croppos(1) + croppos(3) ) ];
cropy = [ croppos(2) ( croppos(2) + croppos(4) ) ];
croprect.delete;
% apply to current figure
xlim(cropx);
ylim(cropy); % assume this exists too
% apply to all figures
if(exist('cropx','var') && length(cropx)>1)
    for(i=find(ishandle(1:4)))
        figure(i);
        xlim(cropx);
        ylim(cropy); % assume this exists too
    end
end
%% Clear crop area
cropx = [];
cropy = [];
clear croppos
for(i=find(ishandle(1:4)))
    figure(i);
    xlim('auto');
    ylim('auto'); % assume this exists too
end
%% Save crop area
save mycrop cropx cropy
%% Load crop area
load mycrop 
% apply to all figures
if(exist('cropx','var') && length(cropx)>1)
    for(i=find(ishandle(1:4)))
        figure(i);
        xlim(cropx);
        ylim(cropy); % assume this exists too
    end
end
%% Pick ROI
figure(1) % brings figure 1 to front
myroi = true(size(red)); % initialize all-on, pick subregion only if we want
roix = [];
roiy = [];
% uncomment if you want to pick a subregion 
delete(findall(gcf,'type','line'));
[myroi roix roiy]=roipoly;
% display ROI outline
if(length(roix)>2)
    line(roix,roiy,'color','w','linestyle','-','linewidth',2);
    line(roix,roiy,'color','k','linestyle',':','linewidth',2);
end
%% Reset ROI 
myroi = true(size(red)); % initialize all-on, pick subregion only if we want
roix = [];
roiy = [];
%% Save an ROI
save myroi myroi roix roiy
%% Load an ROI
load myroi
% display ROI outline
if(exist('roix','var') && length(roix)>2)
    for(i=find(ishandle(1:4)))
        figure(i);
        line(roix,roiy,'color','w','linestyle','-','linewidth',2);
        line(roix,roiy,'color','k','linestyle',':','linewidth',2);
    end
end

%% find particles
threshold_channel='green';
threshold_value=50; % 0 for auto, enter a non-zero level for manual

switch threshold_channel
    case 'red'
        if(threshold_value==0)
            particle_mask=imbinarize(red);
        else
            particle_mask=red>threshold_value;
        end
    case 'green'
        if(threshold_value==0)
            particle_mask=imbinarize(green);
        else
            particle_mask=green>threshold_value;
        end
    case 'blue'
        if(threshold_value==0)
            particle_mask=imbinarize(blue);
        else
            particle_mask=blue>threshold_value;
        end
end
particle_mask=particle_mask & myroi;

% display mask of all particles, or label image (indexed color image with
% each particle marked by a different color index level)
figure(5)
% imshow(particle_mask)
% imshow(label2rgb(bwlabel(particle_mask)))
imshow(bwlabel(particle_mask),[])
colormap('colorcube')

% cut to crop area
if(exist('cropx','var') && length(cropx)>1)
    for(i=find(ishandle(1:5)))
        figure(i);
        xlim(cropx);
        ylim(cropy); % assume this exists too
    end
end

% display ROI outline
if(exist('roix','var') && length(roix)>2)
    for(i=find(ishandle(1:5)))
        figure(i);
        line(roix,roiy,'color','w','linestyle','-','linewidth',2);
        line(roix,roiy,'color','k','linestyle',':','linewidth',2);
    end
end

%% get particle data
particle_label=bwlabel(particle_mask);
particles=struct('area',0,'perimeter',0,'red_total',0,'green_total',0,'blue_total',0);
for(i=1:max(particle_label(:)))
    particles(i).area=sum(particle_label(:)==i);
    particles(i).perimeter=bwperim(particle_label==i);
    particles(i).red_total=sum(red(particle_label==i));
    particles(i).green_total=sum(green(particle_label==i));
    particles(i).blue_total=sum(blue(particle_label==i));
end

%% How to analyze your results now that you have separately labeled each particle
% plot any property versus any other to look for correlations
figure(6)
plot([particles.red_total],[particles.green_total],'ks')
xlim([0 max(xlim)])
ylim([0 max(ylim)])
xlabel('Red total')
ylabel('Green total')

% histogram of particle properties learn more about Matlab's 'histogram'
% and related functions from the documentation. Enclosing [particles.area]
% in [] makes it pass a vector of the values of the area field in every
% element of the 'particles' structure array to the histogram function.
figure(7) 
histogram([particles.area],[0:1000:11000])
xlabel('Particle area')
ylabel('Number found')

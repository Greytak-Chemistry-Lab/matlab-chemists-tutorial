%% IMAGE REGISTRATION AND COMPARISON: Polarization of reflected light
% Compare information between two similar images: here, specular reflection
% of (mostly) unpolarized daylight (from a white clouds on a bright day)
% from a noble metal surface (silver) vs. base metals with a native oxide
% (aluminum, stainless steel).

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

% For basic scientific discussion, see Wikipedia articles:
% https://en.wikipedia.org/wiki/Specular_reflection
% https://en.wikipedia.org/wiki/Brewster%27s_angle

% For much more detailed discussion, look up ellipsometry of metal surfaces

% test images recorded 2024-07-27 with Canon Rebel T7 ISO 1600

inputdir=pwd;

%% view an image pair -- from raw
% This is commented out because the CR2 source images are enormous in size
% and have been eliminated from the tutorial files to save space.

% files=dir(fullfile(inputdir,'*filter.CR2'));
% img1_no=1;
% img2_no=3;
% img1=raw2rgb(fullfile(inputdir,files(img1_no).name));
% img1=rgb2lin(img1);
% img2=raw2rgb(fullfile(inputdir,files(img2_no).name));
% img2=rgb2lin(img2);
% 
% figure(1);clf
% imshow(img1)
% title('image 1 linear from raw')
% 
% figure(2);clf
% imshow(img2)
% title('image 2 linear from raw')

%% view an image pair -- from JPG
files=dir(fullfile(inputdir,'*filter.JPG'));
img1_no=1;
img2_no=3;
img1=imread(fullfile(inputdir,files(img1_no).name));
img1=rgb2lin(img1);
img2=imread(fullfile(inputdir,files(img2_no).name));
img2=rgb2lin(img2);

figure(1)
imshow(img1)
title('image 1 linear from JPG')

figure(2)
imshow(img2)
title('image 2 linear from JPG')

%% control point select
[movingPoints,fixedPoints]=cpselect(img2,img1,'Wait',true);

%% warp image
t=fitgeotrans(movingPoints,fixedPoints,'nonreflectivesimilarity');
Rfixed=imref2d(size(img1));
img2_reg=imwarp(img2,t,'OutputView',Rfixed);

figure(3);
imshow(img2_reg)
title('image 2 registered')

%% choose a point and display ratio
figure(1);
sample_point=drawcrosshair;

%% display ratio
sample_x=uint16(sample_point.Position(1));
sample_y=uint16(sample_point.Position(2));
% delete(sample_point)
figure(1);
% imshow(img1)
% h1x=xline(sample_x,'Color','r');
% h1y=yline(sample_x,'Color','r');

figure(2)
imshow(img2)
h2x=xline(sample_x,'Color','r');
h2y=yline(sample_y,'Color','r');

figure(3)
imshow(img2_reg)
h3x=xline(sample_x,'Color','r');
h3y=yline(sample_y,'Color','r');

red_ratio=double(img2_reg(sample_y,sample_x,1))/double(img1(sample_y,sample_x,1));
green_ratio=double(img2_reg(sample_y,sample_x,2))/double(img1(sample_y,sample_x,2));
blue_ratio=double(img2_reg(sample_y,sample_x,3))/double(img1(sample_y,sample_x,3));

figure(1)
title([num2str(red_ratio) ' ' num2str(green_ratio) ' ' num2str(blue_ratio) ])
%% 

% polarization image
polarization_channel=1; % 1=red, 2=green. 3=blue
% the following will create a floating-point array with same size as our
% images
polarization_img=zeros(size(img1,1),size(img1,2));
% now populate with polarization = horiz/(horiz + vertical)
polarization_img=double(img1(:,:,polarization_channel)) ...
    ./(double(img1(:,:,polarization_channel))+double(img2_reg(:,:,polarization_channel)));
figure(4);clf
imshow(polarization_img,[]); colormap('hot'); colorbar;



%% TODO: UPDATE BELOW HERE -- could add ability to select an ROI

% red=the_image(:,:,1);
% green=the_image(:,:,2);
% blue=the_image(:,:,3);
% if(~exist('myroi'))
%     myroi=true(size(red)); % initialize all-on, pick subregion only if we want
%     roix=[];
%     roiy=[];
% end
% if(length(roix)>2)
%     line(roix,roiy,'color','w','linestyle','-','linewidth',2);
%     line(roix,roiy,'color','k','linestyle',':','linewidth',2);
% end   
% if(sum(red(myroi)<0.98*red_max)<0.95*sum(myroi(:)))
%     red_flag='*';
% else
%     red_flag='';
% end
% if(sum(green(myroi)<0.98*green_max)<0.95*sum(myroi(:)))
%     green_flag='*';
% else
%     green_flag='';
% end
% if(sum(blue(myroi)<0.98*blue_max)<0.95*sum(myroi(:)))
%     blue_flag='*';
% else
%     blue_flag='';
% end
% red_level=mean(red(myroi));
% green_level=mean(green(myroi));
% blue_level=mean(blue(myroi));
% title(['Frame ' num2str(key_img_no) ', (R,G,B)=' ...
%     num2str(red_level,'%.1f') red_flag ','...
%     num2str(green_level,'%.1f') green_flag ','...
%     num2str(blue_level,'%.1f') blue_flag ')' ])
% drawnow;
% %% select roi
% myroi=true(size(red)); % initialize all-on, pick subregion only if we want
% roix=[];
% roiy=[];
% % uncomment if you want to pick a subregion 
% delete(findall(gcf,'type','line'));
% [myroi roix roiy]=roipoly;
% % display ROI outline
% if(length(roix)>2)
%     line(roix,roiy,'color','w','linestyle','-','linewidth',2);
%     line(roix,roiy,'color','k','linestyle',':','linewidth',2);
% end

%% plot mean intensity vs exposure from CR2 RAW file data
% red_levels=zeros(size(exposures));
% green_levels=zeros(size(exposures));
% blue_levels=zeros(size(exposures));
% red_sat=red_levels~=0;
% green_sat=green_levels~=0;
% blue_sat=blue_levels~=0;
% for(k=1:length(files))
% %     the_image=imread(files(k).name);
% the_image=imread(files(k).name,3);
% % the_image=uint8(255*double(the_image)./2^14);
%     figure(1);
%     delete(findall(gcf,'type','line'));
%     imshow(255*uint8(double(the_image)./2^14))
%     if(length(roix)>2)
%         line(roix,roiy,'color','w','linestyle','-','linewidth',2);
%         line(roix,roiy,'color','k','linestyle',':','linewidth',2);
%     end
%     red=the_image(:,:,1);
%     green=the_image(:,:,2);
%     blue=the_image(:,:,3);
%     if(sum(red(myroi)<0.98*red_max)<0.95*sum(myroi(:)))
%         red_sat(k)=true;
%         red_flag='*';
%     else
%         red_flag='';
%     end
%     if(sum(green(myroi)<0.98*green_max)<0.95*sum(myroi(:)))
%         green_sat(k)=true;
%         green_flag='*';
%     else
%         green_flag='';
%     end
%     if(sum(blue(myroi)<0.98*blue_max)<0.95*sum(myroi(:)))
%         blue_sat(k)=true;
%         blue_flag='*';
%     else
%         blue_flag='';
%     end
%     red_levels(k)=mean(red(myroi));
%     green_levels(k)=mean(green(myroi));
%     blue_levels(k)=mean(blue(myroi));
%     title(['Frame ' num2str(k) ', (R,G,B)=' ...
%         num2str(red_levels(k),'%.1f') red_flag ','...
%         num2str(green_levels(k),'%.1f') green_flag ','...
%         num2str(blue_levels(k),'%.1f') blue_flag ')' ])
%     drawnow;
% end
% figure(2);clf
% plot(log2(exposures(~red_sat)-exposures(end)),log2(red_levels(~red_sat)-red_levels(end)),'r',...
%     log2(exposures(~green_sat)-exposures(end)),log2(green_levels(~green_sat)-green_levels(end)),'g',...
%     log2(exposures(~blue_sat)-exposures(end)),log2(blue_levels(~blue_sat)-blue_levels(end)),'r')
% axis equal
% title('file data')
% ylabel('log2 intensity')
% xlabel('log2 exposure time')
% %% plot sRGB corrected/encoded intensity vs exposure from CR2 RAW file data
% correction_mode='sRGB encoded'; % or 'sRGB decoded'
% red_levels=zeros(size(exposures));
% green_levels=zeros(size(exposures));
% blue_levels=zeros(size(exposures));
% red_sat=red_levels~=0;
% green_sat=green_levels~=0;
% blue_sat=blue_levels~=0;
% for(k=1:length(files))
% %     the_image=imread(files(k).name);
% the_image=imread(files(k).name,3);
% % the_image=uint8(255*double(the_image)./2^14);
%     figure(1);
%     delete(findall(gcf,'type','line'));
%     imshow(255*uint8(double(the_image)./2^14))
%     if(length(roix)>2)
%         line(roix,roiy,'color','w','linestyle','-','linewidth',2);
%         line(roix,roiy,'color','k','linestyle',':','linewidth',2);
%     end
%     switch correction_mode
%         case 'sRGB decoded'
%     red=srgb2linear(the_image(:,:,1));
%     green=srgb2linear(the_image(:,:,2));
%     blue=srgb2linear(the_image(:,:,3));
%     red_max_cor=srgb2linear(uint16(red_max));
%     green_max_cor=srgb2linear(uint16(green_max));
%     blue_max_cor=srgb2linear(uint16(blue_max));
%         case 'sRGB encoded'
%      red=linear2srgb(the_image(:,:,1));
%     green=linear2srgb(the_image(:,:,2));
%     blue=linear2srgb(the_image(:,:,3));
%     red_max_cor=linear2srgb(uint16(red_max));
%     green_max_cor=linear2srgb(uint16(green_max));
%     blue_max_cor=linear2srgb(uint16(blue_max));
%     end
%     if(sum(red(myroi)<0.98*red_max_cor)<0.95*sum(myroi(:)))
%         red_sat(k)=true;
%         red_flag='*';
%     else
%         red_flag='';
%     end
%     if(sum(green(myroi)<0.98*green_max_cor)<0.95*sum(myroi(:)))
%         green_sat(k)=true;
%         green_flag='*';
%     else
%         green_flag='';
%     end
%     if(sum(blue(myroi)<0.98*blue_max_cor)<0.95*sum(myroi(:)))
%         blue_sat(k)=true;
%         blue_flag='*';
%     else
%         blue_flag='';
%     end
%     red_levels(k)=mean(red(myroi));
%     green_levels(k)=mean(green(myroi));
%     blue_levels(k)=mean(blue(myroi));
%     title(['Frame ' num2str(k) ', ' correction_mode '(R,G,B)=' ...
%         num2str(red_levels(k),'%.3f') red_flag ','...
%         num2str(green_levels(k),'%.3f') green_flag ','...
%         num2str(blue_levels(k),'%.3f') blue_flag ')' ])
%     drawnow;
% end
% figure(3);clf
% plot(log2(exposures(~red_sat)-exposures(end)),log2(red_levels(~red_sat)-red_levels(end)),'r',...
%     log2(exposures(~green_sat)-exposures(end)),log2(green_levels(~green_sat)-green_levels(end)),'g',...
%     log2(exposures(~blue_sat)-exposures(end)),log2(blue_levels(~blue_sat)-blue_levels(end)),'r')
% axis equal
% title(correction_mode)
% ylabel('log2 intensity')
% xlabel('log2 exposure time')
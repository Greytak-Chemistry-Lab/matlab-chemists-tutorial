% IMAGE REGISTRATION AND COMPARISON:
% Learn to use the "cpselect" tool to select control points in two
% images that purportedly contain the same scene, but may be offset,
% rotated, or distorted, and use them to transform one of the images so it
% can be overlaid on the other and compared.

% Here, you can practice using cpselect with a "fake" pair of images (two
% images cropped differently from the same original photo). "master" is the
% original source image. "Fixed" and "Moving" are the two images we will
% try to overlay and compare. Specifically, a transform will be developed
% for the "Moving" image that is used to generate a new version of it that
% can be overlaid on "fixed". See "doc cpselect" for detailed discussion of
% this built-in Matlab function.

%%
% clear

img_fixed=imread('cp_demo_fixed.jpg');
img_moving=imread('cp_demo_moving.jpg');

[movingPoints,fixedPoints]=cpselect(img_moving,img_fixed,'Wait',true);

%%
t=fitgeotrans(movingPoints,fixedPoints,'affine')
Rfixed=imref2d(size(img_fixed));
% The following command will transform the data in img_moving so that
% objects appear at the same locations as in img_fixed (at least, near the
% control points you picked)
img_registered=imwarp(img_moving,t,'OutputView',Rfixed);

figure(1);
imshow(img_fixed)
xline(246)
yline(259)

figure(2);
imshow(img_moving)
xline(246)
yline(259)

figure(3);
imshow(img_registered)
xline(246)
yline(259)

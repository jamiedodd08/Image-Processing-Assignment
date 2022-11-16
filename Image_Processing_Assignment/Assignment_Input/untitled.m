
clear; close all;

% Task 1: Pre-processing -----------------------
% Step-1: Load input image
I = imread('IMG_11.png');
figure, imshow(I),title('Original')

% Step-2: Covert image to grayscale
I_gray = rgb2gray(I);
figure, imshow(I_gray),title('Grayscale')

% Step-3: Rescale image
rI_gray = imresize(I_gray,[512 NaN]);
figure, imshow(rI_gray),title('Resized')

%applying filter to enhance picture more
PSF = fspecial('motion',21,11); % making filter
Idouble = im2double(rI_gray); % converting it into double
blr = imfilter(Idouble,PSF,'conv','circular'); % applying filter
figure(6) ;subplot(2,2,1)
imshow(blr) 
title('Blurred Image')

re_new = deconvwnr(blr,PSF); % making unblr again
figure(6);subplot(2,2,2)
imshow(re_new)
title('Restored Blurred Image')

% 2nd step
%changing the background to make picture more clear

A = strel('disk',30);
new = imopen(re_new,A);
my_pic = re_new - new;
figure(6)
subplot(2,2,3)
imshow(my_pic)
title('Orginal - Background')

% passing throw gaussian filter to fill more pores

filling = fspecial('gaussian',[50 50],3);
mask_fill = conv2(mask,filling,'same');
subplot(2,2,4);
figure(6)
imshow(mask_fill);
title('filling the more pore''s of mask')

% making limit of mask for better mask
mask_thrush_limit = mask_fill > 0.9;
figure(7)
subplot(2,2,1);colormap(gray)
imagesc(mask_thrush_limit)
title('making Mask Limit')

% now showing segmentation result

bw_com =bwconncomp(mask_thrush_limit);  % used to detect connected components in binary image
segmentation = zeros(size(mask_thrush_limit)); % for segmentation making zeros of same size of our mask
segmentation(bw_com.PixelIdxList{1}) = 1; % putting those calculated connectted pictures in segmentation and back remain zero
figure(7)
subplot(2,2,2);
imagesc(segmentation)
title('Segmantation')
colormap(gray) % colors of pic remain gray
hold on;

file = imfill(segmentation,'Holes'); % filling the pores to remove noise
seg = ~segmentation; % inverse of segmentation so background goes black again
figure(7);subplot(2,2,3)
imagesc(seg)
title('with black Background')
colormap(gray);


ware = bwareaopen(seg,10); % used to remove all other pixels other then connected
R =1;G =1; B =1; % assigning valies
RGB = cat(3, seg * R, seg * G, seg * B);
CMap=[0,0,0; 1,0,0]; % assigning map color only red
Red_color2  = ind2rgb(ware + 1, CMap); % converting image into rgb 
subplot(2,2,4)
figure(7)
imshow(Red_color2)
title('Red replacing white')



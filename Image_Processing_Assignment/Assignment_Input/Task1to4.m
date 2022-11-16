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

% Step-4: Produce histogram before enhancing
numbins = 64;
figure, histogram(rI_gray,numbins),title('Histogram')

% Step-5: Enhance image before binarisation with min, max pixel intensity
dpgrayimg = 255*im2double(rI_gray);
mi = min(min(dpgrayimg));
ma = max(max(dpgrayimg));

en_rI_gray = imadjust(rI_gray,[mi/255; ma/255],[0; 1]);
figure, imshowpair(rI_gray, en_rI_gray, 'montage'),title('Original Image vs Enhanced Image')

% Step-6: Histogram after enhancement
figure, histogram(en_rI_gray,numbins),title('Enhanced Histogram')

% Applying gaussian filter to blur image for a better binarization
Iblur = imgaussfilt(en_rI_gray,2);

% Step-7: Image Binarisation
bina_en_rI_gray = imbinarize(Iblur);
figure, imshow(bina_en_rI_gray),title('Binarized')

% Displaying Task 1 in a subplot
figure(1),subplot(2,2,1); imshow(rI_gray); title('Resized Image');
figure(1),subplot(2,2,2); histogram(rI_gray,numbins); title('Histogram before enhancement');
figure(1),subplot(2,2,3); histogram(en_rI_gray,numbins); title('Histogram after enhancement');
figure(1),subplot(2,2,4); imshow(bina_en_rI_gray); title('Binarization');

% Task 2: Edge detection ------------------------
cannyEdgeDetection = edge(en_rI_gray, "canny");
sobelEdgeDetection = edge(en_rI_gray, "sobel");
prewittEdgeDetection = edge(en_rI_gray, "prewitt");
robertsEdgeDetection = edge(en_rI_gray, "roberts");

% Displaying Task 2 in a subplot
figure(2),subplot(2,2,1); imshow(cannyEdgeDetection); title('Canny');
figure(2),subplot(2,2,2); imshow(sobelEdgeDetection); title('Sobel');
figure(2),subplot(2,2,3); imshow(prewittEdgeDetection); title('Prewitt');
figure(2),subplot(2,2,4); imshow(robertsEdgeDetection); title('Roberts');

% Task 3: Simple segmentation --------------------
% Get threshold level for the enhanced image to use for binarization
lvl = graythresh(en_rI_gray);
img = imbinarize(en_rI_gray,lvl);

% Filling the holes in the images including the ones that are on the
% boundary
bw_a = padarray(img,[1 1],1,'pre');
bw_a_filled = imfill(bw_a,'holes');
bw_a_filled = bw_a_filled(2:end,2:end);
%figure, imshow(bw_a_filled)

bw_b = padarray(padarray(img,[1 0],1,'pre'),[0 1],1,'post');
bw_b_filled = imfill(bw_b,'holes');
bw_b_filled = bw_b_filled(2:end,1:end-1);
%figure,imshow(bw_b_filled);

bw_c = padarray(img,[1 1],1,'post');
bw_c_filled = imfill(bw_c,'holes');
bw_c_filled = bw_c_filled(1:end-1,1:end-1);
%figure,imshow(bw_c_filled)

bw_d = padarray(padarray(img,[1 0],1,'post'),[0 1],1,'pre');
bw_d_filled = imfill(bw_d,'holes');
bw_d_filled = bw_d_filled(1:end-1,2:end);
%figure,imshow(bw_d_filled)

bw_filled = bw_a_filled | bw_b_filled | bw_c_filled | bw_d_filled;
figure, imshow(bw_filled),title('Filled Binarized Image')

% Filtering the image to remove the noise
BW2 = bwareafilt(bw_filled,[1,230]);
figure, imshowpair(bw_filled, BW2,'montage'),title('Filtering out noise');

% Subtracting the noise from the binarized image
final = bw_filled - BW2;
figure, imshow(final),title('Segmented Image')

% Task 4: Object Recognition --------------------
% Filtering out the bacteria and blood cells by sizes
bac = bwareafilt(bw_filled,[230,1200]);
cell = bwareafilt(bw_filled,[1200,20000]);

% Labeling the bacteria and blood cells by colours
b = label2rgb(bac,[0,1,1],[0,0,0]);
c = label2rgb(cell,[1,0,0], [0,0,0]);

% Adding the images back together
objrecog = b + c;
figure, imshow(objrecog),title('Object Recognition')







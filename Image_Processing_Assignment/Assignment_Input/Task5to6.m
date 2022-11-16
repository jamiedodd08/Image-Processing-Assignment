% Task 5: Robust method --------------------------
clear; close all;

% Read image
I = imread('IMG_15.png');
figure, imshow(I),title('Original')

% Resize image
resizeImg = imresize(I,[512 NaN]);
figure, imshow(resizeImg),title('Resized')

% Turn image to grayscale
grayImg = rgb2gray(resizeImg);
figure, imshow(grayImg),title('Grayscale')

% Enhance image before binarisation with min, max pixel intensity
dpgrayimg = 255*im2double(grayImg);
mi = min(min(dpgrayimg));
ma = max(max(dpgrayimg));

en_rI_gray = imadjust(grayImg,[mi/255; ma/255],[0; 1]);

% Get gray threshold
threshold = graythresh(en_rI_gray);

% Binarise image using gray threshold
binarisedImg = imbinarize(en_rI_gray,threshold);
figure, imshow(binarisedImg),title('Binarised Image')

% Using bwareopen to remove connected compontents that have fewer pixels
% than in the parameter
bawopen = bwareaopen(binarisedImg, 100);
figure, imshow(bawopen),title('Bwareopen Image')

% Filling the holes in the images including the ones that are on the
% boundary
bw_a = padarray(bawopen,[1 1],1,'pre');
bw_a_filled = imfill(bw_a,'holes');
bw_a_filled = bw_a_filled(2:end,2:end);
figure,imshow(bw_a_filled)

bw_b = padarray(padarray(bawopen,[1 0],1,'pre'),[0 1],1,'post');
bw_b_filled = imfill(bw_b,'holes');
bw_b_filled = bw_b_filled(2:end,1:end-1);
figure,imshow(bw_b_filled);

bw_c = padarray(bawopen,[1 1],1,'post');
bw_c_filled = imfill(bw_c,'holes');
bw_c_filled = bw_c_filled(1:end-1,1:end-1);
figure,imshow(bw_c_filled)

bw_d = padarray(padarray(bawopen,[1 0],1,'post'),[0 1],1,'pre');
bw_d_filled = imfill(bw_d,'holes');
bw_d_filled = bw_d_filled(1:end-1,2:end);
figure,imshow(bw_d_filled)

bw_filled = bw_a_filled | bw_b_filled | bw_c_filled | bw_d_filled;
figure, imshow(bw_filled)

% Erode to take the bacteria away from the image
BW2 = bw_filled;

erode = strel('disk',14);
open = strel('disk',6);
dilate = strel('disk',15);
bw_filled = imerode(bw_filled,erode);
bw_filled = imopen(bw_filled,open);
bw_filled = imdilate(bw_filled,dilate);

BW = bw_filled;
figure, imshow(BW),title('Blood Cells')

% Subtracting the blood cells image from binarised image to get image of
% bacteria
BW2 = BW2-bw_filled;
BW2 = bwareaopen(BW2,100);
figure,imshow(BW2),title('Bacteria')

% Colouring the blood cells and bacteria and joining the images
CMap = [0,0,0; 1,0,0];
BloodCells  = ind2rgb(BW + 1, CMap);
CMap = [0,0,0; 0,1,1];
Bacteria = ind2rgb(BW2 + 1, CMap);
 
Final = BloodCells+Bacteria;
figure,imshow(Final),title('Segemented Image')

cell = BW;
bac = BW2;

Test = cell+bac*2;

figure,imshow(Test),title('Test')
numbins = 64;
figure, histogram(Test,numbins),title('Histogram')

% Task 6: Performance evaluation -----------------
% Step 1: Load ground truth data
GT = imread("IMG_15_GT.png");
GT_Gray = rgb2gray(GT);
resizeGT = imresize(GT_Gray,[512 NaN]);
figure, imshow(resizeGT),title('Grayscale')

% Convert GT image to double to use to get dice score
GTDouble = 255*im2double(resizeGT);

% Dice score
similarity = dice(Test,GTDouble);
display(similarity)

% Precision and recall
[precision,recall] = bfscore(Test,GTDouble);
display(precision)
display(recall)


% To visualise the ground truth image, you can
% use the following code.
%L_GT = label2rgb(GT_Gray, 'prism','k','shuffle');
%figure, imshow(L_GT)
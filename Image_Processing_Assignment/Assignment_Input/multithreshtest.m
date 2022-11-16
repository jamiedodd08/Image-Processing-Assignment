clear; close all;

I = imread('IMG_11.png');
figure, imshow(I)

I_gray = rgb2gray(I);
figure, imshow(I_gray)

rI_gray = imresize(I_gray,[512 NaN]);
figure, imshow(rI_gray)

dpgrayimg = 255*im2double(rI_gray);
mi = min(min(dpgrayimg));
ma = max(max(dpgrayimg));

en_rI_gray = imadjust(rI_gray,[mi/255; ma/255],[0; 1]);
%en_rI_gray = imadjust(rI_gray,stretchlim(rI_gray),[1,0]);
Iblur = imgaussfilt(en_rI_gray,4);
%figure, imshow(Iblur)

level = multithresh(Iblur);
seg_I = imquantize(Iblur,level);
figure, imshow(seg_I,[])
%figure, imshow(im)

%mask = zeros(size(Iblur));
%mask(25:end-25,25:end-25) = 1;
%figure, imshow(mask)

%bw = activecontour(Iblur,mask,700);
%figure, imshow(bw)

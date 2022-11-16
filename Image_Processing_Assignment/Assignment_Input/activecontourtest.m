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

lvl = graythresh(en_rI_gray);
img = imbinarize(en_rI_gray,lvl);

bw_a = padarray(img,[1 1],1,'pre');
bw_a_filled = imfill(bw_a,'holes');
bw_a_filled = bw_a_filled(2:end,2:end);
imshow(bw_a_filled)

bw_b = padarray(padarray(img,[1 0],1,'pre'),[0 1],1,'post');
bw_b_filled = imfill(bw_b,'holes');
bw_b_filled = bw_b_filled(2:end,1:end-1);
imshow(bw_b_filled);

bw_c = padarray(img,[1 1],1,'post');
bw_c_filled = imfill(bw_c,'holes');
bw_c_filled = bw_c_filled(1:end-1,1:end-1);
imshow(bw_c_filled)

bw_d = padarray(padarray(img,[1 0],1,'post'),[0 1],1,'pre');
bw_d_filled = imfill(bw_d,'holes');
bw_d_filled = bw_d_filled(1:end-1,2:end);
imshow(bw_d_filled)

bw_filled = bw_a_filled | bw_b_filled | bw_c_filled | bw_d_filled;
figure, imshow(bw_filled)

BW2 = bwareafilt(bw_filled,[1,230]);
figure, imshowpair(bw_filled, BW2,'montage');
final = bw_filled - BW2;
figure, imshow(final)

%bac = bwareafilt(final,[230,1200]);
%cell = bwareafilt(final,[1200,20000]);

%h = label2rgb(bac,[0,1,1],[0,0,0]);
%j = label2rgb(cell,[1,0,0], [0,0,0]);

%indexedImage = j + h;
%figure, imshow(indexedImage),title('Object Recognition')


iml = bwlabel(final);
figure, imshow(iml),title('labels')
g = regionprops(iml,'Area','BoundingBox');
avals = [g.Area];
bac = find((0 <= avals)&(avals <= 1730));
cell = find((1730 <= avals)&(avals <= 20000));
h = ismember(iml, bac);
b = ismember(iml,cell);
rgbH = label2rgb(h,[0,1,1],[0,0,0]);
rgbB = label2rgb(b,[1,0,0], [0,0,0]);
i = rgbH+rgbB;
figure, imshow(i)




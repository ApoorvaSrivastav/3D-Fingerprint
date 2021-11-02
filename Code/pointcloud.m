% ptCloud = pcread('data.ply');
% figure,pcshow(ptCloud);
A = imread('croppedheight_map.jpg');
A = rgb2gray(A);
F = fft2(A); 
%F2 = log(abs(F));
% imshow(F2,[-1 5],'InitialMagnification','fit');
% colormap(jet); colorbar
%imshow(uint8(rescale(A)*255));
F= lowpass(F,1.4195*10^8/max(max(F)));
max(max(F))
%figure, plot(F)
D =ifft2(F);
figure, 
imshow(D)

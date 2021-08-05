im_white0=imread("./Images/finger/light_int6.jpg");
im_white0=rgb2gray(im_white0);
%im_white0=im_white0.*uint8(im_mask);
im_original=imread("./Images/finger/finger.6.jpg"); 

[M,N]= size(im_white0);
figure, imshow(im_original);
maxim= max(im_white0,[],'all');


p=double(im_white0)./double(maxim);
im_original(:,:,1) =double(im_original(:,:,1))./p;
im_original(:,:,2) =double(im_original(:,:,2))./p;
im_original(:,:,3) =double(im_original(:,:,3))./p;
%im_original = uint8(im_original);
%im_original2 = uint8(255 * mat2gray(im_original));

figure, imshow(uint8(im_original));
imwrite(im_original,"./Images/finger/light_corrected6.jpg")

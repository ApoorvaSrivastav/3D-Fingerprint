temp= imread(strcat('im.0.png'));
temp=rgb2gray(temp);
im_add = zeros(size(temp));
im_add = imbinarize(im_add);
for i=1:7
im= imread(strcat('im.',num2str(i-1),'.png'));
im_gray=rgb2gray(im);
im_mask = imbinarize(im_gray);
im_add =im_add + im_mask;
end
im_add=im_add/7;
figure,imshow(255*im_add);
imwrite(255*im_add,'im.mask.png')

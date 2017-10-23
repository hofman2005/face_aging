function img = self_quotient(img)

H = fspecial('gaussian', [9, 9], 3);

img2 = imfilter(img, H, 'replicate');
img2 = img ./ img2;

img3 = (img2 - min(img2(:))) / (max(img2(:))-min(img2(:))) * 255;
img = imadjust(uint8(img3));

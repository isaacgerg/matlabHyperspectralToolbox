function [rgb] = hyperImagesc(img, bands)
%UNTITLED1 Summary of this function goes here
%   Usage: plotAvirisRgb(img, bands)

[h, w, p] = size(img);

if (nargin == 1)
    bands = [1 round(p/2) p];
end
blue = img(:,:,bands(1));
green = img(:,:,bands(2));
red = img(:,:,bands(3));

rgb = zeros(size(img, 1), size(img, 2), 3);
rgb(:,:,1) = hyperNormalize(red);
rgb(:,:,2) = hyperNormalize(green);
rgb(:,:,3) = hyperNormalize(blue);

rgb = decorrstretch(rgb);
red = rgb(:,:,1);
green = rgb(:,:,2);
blue = rgb(:,:,3);
rgb(:,:,1) = adapthisteq(red);
rgb(:,:,2) = adapthisteq(green);
rgb(:,:,3) = adapthisteq(blue);

imshow(rgb); axis image;

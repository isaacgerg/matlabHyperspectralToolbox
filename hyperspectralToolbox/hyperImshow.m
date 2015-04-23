function [rgb] = hyperImshow( img, bands )
%UNTITLED1 Summary of this function goes here
%   Detailed explanation goes here


[h, w, p] = size(img);

if (nargin == 1)
    bands = [p round(p/2) 1];
end
red = img(:,:,bands(1));
green = img(:,:,bands(2));
blue = img(:,:,bands(3));

rgb = zeros(size(img, 1), size(img, 2), 3);
rgb(:,:,1) = adapthisteq(red);
rgb(:,:,2) = adapthisteq(green);
rgb(:,:,3) = adapthisteq(blue);

imshow(rgb); axis image;



% tmp = zeros(100, 614, 3);
% tmp(:,:,1) = histeq((img(:,:, [36])));
% tmp(:,:,2) = histeq((img(:,:, [24])));
% tmp(:,:,3) = histeq((img(:,:, [12])));
% image(tmp);
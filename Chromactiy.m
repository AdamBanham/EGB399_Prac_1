function [ chromacity ] = Chromactiy( ImageArray , colourThershold )
%CHROMACTIY performs chromacity checks on colour image array
%   converts a given n by m by 3 colour martic of a image to
%   and returns the chromacity of each RGB level
imC = double(ImageArray) ./255;
%gamma decode the pixels
imC = imC .^2.2;
%calculate R , G , B
imR = imC(:,:,1);
imG = imC(:,:,2);
imB = imC(:,:,3);
%get the sum array for ratio
imY = imR+imG+imB;
%calculate chromacity
figure(1);
imr = imR ./imY;
%imshow(imr>colourThershold);
%pause;
img = imG./imY;
%imshow(img>colourThershold);
%pause;
imb = imB./imY;
%imshow(imb>colourThershold);

chromacity(:,:,1) = imr;
chromacity(:,:,2) = img;
chromacity(:,:,3) = imb;
end


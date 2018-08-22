function [ ReturnImage , blobs ] = Segment ( Image )
%Segment loads a image and returns segment or highlights sections of a
%image
%   ReturnImage is the final image after image processing is handled
%   blobs is the image segmentation object returned after processing
im = imread(Image);
colourThershold = .7;
figure(2)
idisp(im);
%Apply chromacticity to test pixels
[ chromacity ] = Chromactiy( im , colourThershold );


%blobs requires greylevel images
blobR = iblobs(chromacity(:,:,1)>colourThershold);
blobG = iblobs(chromacity(:,:,2)>colourThershold);
blobB = iblobs(chromacity(:,:,3)>colourThershold);
%show each boundary box for blue blobs
%idisp(chromacity(:,:,3)>colourThershold);
blobB.plot_box('g');
blobB.plot('r*');
pause;


%return the final image
ReturnImage = im;
blobs.Red = blobR;
blobs.Blue = blobB;
blobs.Green = blobG;

[ Shapes ] = Circularity( blobs );
end


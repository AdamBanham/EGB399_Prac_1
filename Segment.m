function [ ReturnImage , blobs ] = Segment ( ImageLocation )
%Segment loads a image and returns segment or highlights sections of a
%image
%   ReturnImage is the final image after image processing is handled
%   blobs is the image segmentation object returned after processing
im = imread(ImageLocation);
colourThershold = .7;
Colours = ["Red","Green","Blue"];
%show original image
figure(2)
idisp(im);
%Apply chromacticity to test pixels
[ chromacity ] = Chromactiy( im , colourThershold );
%use chromacity images to form blobs.[colour] struct for blobs found of
%that colour
for i = 1:3
    blobs.(Colours(i)) = iblobs(chromacity(:,:,i)>colourThershold ,[5000,2000], 'boundary');
end
%show each boundary box for blue blobs
%idisp(chromacity(:,:,3)>colourThershold);
blobs.Blue.plot_box('g');
blobs.Blue.plot('r*');
pause;
%sort coloured blobs into shapes.[shapetype].[colour] struct
[ Shapes ] = Circularity( blobs );
%display the largest red triangle
figure(3)
%display original image
idisp(im);
hold on;
%find the big red triagnle
[~ , idx] = max(Shapes.Triangle.Red.area);
%plot boundary box
Shapes.Triangle.Red(idx).plot_box();

%return the final image
ReturnImage = im;
end


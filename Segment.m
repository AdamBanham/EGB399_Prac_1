function [ ReturnImage , blobs ] = Segment ( WorkSheet  )
%Segment loads a image and returns segment or highlights sections of a
%image
%   ReturnImage is the final image after image processing is handled
%   blobs is the image segmentation object returned after processing
imWork = imread(WorkSheet);
imTest = imWork(1:400,:,:);
imWork = imWork(400:1600,:,:);
colourThershold = .5;
Colours = ["Red","Green","Blue"];
Q = [20 380; 200 380; 380 380; 20 200; 200 200; 200 20; 20 20; 380 200; 380 20];
%Pract Exam Format
%find bright colours on test sheet
[ chroTest ] = Chromactiy( imTest , colourThershold );
%display test sheet
idisp(imTest);
%for each colour find shapes and return bounding box if found
% 'area',[55646,2258168]
for i = 1:3
    testBlobs.(Colours(i)) = iblobs(chroTest(:,:,i)>colourThershold,'area',[3000,22000], 'boundary');
    for j = 1:length(testBlobs.(Colours(i)))
        testBlobs.(Colours(i))(j).plot_box('b');
        testBlobs.(Colours(i))(j).plot('r*');
    end  
end
disp('finished with test sheet');
pause;
%get a binary image of calibration marks
[ chroWork ] = Chromactiy( imWork , colourThershold );
for i = 1:3
chroWork(:,:,i) = medfilt2(chroWork(:,:,i) , [4 4]);
end
Circles = chroWork(:,:,3) > colourThershold;
imshow(Circles);
%Circles = iblobs(Circles,'area',[3000,22000], 'boundary')

disp('Segmented the blue calibration marks on the work sheet');
pause;
%display binary image of all other shapes
redShapes = chroWork(:,:,1) > colourThershold;
greenShapes = chroWork(:,:,2) > colourThershold;
allShapes = redShapes | greenShapes;
idisp(allShapes);
disp('binary image of all other shapes');
pause;
blobs = iblobs(allShapes,'boundary');
blobs = blobs(2:end);
blobs.plot('r*');
pause;
idx = find(blobs.circularity < .71 & blobs.circularity > .6 );
blobs(idx).plot_box('b');
pause;


% %show original image
% figure(2)
% idisp(imWork);
% %Apply chromacticity to test pixels
% [ chromacity ] = Chromactiy( imWork , colourThershold );
% %use chromacity images to form blobs.[colour] struct for blobs found of
% %that colour
% for i = 1:3
%     blobs.(Colours(i)) = iblobs(chromacity(:,:,i)>colourThershold,'area',[3000,22000], 'boundary');
%     
% end
% 
% %show each boundary box for blue blobs
% %idisp(chromacity(:,:,3)>colourThershold);
% % % idisp(im)
% % % blobs.Blue.plot_box('b');
% % % blobs.Blue.plot('b*');
% % % pause;
% % % idisp(im)
% % % blobs.Red.plot_box('r');
% % % blobs.Red.plot('r*');
% % % pause;
% % % idisp(im)
% % % blobs.Green.plot_box('g');
% % % blobs.Green.plot('g*');
% % % pause;
% 
% %sort coloured blobs into shapes.[shapetype].[colour] struct
% [ Shapes ] = Circularity( blobs );
% %display the largest red triangle
% figure(3)
% %display original image
% idisp(imWork);
% hold on;
% %find the big red triagnle
% [~ , idx] = max(Shapes.Triangle.Red.area);
% %plot boundary box
% Shapes.Triangle.Red(idx).plot_box();
% 
% %return the final image
ReturnImage = imWork;
end


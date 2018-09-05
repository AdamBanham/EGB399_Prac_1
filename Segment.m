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
TestObjects = ["","",""];
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
        %workout the type of shape of test objects
        shapeType = WorkOutShape(testBlobs.(Colours(i))(j).circularity);
        %workout what size the shape is
        if shapeType == "TRIANGLE"
            if testBlobs.(Colours(i))(j).area < 5999
                shapeSize ="SMALL";
            else
                shapeSize="LARGE";
            end
        else
            if testBlobs.(Colours(i))(j).area < 8999
                shapeSize ="SMALL";
            else
                shapeSize="LARGE";
            end
        end
        %print out the results    
        fprintf("This shape is %s , it's a %s size and coloured %s \n",shapeType,shapeSize,Colours(i));
        TestObjects(end+1,1:3) = [Colours(i),shapeType,shapeSize];
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
allShapes = (redShapes | greenShapes);
idisp(allShapes);
disp('Now showing a binary image of all other shapes');
pause;
%plot a centroid on each shape
blobs = iblobs(allShapes,'boundary','area',[1500,99999]);
blobs = blobs(1:end);
blobs.plot('r*');
disp('Now showing a centroid for each found shape');
pause;
%plot a bounding box on each triangle
idx = find(blobs.circularity < .71 & blobs.circularity > .6 );
blobs(idx).plot_box('r');
disp('Now showing a bounding box on each triangle');
pause;
%plot a different box on green shape
Gblobs = iblobs(greenShapes,'boundary');
Gblobs.plot_box('--g')
disp('Now showing a different bounding box on each green shape');
pause;
%work out which shapes match the test objects
idisp(imWork);
for i = 2:4
    %find the colour of the object
   if TestObjects(i,1) == "Red"
       theShapes = redShapes;
   elseif TestObjects(i,1) == "Green"
       theShapes = greenShapes;
   end
  %if the test object was red
  if TestObjects(i,3) == "LARGE"
      % use a different comparision for triangles and another for other shapes
      if TestObjects(i,2) == "TRIANGLE"
          objects = iblobs(theShapes,'boundary','area',[6000,99999]);
      else
          %find objects that are red and big
          objects = iblobs(theShapes,'boundary','area',[9000,99999]);
      end
  else
      % use a different comparision for triangles and another for other shapes
      if TestObjects(i,2) == "TRIANGLE"
          objects = iblobs(theShapes,'boundary','area',[1500,4999]);
      else
          %find objects that are red and small
          objects = iblobs(theShapes,'boundary','area',[3000,8999]);
      end
  end
  %now find the objects that have the right circularity and plot
  if TestObjects(i,2) == "CIRCLE"
      idx = find(objects.circularity >= .91);
      objects(idx).plot_box('r');
  elseif TestObjects(i,2) == "SQUARE"
      idx = find(objects.circularity < .91 & objects.circularity >= .71);
      objects(idx).plot_box('y');
  else
      idx = find(objects.circularity <= .71);
      objects(idx).plot_box('g');
  end
end
ReturnImage = imWork;
end


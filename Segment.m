function [ ReturnImage ] = Segment ( WorkSheet  )
%Segment loads a image and returns segment or highlights sections of a
%image
%   ReturnImage is the final image after image processing is handled
%   blobs is the image segmentation object returned after processing
imWork = imread(WorkSheet);
[r,c] = size(imWork);
img_cutoff = r*.15;
imTest = imWork(1:img_cutoff,:,:);
imWork = imWork(img_cutoff:end,:,:);
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

% work out average area for shapes
thersholdImg = (chroTest(:,:,1)>colourThershold | chroTest(:,:,2)>colourThershold | chroTest(:,:,3)>colourThershold);
areaTest = iblobs(thersholdImg,'area',[1000,45000],'boundary');
averageArea = mean(areaTest.area);

for i = 1:2
    testBlobs.(Colours(i)) = iblobs(chroTest(:,:,i)>colourThershold,'area',[1000,35000], 'boundary','connect',8);
    
    for j = 1:length(testBlobs.(Colours(i)))
        
        testBlobs.(Colours(i))(j).plot_box('b');
        testBlobs.(Colours(i))(j).plot('r*');
        %workout the type of shape of test objects
        shapeType = WorkOutShape(testBlobs.(Colours(i))(j).circularity);
        %workout what size the shape is
        %disp(testBlobs.(Colours(i))(j).area)
        if shapeType == "TRIANGLE"
            
            if testBlobs.(Colours(i))(j).area < averageArea*.5
                shapeSize ="SMALL";
            else
                shapeSize="LARGE";
            end
        else
            if testBlobs.(Colours(i))(j).area < averageArea
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
blobs = iblobs(allShapes,'boundary','area',[1000,45000],'connect',8);
blobs = blobs(1:end);
blobs.plot('r*');
disp('Now showing a centroid for each found shape');
pause;
%plot a bounding box on each triangle
idx = find(blobs.circularity < .74 );
blobs(idx).plot_box('r');
disp('Now showing a bounding box on each triangle');
pause;
%plot a different box on green shape
Gblobs = iblobs(greenShapes,'boundary');
Gblobs.plot_box('--g')
disp('Now showing a different bounding box on each green shape');
pause;
%work out which shapes match the test objects
testBlobs = RegionFeature(); % stores the information about test shapes
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
          
          objects = iblobs(theShapes,'boundary','area',[averageArea*.5,45000],'connect',8);
      else
          %find objects that are red and big
          objects = iblobs(theShapes,'boundary','area',[averageArea,45000],'connect',8);
      end
  else
      % use a different comparision for triangles and another for other shapes
      if TestObjects(i,2) == "TRIANGLE"
          objects = iblobs(theShapes,'boundary','area',[1000,averageArea*.5],'connect',8);
      else
          %find objects that are red and small
          objects = iblobs(theShapes,'boundary','area',[1000,averageArea],'connect',8);
      end
  end
  %now find the objects that have the right circularity and plot
  if TestObjects(i,2) == "CIRCLE"
      idx = find(objects.circularity >= .93);
      objects(idx).plot_box('r');
      testBlobs(end+1) = objects(idx);
  elseif TestObjects(i,2) == "SQUARE"
      idx = find(objects.circularity < .93 & objects.circularity > .74);
      objects(idx).plot_box('y');
      testBlobs(end+1) = objects(idx);
  else
      idx = find(objects.circularity <= .74);
      objects(idx).plot_box('g');
      testBlobs(end+1) = objects(idx);
  end
end

%% Find the real world distances of the tested objects
ReturnImage = imWork;
blueBlobs = iblobs(Circles,'area',[1000,35000], 'boundary');
%disp(blueBlobs);
H = CalcHom(blueBlobs);

for i = 2:4

    shapePosition = ShapeHomPosition(H, testBlobs(i));
    
    fprintf("%s %s %s position: x=%f, y=%f \n", TestObjects(i, 1), TestObjects(i, 2), TestObjects(i, 3), shapePosition(1), shapePosition(2));
end
end


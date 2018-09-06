function [Number] = NeedleCount(imgAddress)
%UNTITLED2 Counts the number of needles in a given picture
%   Detailed explanation goes here
Number = 0;
img = iread(imgAddress,'grey','uint8');
% test the image levels
%ihist(img);

%test to work out where the rings of the caps are
% figure()
% idisp(img < 50 )
% figure()
% idisp(img > 100 & img < 150)
% figure()
% idisp( img > 150 )
% rings of the caps are above ~150 of brightness

%clean img up before displaying
correctedImg = medfilt2(img>170,[5 5]);
idisp(correctedImg);
disp('Now showing the rings shaped tips of caps');
pause;

%segment caps and show centroids of caps
index =[];
caps = iblobs(correctedImg,'boundary');
caps.plot_box()
for i = 1:length(caps)
    if caps(i).parent > 1
        index(end+1) = i;
    end
end
idisp(correctedImg);
caps(index).plot('*y');
disp('Now showing the centroids of each cap')
pause;

%determine and return the amount of caps in the scene
Number = length(index);
fprintf('The number of needles in this bundle was %d',Number)
end


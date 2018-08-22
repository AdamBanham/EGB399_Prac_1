function [ Shapes ] = Circularity( blobs )
%CIRCULARITY performs circularity testing to find out if a blob is a
%triangle , square or circle 
%   takes a blob structure with Red , Blue , Green properties
%   outputs a Shapes structure with square , triangle , circle set
%   each set has a size of either "big" or "small"
%   colour with either "R" , "B" or "G"

for shape = blobs.Red
    circularity = CalCir(shape.moments.m00,shape.perimeter);
    if circularity > .875
        disp('red shape is a circle')
    else
        
    end
end

Shapes = [];

end


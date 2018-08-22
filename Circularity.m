function [ Shapes ] = Circularity( blobs )
%CIRCULARITY performs circularity testing to find out if a blob is a
%triangle , square or circle 
%   takes a blob structure with Red , Blue , Green properties
%   outputs a Shapes structure with square , triangle , circle set
%   each set has a size of either "big" or "small"
%   colour with either "R" , "B" or "G"
Colours = ["Red","Blue","Green"];
% check each colour in blobs put that colours shape into shapes
Shapes = struct;
for i = 1:3
    circleIndex = find(blobs.(Colours(i)).circularity > .875);
    Shapes.Circle.(Colours(i)) = blobs.(Colours(i))(circleIndex);
end
for i = 1:3
    squareIndex = find((blobs.(Colours(i)).circularity < .875) & (blobs.(Colours(i)).circularity > .71) );
    Shapes.Square.(Colours(i)) = blobs.(Colours(i))(squareIndex);
end
for i = 1:3
    triIndex = find(blobs.(Colours(i)).circularity < .71 & blobs.(Colours(i)).circularity > .6);
    Shapes.Triangle.(Colours(i)) = blobs.(Colours(i))(triIndex);
end

% % for shape = blobs.Red
% %     circularity = shape.circularity;
% %     if circularity > .875
% %         disp('red shape is a circle')
% %         shape.shape = 'circle';
% %     elseif circularity > .71
% %         disp('red shape is a square')
% %         shape.shape = 'square';
% %     end
% % end

end


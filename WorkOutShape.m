function shapeType = WorkOutShape (circularity)
%works out what circularity is belongs to in terms of
%"circle"
%"square"
%"triangle"

if circularity > .875
    shapeType = "circle";
elseif  circularity > .71
    shapeType = "square";
else
    shapeType = "triangle";
end
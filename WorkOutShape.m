function shapeType = WorkOutShape (circularity)
%works out what circularity is belongs to in terms of
%"circle"
%"square"
%"triangle"

if circularity > .91
    shapeType = "CIRCLE";
elseif  circularity > .71
    shapeType = "SQUARE";
else
    shapeType = "TRIANGLE";
end
function [ circularity ] = CalCir( area , perimeter )
%CALCIR calculates the circularity of a object
%   Detailed explanation goes here

circularity = (4*pi*area)/(perimeter^2);

end


function [newMap] = plus(Map1,Map2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

name=strcat(Map1.Name,'_',Map2.Name);
newMap=Map2D(name);
newMap.ItemNames=[Map1.ItemNames;Map2.ItemNames];
newMap.X=[Map1.X;Map2.X];
newMap.Y=[Map1.Y;Map2.Y];
newMap.Other={Map1.Other;Map2.Other};
end


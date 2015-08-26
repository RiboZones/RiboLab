function [ NewMap,P ] = XRNA2MapXY( file_name )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Process an XRNA file
[~,name,~]=fileparts(file_name);
NewMap=Map2D(name);
%dpn=horzcat(cellstr(num2str([(1:1559)+1670]')));
%NewMap.AddMap(file_name,'DataPointNames',dpn);
NewMap.AddMap(file_name);
NewMap.Transform('molecule','23S','alignResi','653','scale_fact',1);
P=[NewMap.X,792-NewMap.Y];
end


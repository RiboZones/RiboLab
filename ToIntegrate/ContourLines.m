function [ output_args ] = ContourLines( Map_Struct )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

f=fields(Map_Struct);

for i=1:length(f)
   ms=Map_Struct.(f{i});
   maps=fields(ms);
   for j=1:length(maps)
%        disp(Map_Struct.(f{i}).(maps{j}).Name);
       Map_Struct.(f{i}).(maps{j}).ContourLine('filename',[Map_Struct.(f{i}).(maps{j}).Name,...
           '_ContourLine.eps']);
   end
end

end


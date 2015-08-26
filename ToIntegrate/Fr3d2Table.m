function [ Table, BPstruct ] = Fr3d2Table( FR3D_file, RVmap, varargin )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

BPstruct=Fr3D2BP(FR3D_file,varargin{:});

[~,FilteredBP]=PlotBPbyType(BPstruct,RVmap,'DisplayPlots',false);
BPorg=BPorganize([FilteredBP{:}]);

Tables = BP2Table(DeDupBP(BPorg),'TableFormat','website',...
    'ItemList',RVmap.ItemNames,'Merge',false);

for i=1:length(Tables)
    xlswrite([RVmap.Name,'_',BPorg(i).Name{1},'.xlsx'],Tables{i});
end


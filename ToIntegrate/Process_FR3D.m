function [ Processed_BPs ] = Process_FR3D( FR3D_file, RiboLabMap, varargin )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

FilterBPs=false();
if nargin > 2
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'FilterTypes'
                FilterTypes=varargin{2*ind};
                FilterBPs=true();
        end
    end
end

RiboLabFullBP = Fr3D2BP(FR3D_file);

for i=1:length(RiboLabFullBP)
    RiboLabFullBP(i).Name=['rRNA ',num2str(i)];
end

[~,FilteredBP]=PlotBPbyType(RiboLabFullBP,RiboLabMap,'DisplayPlots',false);
BPorg=BPorganize([FilteredBP{:}]);
DeDupped_BPs=DeDupBP(BPorg);


if FilterBPs
    All_BPs=horzcat(DeDupped_BPs.Data);
    Keep=ismember(lower({All_BPs.BP_Type}),lower(FilterTypes));
   
    [~,DataSetName]=fileparts(FR3D_file);
    Processed_BPs.Name = [DataSetName,'_', horzcat(FilterTypes{:})];
    Processed_BPs.Data = All_BPs(Keep);
    Processed_BPs.Chain = unique([Processed_BPs.Data.BP1_Chain]);
    
else
   Processed_BPs = DeDupped_BPs;
end

end


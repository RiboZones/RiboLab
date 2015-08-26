function [ DeDupped_BPs ] = DeDupBP( BP_Structs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numBP=length(BP_Structs);

for i=1:numBP
    % Warning, this does not have iCode support yet. Will not work for Thermus.
    %BP1_Nums=str2num(char({BP_Structs(i).Data.BP1_Num}));
    
    % Experimental iCode support. Basically, ignore the letters, let sort
    % based on numbers. Using real names for comparison. Should basically
    % work as long as we don't care about which of the pair containing
    % numbers we care about the most, since it's fairly arbitrary.
    BP1_Nums=str2num(char(regexprep(cellstr(char({BP_Structs(i).Data.BP1_Num})),'[^\d]','')));
    
    [~,I]=sort(BP1_Nums);
    BP_Structs(i).Data=BP_Structs(i).Data(I);
    BPnamesA=lower(strcat({BP_Structs(i).Data.BP1_Num},'_',{BP_Structs(i).Data.BP2_Num},{BP_Structs(i).Data.BP_Type}));
    BPnamesB=lower(strcat({BP_Structs(i).Data.BP2_Num},'_',{BP_Structs(i).Data.BP1_Num},{BP_Structs(i).Data.BP_Type}));
    
    numPts=length(BPnamesA);
    KeepRows=false(1,numPts);
    for j=1:numPts
       [~,I]=ismember(BPnamesA(j),BPnamesB);
       if (I > j) || (I == 0 )
           KeepRows(j)=true;
       end
        
    end
    DeDupped_BPs(i)=BP_Structs(i);
    DeDupped_BPs(i).Data=BP_Structs(i).Data(KeepRows);
end
end


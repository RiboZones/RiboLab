function [ NewBP ] = BPorganize(BP)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

numBP=length(BP);
NewBP(1).Name={'BasePairs'};
NewBP(2).Name={'Stacking'};
NewBP(3).Name={'BaseSugar'};
NewBP(4).Name={'BasePhosphate'};
NewBP(5).Name={'Other'};
for i=1:5
    NewBP(i).Chain=BP(1).Chain;
    NewBP(i).Data=[];
end

%bptypes=cell(numBP,1);
for i=1:numBP
    %bptypes{i}=bp(i).Data(1).BP_Type;
    if regexp(lower(BP(i).Data(1).BP_Type),'[ct][wsh][wsh]')
        if isempty(NewBP(1).Data)
            NewBP(1).Data=BP(i).Data;
        else
            NewBP(1).Data=[NewBP(1).Data,BP(i).Data];
        end
    elseif regexp(lower(BP(i).Data(1).BP_Type),'(s[35][35])?(perp)?')
        if isempty(NewBP(2).Data)
            NewBP(2).Data=BP(i).Data;
        else
            NewBP(2).Data=[NewBP(2).Data,BP(i).Data];
        end
    elseif regexp(lower(BP(i).Data(1).BP_Type),'.+br')
        if isempty(NewBP(3).Data)
            NewBP(3).Data=BP(i).Data;
        else
            NewBP(3).Data=[NewBP(3).Data,BP(i).Data];
        end
    elseif regexp(lower(BP(i).Data(1).BP_Type),'.+bph')
        if isempty(NewBP(4).Data)
            NewBP(4).Data=BP(i).Data;
        else
            NewBP(4).Data=[NewBP(4).Data,BP(i).Data];
        end
    else
        if isempty(NewBP(5).Data)
            NewBP(5).Data=BP(i).Data;
        else
            NewBP(5).Data=[NewBP(5).Data,BP(i).Data];
        end
    end
    
end



end


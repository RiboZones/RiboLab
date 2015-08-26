function [V,Gc,GLabels] = BreakSubset(VarInterest,Subsets,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

FullLength=true;

DataSetNames={'L2','L3','L4'};
SubsetNames={'Glb','RPE'};

numDataSets=length(VarInterest);
if mod(length(Subsets),numDataSets)
    error('Number of Subsets must be a multiple of Number of DataSets')
else
    numSubsets=length(Subsets)/numDataSets;
    numSamples=numSubsets*numDataSets;
end


if FullLength
    numSamples=numSamples+numDataSets;
    V=cell(numSamples,1);
    %G=cell(numSamples,1);
    Gc=cell(numSamples,1);
    GLabels=cell(numSamples,1);
    I=1:(numSubsets+1):numSamples;
    J=setdiff(1:numSamples,I);
    dX=floor((J-1)/(numSubsets+1))+1;

    for i=1:length(I)
        V{I(i)}=VarInterest{i};
        %G{I(i)}=I(i)*ones(length(V{I(i)}),1);        
        Gc{I(i)}=i*ones(length(V{I(i)}),1);
        GLabels{I(i)}=repmat({[DataSetNames{i},' Full']},1,length(V{I(i)}));
    end
    for j=1:length(J)
        V{J(j)}=VarInterest{dX(j)}(Subsets{J(j)-dX(j)});
        %G{J(j)}=J(j)*ones(length(Subsets{J(j)-dX(j)}),1);
        Gc{J(j)}=dX(j)*ones(length(Subsets{J(j)-dX(j)}),1);
        GLabels{J(j)}=repmat({[DataSetNames{dX(j)},' ',...
            SubsetNames{mod(j-1,numSubsets)+1}]},1,length(Subsets{J(j)-dX(j)}));
    end

end
end

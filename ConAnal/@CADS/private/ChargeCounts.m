function [ Counts ] = ChargeCounts( CADS_object,charge_type)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

FullLength=CADS_object(1).Settings.Subsets.Combined;

numDataSets=length(CADS_object);
aacharge=[0,1,0,-1,0,0,-1,0,1,0,0,1,0,0,0,0,0,0,0,0];

CutAlignments=cell(numDataSets,1);
AAcounts=cell(numDataSets,1);
Charges=cell(numDataSets,1);
Counts=cell(numDataSets,1);
for i=1:numDataSets
    numSpecies=length(CADS_object(i).Alignment);
    
    if FullLength
        CutAlignments{i}{1}=struct('Header',[],'Sequence',[]);
        for k=1:numSpecies
            CutAlignments{i}{1}(k).Header=CADS_object(i).Alignment(k).Header;
            CutAlignments{i}{1}(k).Sequence=CADS_object(i).Alignment(k).Sequence;
            AAcounts{i}{1}(k)=aacount(CutAlignments{i}{1}(k));
        end
        Charges{i}{1}=cell2mat(squeeze(struct2cell(AAcounts{i}{1}))) .* repmat(aacharge',1,numSpecies);
        switch charge_type
            case 'positive'
                Charges{i}{1}(Charges{i}{1}<0)=0;
                Counts{i}{1}=sum(Charges{i}{1})';
            case 'negative'
                Charges{i}{1}(Charges{i}{1}>0)=0;
                Counts{i}{1}=sum(Charges{i}{1})';
            case 'net'
                Counts{i}{1}=sum(Charges{i}{1})';
        end
        offset=1;
    else
        offset=0;
    end
    
    for j=1:length(CADS_object(i).Subsets)
        CutAlignments{i}{j+offset}=struct('Header',[],'Sequence',[]);
        for k=1:numSpecies
            CutAlignments{i}{j+offset}(k).Header=CADS_object(i).Alignment(k).Header;
            CutAlignments{i}{j+offset}(k).Sequence=CADS_object(i).Alignment(k).Sequence(CADS_object(i).Subsets{j});
            AAcounts{i}{j+offset}(k)=aacount(CutAlignments{i}{j+offset}(k));
        end
        %         AAdistro{i}{j}=sum(cell2mat(squeeze(struct2cell(AAcounts{i}{j}))),2);
        
        Charges{i}{j+offset}=cell2mat(squeeze(struct2cell(AAcounts{i}{j+offset}))) .* repmat(aacharge',1,numSpecies);
        switch charge_type
            case 'positive'
                Charges{i}{j+offset}(Charges{i}{j+offset}<0)=0;
                Counts{i}{j+offset}=sum(Charges{i}{j+offset})';
            case 'negative'
                Charges{i}{j+offset}(Charges{i}{j+offset}>0)=0;
                Counts{i}{j+offset}=sum(Charges{i}{j+offset})';
            case 'net'
                Counts{i}{j+offset}=sum(Charges{i}{j+offset})';
        end
    end
end
end


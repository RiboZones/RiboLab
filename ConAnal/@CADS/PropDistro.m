function  [Propdistro,AAdistro,CutAlignments,PropMatrix]=PropDistro(CADS_object,varargin)

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
numBins=10;
numDataSets=length(CADS_object);

% if mod(length(Subsets),numDataSets)
%     error('Number of Subsets must be a multiple of Number of DataSets')
% else
%     numSubsets=length(Subsets)/numDataSets;
% %     numSamples=numSubsets*numDataSets;
% end

aavol = [88.6000,173.4000,117.7000,111.1000,108.5000,143.9000,138.4000,60.1000,...
    153.2000,166.7000,166.7000,168.6000,162.9000,189.9000,122.7000,89.0000,...
    116.1000,227.8000,193.6000,140.0000];
aacharge=[0,1,0,-1,0,0,-1,0,1,0,0,1,0,0,0,0,0,0,0,0];

PropertyInterest=aavol;
Direction='Sequence';


if nargin >2
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'PropertyInterest'
                if ~ischar(varargin{2*ind});
                    PropertyInterest=varargin{2*ind};
                else
                    switch varargin{2*ind}
                        case 'aavol'
                            PropertyInterest=aavol;
                        case 'aacharge'
                             PropertyInterest=aacharge;
                    end
                end
            case 'numBins'
                numBins=varargin{2*ind};
            case 'Direction'
                Direction=varargin{2*ind};
            otherwise
        end
    end
end



Edges=min(PropertyInterest):(max(PropertyInterest)-min(PropertyInterest))/...
    numBins:max(PropertyInterest)+1;


CutAlignments=cell(numDataSets,1);
AAcounts=cell(numDataSets,1);
AAdistro=cell(numDataSets,1);
Propdistro=cell(numDataSets,1);
PropMatrix=cell(numDataSets,1);
for i=1:numDataSets
    numSpecies=length(CADS_object(i).Alignment);
    for j=1:length(CADS_object(i).Subsets)
        CutAlignments{i}{j}=struct('Header',[],'Sequence',[]);
        numPositions = length(CADS_object(i).Subsets{j});
        switch Direction
            case 'Sequence'
                for k=1:numSpecies
                    CutAlignments{i}{j}(k).Header=CADS_object(i).Alignment(k).Header;
                    CutAlignments{i}{j}(k).Sequence=CADS_object(i).Alignment(k).Sequence(CADS_object(i).Subsets{j});
                    AAcounts{i}{j}(k)=aacount(CutAlignments{i}{j}(k));
                end
            case 'Position'
                for k=1:numSpecies
                    CutAlignments{i}{j}(k).Header=CADS_object(i).Alignment(k).Header;
                    CutAlignments{i}{j}(k).Sequence=CADS_object(i).Alignment(k).Sequence(CADS_object(i).Subsets{j});
                end
                X=vertcat(CutAlignments{i}{j}.Sequence);
                for p = 1 : numPositions
                    AAcounts{i}{j}(p)=aacount(X(:,p));
                end
        end
        %AAdistro{i}{j}=sum(cell2mat(squeeze(struct2cell(AAcounts{i}{j}))),2);
        AAdistro{i}{j}=cell2mat(squeeze(struct2cell(AAcounts{i}{j})));
        numSites=sum(sum(AAdistro{i}{j}));
        Propdistro{i}{j}=zeros(1,numSites);
        numCols = size(AAdistro{i}{j},2);
        PropMatrix{i}{j}=zeros(20,numCols);

        SiteInd=1;
        for a=1:20
            for b=1:numCols
                Propdistro{i}{j}(SiteInd)=PropertyInterest(a);
                SiteInd=SiteInd+1;
                PropMatrix{i}{j}(a,b)= AAdistro{i}{j}(a,b) * PropertyInterest(a);
            end
        end
        figure();
        N=histc(Propdistro{i}{j},Edges);
        bar(N(1:end-1)/length(Propdistro{i}{j}));
        middleOffset=(Edges(2)-Edges(1))/2;
        xlab=cellstr(num2str(round(Edges-middleOffset)'))';
        set(gca,'XTickLabel',xlab(1:2:end));
        set(gca,'XLim',[0,20]);
        set(gca,'XTick',[0:2:20]);
        
    end
end

end


function [Variabilities,Residue_Numbers] = FilterVarPlot(CADS_object,Subsets,varargin)

%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Var_cutoff=1;
PlotSymbols={'b^','rv','cs','md'};
freq_filter=false;
MaxCurrentFigure=max(findall(0,'type','figure'));
if isempty(MaxCurrentFigure)
    MaxCurrentFigure=0;
end

if nargin >2
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'Var_cutoff'
                Var_cutoff=varargin{2*ind};
            case 'FreqFilter'
                freq_filter=true;
                sele_class=varargin{2*ind}{1};
                if sele_class==0
                    sele_class=true(size(CADS_object(1).Settings.Alignment.Classes,2),1);
                end
                class_cutoff=varargin{2*ind}{2};
                Var_cutoff=class_cutoff;
            case 'PlotSymbols'
                PlotSymbols=varargin{2*ind};
        end
    end
end
numPlotSymbols=length(PlotSymbols);
numDataSets=length(CADS_object);

if mod(length(Subsets),numDataSets)
    error('Number of Subsets must be a multiple of Number of DataSets')
else
    numSubsets=length(Subsets)/numDataSets;
end


Variabilities=cell(numDataSets,numSubsets);
Residue_Numbers=cell(numDataSets,numSubsets);

for i=1:numDataSets
    if freq_filter
        [~,~,F] = FilterVar(CADS_object(i),varargin{:});
        keep_cutoff=F{1}(sele_class,:) > class_cutoff;
    else
        keep_cutoff=CADS_object(i).Results(1).Variability < Var_cutoff;
    end
    numSamples=length(CADS_object(i).Results(1).Variability);
    for j=1:numSubsets
        inSubset=false(1,numSamples);
        inSubset(Subsets{2*(i-1)+j})=true;
        keep=inSubset & sum(keep_cutoff,1);
        Variabilities{i,j}=CADS_object(i).Results(1).Variability(:,keep);
        Residue_Numbers{i,j}={CADS_object(i).Keep(1).Alignment(keep),...
        CADS_object(i).Keep(2).Alignment(keep)};
        figure(MaxCurrentFigure+i) 
        hold on
        plot(find(keep),Variabilities{i,j},PlotSymbols{mod(j,numPlotSymbols)})
    end
    hold off
    xlabel('Alignment Index')
    ylabel('Entropy')
    title(sprintf('%s Filtered @ %g',CADS_object(i).Name,Var_cutoff))
end


end


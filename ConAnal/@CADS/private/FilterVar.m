function [keep_cutoff,Var_cutoff,F] = FilterVar(CADS_object,varargin)

%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Var_cutoff=inf;
% PlotSymbols={'b^','rv','cs','md'};
freq_filter=false;

if nargin >2
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'cutoff'
                Var_cutoff=varargin{2*ind};
            case 'FreqFilter'
                freq_filter=true;
                
                if isempty(varargin{2*ind})
                    sele_class=true(size(CADS_object(1).Settings.Alignment.Classes,2),1);
                elseif varargin{2*ind}{1}==0
                    sele_class=true(size(CADS_object(1).Settings.Alignment.Classes,2),1);
                else
                    sele_class=varargin{2*ind}{1};
                end
                
                if isempty(varargin{2*ind})
                    class_cutoff=0;
                else
                    class_cutoff=varargin{2*ind}{2};
                end
                Var_cutoff=class_cutoff;
        end
    end
end

% numPlotSymbols=length(PlotSymbols);
numDataSets=length(CADS_object);

% Variabilities=cell(numDataSets,1);
% Residue_Numbers=cell(numDataSets,1);
keep_cutoff=cell(numDataSets,1);
F=cell(numDataSets,1);

for i=1:numDataSets
    [~,~,F{i}]=Entropy(CADS_object(i),varargin{:});
    if freq_filter
        keep_cutoff{i}=sum(F{i}(sele_class,:) > class_cutoff,1);
    else
        keep_cutoff{i}=CADS_object(i).Results(1).Variability < Var_cutoff;
    end
    %     numSamples=length(CADS_object(i).Results(1).Variability);
    %     figure()
    %     for j=1:length(CADS_object(i).Subsets)
    %         inSubset=false(1,numSamples);
    %         inSubset(CADS_object(i).Subsets{j})=true;
    %         keep=inSubset & keep_cutoff{i};
    %         Variabilities{i}{j}=CADS_object(i).Results(1).Variability(:,keep);
    %         Residue_Numbers{i}{j}={CADS_object(i).Keep(1).Alignment(keep),...
    %         CADS_object(i).Keep(2).Alignment(keep)};
    % %         hold on
    %         plot(find(keep),Variabilities{i}{j},PlotSymbols{mod(j,numPlotSymbols)})
    % end
    %     hold off
    %     xlabel('Alignment Index')
    %     ylabel('Entropy')
    %     title(sprintf('%s Filtered @ %g',CADS_object(i).Name,Var_cutoff))
end


end


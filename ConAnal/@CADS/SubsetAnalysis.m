function [ Stats] = SubsetAnalysis(CADS_object,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% index=1;

WhiskerLength=1.5;
VarInterestL=CADS_object(1).Settings.Subsets.VariableNames;

VarInterest=cell(length(CADS_object),1);
DisplayOpt=CADS_object(1).Settings.Subsets.DisplayPlots;


if nargin >1
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'VarInterest'
                switch lower(varargin{2*ind})
                    case 'positive_charge'
                        [ VarInterest ] = ChargeCounts(CADS_object,'positive');
                        VarInterestL='Charge';
                    case 'negative_charge'
                        [ VarInterest ] = ChargeCounts(CADS_object,'negative');
                        VarInterestL='Charge';
                    case 'net_charge'
                        [ VarInterest ] = ChargeCounts(CADS_object,'net');
                        VarInterestL='Charge';
                    case 'residuals'
                        VarInterestL='Residuals';
                        for i=1:length(CADS_object)
                            VarInterest{i}=CADS_object(i).Residuals;
                        end
                    case 'residuals2'
                        VarInterestL='Residuals2';
                        for i=1:length(CADS_object)
                            VarInterest{i}=CADS_object(i).Residuals.^2;
                        end
                    otherwise
                        VarInterestL='other';
                        VarInterest=varargin{2*ind};
                end
            case 'DisplayOpt'
                DisplayOpt=varargin{2*ind};
        end
    end
end

if strcmpi(VarInterestL,'Variability')
    for i=1:length(CADS_object)
        VarInterest{i}=CADS_object(i).Results(1).Variability';
    end
end
[V,Gc,GLabels]=BreakSubset(CADS_object,VarInterest,varargin{:});


X=cell2mat(vertcat(V{:}));
%group=cell2mat(G);
cgroup=cell2mat(vertcat(Gc{:}));
b=vertcat(GLabels{:});
gLabels=vertcat(b{:});
if strcmp(DisplayOpt,'on')
    figure()
    boxplot(X,gLabels,'Notch','on','colorgroup',cgroup,'whisker',WhiskerLength)
end
[Stats.p,Stats.t,Stats.st]=anova1(X,gLabels,DisplayOpt);
[Stats.c,Stats.m] = multcompare(Stats.st,'display',DisplayOpt);
CADS_object(1).Stats=Stats;


end
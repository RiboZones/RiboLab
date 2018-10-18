function [ H_CoVar, F_CoVar,MostFreqBasePair,Dyads ] = PASE( Alignment,ResidueList, BP_rv, BP_Types_Filter, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%BasePairClasses={{'CG','GC','AU','UA','GA','AG','GU','UG','AC','CA','UU','UC','CU'}};
BasePairClasses={{'CG','GC','AU','UA','GU','UG'}};

FreqCutoff=0.501;

if nargin > 4
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'BasePairClasses'
                BasePairClasses=varargin{2*ind};
            case 'FreqCutoff'
                FreqCutoff=varargin{2*ind};
        end
    end
end

numClasses=length(BasePairClasses);

BP_types=BP_rv(:,3);
[~,I]=ismember(lower(BP_types),lower(BP_Types_Filter));
H_CoVar=zeros(1,length(Alignment(1).Sequence));
F_CoVar=cell(1,length(Alignment(1).Sequence));
MostFreqBasePair=repmat({{''}},[1,length(Alignment(1).Sequence)]);

Seqs=vertcat(Alignment.Sequence);
[~,BasePairedRes_i]=ismember(BP_rv(logical(I),1),ResidueList);
[~,BasePairedRes_j]=ismember(BP_rv(logical(I),2),ResidueList);
%Ignore BasePairedRes's with indices past the alignment, but this should no
%longer happen.
keep=BasePairedRes_i < size(Seqs,2) & BasePairedRes_j < size(Seqs,2);
BasePairedRes_i=BasePairedRes_i(keep);
BasePairedRes_j=BasePairedRes_j(keep);

Dyads(:,:,1)=Seqs(:,BasePairedRes_i);
Dyads(:,:,2)=Seqs(:,BasePairedRes_j);
H_CoVar=H_CoVar - 1;
F=zeros(numClasses + 1,1);
for i=1:size(Dyads,2)
    A=cellstr([Dyads(:,i,1),Dyads(:,i,2)]);
    [u,~,n] = unique(A(:));
    for j=1:numClasses
        F(j)=sum(ismember(A,BasePairClasses{j}))/size(Dyads,1);
    end
    F(j+1)=1-sum(F(1:j));
    Pl_Shannon=F.*(log2(F));
    Pl_Shannon(isnan(Pl_Shannon))=0;
    if F(1) >= FreqCutoff
        H_CoVar(BasePairedRes_i(i))=-sum(Pl_Shannon);
        H_CoVar(BasePairedRes_j(i))=-sum(Pl_Shannon);
    else
        H_CoVar(BasePairedRes_i(i))=-2;
        H_CoVar(BasePairedRes_j(i))=-2;
    end
    F_CoVar{BasePairedRes_i(i)}=F;
    F_CoVar{BasePairedRes_j(i)}=F;
    
    MostFreqBasePair{BasePairedRes_i(i)}=u(mode(n));
    MostFreqBasePair{BasePairedRes_j(i)}=u(mode(n));
end
  
        
end

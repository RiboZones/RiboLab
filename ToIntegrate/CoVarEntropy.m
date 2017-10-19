function [ H_CoVar, F_CoVar,MostFreqBasePair,Dyads ] = CoVarEntropy( Alignment, BPTables, BP_Types_Filter, CoVarMode, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Assumes dedupped tables.

BasePairClasses={{'CG','GC','AU','UA','GA','AG','GU','UG','AC','CA','UU','UC','CU'}};
AllPairs={'AA','AC','AG','AU','CA','CC','CG','CU','GA','GC','GG','GU','UA','UC','UG','UU'};
FreqCutoff=0.95;
CombineSymmetry=false;

if nargin > 4
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'BasePairClasses'
                BasePairClasses=varargin{2*ind};
            case 'FreqCutoff'
                FreqCutoff=varargin{2*ind};
            case 'SpeciesFilter'
                SpeciesFilter=varargin{2*ind};
            case 'CombineSymmetry'
                CombineSymmetry=varargin{2*ind};
        end
    end
end

H_CoVar=cell(1,1);
F_CoVar=cell(1,1);
MostFreqBasePair=cell(1,1);
numClasses=length(BasePairClasses);

BP=vertcat(BPTables{:});
BP_types=BP(:,4);
[~,I]=ismember(lower(BP_types),lower(BP_Types_Filter));
H_CoVar{1}=zeros(1,length(Alignment(1).Sequence));
F_CoVar{1}=cell(1,length(Alignment(1).Sequence));
MostFreqBasePair{1}=repmat({{''}},[1,length(Alignment(1).Sequence)]);

switch CoVarMode
    case 'isBasePaired'
        if length(sort(str2double(vertcat(BP(logical(I),2),BP(logical(I),3))))) ~= ...
                length(unique(str2double(vertcat(BP(logical(I),2),BP(logical(I),3)))))
            error('Duplications found!');
        end
        H_CoVar{1}(unique(str2double(vertcat(BP(logical(I),2),BP(logical(I),3)))) + 1)=1; % +1 is because MATLAB uses 1 indexing, not 0-indexing.
    case 'SimpleDifferenceEntropy'
        ConservationProfile=seqprofile(Alignment,'Alphabet','NT','Gaps','all')';
        ConservationProfile_Comp=ConservationProfile(:,[4,3,2,1,5]);
        BasePairedRes_i=str2double(BP(logical(I),2)) + 1;
        BasePairedRes_j=str2double(BP(logical(I),3)) + 1;
        DeltaFreq=abs(ConservationProfile(BasePairedRes_i,:)-ConservationProfile_Comp(BasePairedRes_j,:));
        H_CoVar{1}=H_CoVar{1} - 1;
        H_CoVar{1}(BasePairedRes_i)=sum(DeltaFreq,2);
        H_CoVar{1}(BasePairedRes_j)=sum(DeltaFreq,2);
    case 'DyadEntropy'
        Seqs=vertcat(Alignment.Sequence);
        BasePairedRes_i=str2double(BP(logical(I),2)) + 1;
        BasePairedRes_j=str2double(BP(logical(I),3)) + 1;
        Dyads(:,:,1)=Seqs(:,BasePairedRes_i);
        Dyads(:,:,2)=Seqs(:,BasePairedRes_j);
        H_CoVar{1}=H_CoVar{1} - 1;
        for i=1:size(Dyads,2)
            A=cellstr([Dyads(:,i,1),Dyads(:,i,2)]);
            if CombineSymmetry
                for j = 1: length(A)
                    A{j}=sort(A{j});
                end
            end
            
            [u,~,n] = unique(A(:));
            B = accumarray(n, 1, [], @sum);
            F=B/size(Dyads,1);
            
            Pl_Shannon=F.*(log2(F));
            Pl_Shannon(isnan(Pl_Shannon))=0;
            
            H_CoVar{1}(BasePairedRes_i(i))=-sum(Pl_Shannon);
            H_CoVar{1}(BasePairedRes_j(i))=-sum(Pl_Shannon);
            
            F_CoVar{1}{BasePairedRes_i(i)}=F;
            F_CoVar{1}{BasePairedRes_j(i)}=F;
            
            MostFreqBasePair{1}{BasePairedRes_i(i)}=u(mode(n));
            MostFreqBasePair{1}{BasePairedRes_j(i)}=u(mode(n));
        end
    case 'ByTypes'
        Seqs=vertcat(Alignment.Sequence);
        BasePairedRes_i=str2double(BP(logical(I),2)) + 1;
        BasePairedRes_j=str2double(BP(logical(I),3)) + 1;
        %Ignore BasePairedRes's with indices past the alignment. These will
        %typically be 5S, because I don't have 5S in my alignments yet.
        keep=BasePairedRes_i < size(Seqs,2) & BasePairedRes_j < size(Seqs,2);
        BasePairedRes_i=BasePairedRes_i(keep);
        BasePairedRes_j=BasePairedRes_j(keep);
        
        Dyads(:,:,1)=Seqs(:,BasePairedRes_i);
        Dyads(:,:,2)=Seqs(:,BasePairedRes_j);
        H_CoVar{1}=H_CoVar{1} - 1;
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
                H_CoVar{1}(BasePairedRes_i(i))=-sum(Pl_Shannon);
                H_CoVar{1}(BasePairedRes_j(i))=-sum(Pl_Shannon);
            else
                H_CoVar{1}(BasePairedRes_i(i))=-2;
                H_CoVar{1}(BasePairedRes_j(i))=-2;
            end
            F_CoVar{1}{BasePairedRes_i(i)}=F;
            F_CoVar{1}{BasePairedRes_j(i)}=F;
            
            MostFreqBasePair{1}{BasePairedRes_i(i)}=u(mode(n));
            MostFreqBasePair{1}{BasePairedRes_j(i)}=u(mode(n));
        end
    case 'WeightedClasses'
        BasePairClasses={{'CG','GC'},{'AU','UA'},{'GA','AG','GU','UG'},{'AC','CA','UU'},...
            {'--','A-','-A','C-','-C','U-','-U','G-','-G'}}; %Classify different base pair types.
        numClasses=length(BasePairClasses) + 1; % For now, there are 5 classes as above, plus all others
        
        %Species filter in this mode only for now
        if exist('SpeciesFilter','var')
            Seqs=vertcat(Alignment(SpeciesFilter).Sequence); %Get the sequences
        else
            Seqs=vertcat(Alignment.Sequence); %Get the sequences
        end
        
        BasePairedRes_i=str2double(BP(logical(I),2)) + 1; % Get paired indices
        BasePairedRes_j=str2double(BP(logical(I),3)) + 1;
        Dyads(:,:,1)=Seqs(:,BasePairedRes_i); %Prepare variable to hold all basepairs
        Dyads(:,:,2)=Seqs(:,BasePairedRes_j);
        H_CoVar{1}=H_CoVar{1} - 1; % Start from negative one, so that singles stay -1.
        F=zeros(numClasses,1);
        for i=1:size(Dyads,2) %loop through each base pair
            A=cellstr([Dyads(:,i,1),Dyads(:,i,2)]); % the ith base pair
            for j=1:numClasses - 1
                F(j)=sum(ismember(A,BasePairClasses{j}))/size(Dyads,1); % Calculates frequency of occurence for each defined class
            end
            F(j+1)=1-sum(F(1:j)); % Leftover must be the other class.
            
            % For now this is plain Shannon, no weights. lets see what
            % happens.
            Pl_Shannon=F.*(log2(F));
            Pl_Shannon(isnan(Pl_Shannon))=0;
            
            % Divide by log2(numClasses) to normalize min max to [0,1]
            Pl_Shannon_n=Pl_Shannon/log2(numClasses);
            
            W_class=[1,1,2,3,5,4]'; %Inter-class weights;
            
            Pl_Shannon_w = W_class .* Pl_Shannon_n;
            H_CoVar{1}(BasePairedRes_i(i))=-sum(Pl_Shannon_w);
            H_CoVar{1}(BasePairedRes_j(i))=-sum(Pl_Shannon_w);
            
        end
        
        
    case 'FrequencyByType'
        Seqs=vertcat(Alignment.Sequence);
        BasePairedRes_i=str2double(BP(logical(I),2)) + 1;
        BasePairedRes_j=str2double(BP(logical(I),3)) + 1;
        Dyads(:,:,1)=Seqs(:,BasePairedRes_i);
        Dyads(:,:,2)=Seqs(:,BasePairedRes_j);
        H_CoVar{1}=H_CoVar{1} - 1;
        for i=1:size(Dyads,2)
            A=cellstr([Dyads(:,i,1),Dyads(:,i,2)]);
            [U,~,n] = unique(A(:));
            B = accumarray(n, 1, [], @sum);
            DyadFreq = max(B)/size(Dyads,1);
            if (DyadFreq >= FreqCutoff)
                MostFreqDyad=U(B == max(B));
                [~,I]=ismember(MostFreqDyad,AllPairs);
                H_CoVar{1}(BasePairedRes_i(i))=I;
                H_CoVar{1}(BasePairedRes_j(i))=I;
            else
                H_CoVar{1}(BasePairedRes_i(i))=-1;
                H_CoVar{1}(BasePairedRes_j(i))=-1;
            end
        end
        
    otherwise
        error('Case not recognized');
end
end

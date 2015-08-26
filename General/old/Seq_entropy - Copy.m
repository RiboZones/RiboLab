function [ Mutation_Entropy, Shannon_Entropy, F ] = Seq_entropy(Alignment,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Set default options
Method='shannon';
Gaps=false();
gap_mode='ignore';
ambiguous='Prorate';
% Q=[];
normalize_flag=false();
P21_frac=[0.3,0.5,0.7];
num_iterations=1;
% relative=false();
%% Deal with optional variables
if nargin >1
    for ind=1:length(varargin)/2
        switch varargin{2*ind-1}
            case 'Method'
                Method=varargin{2*ind};
            case 'Gaps'
                Gaps=varargin{2*ind};
            case 'Gap_mode'
                gap_mode=varargin{2*ind};
            case 'Ambiguous'
                ambiguous=varargin{2*ind};
%             case 'Q'
%                 Q=varargin{2*ind};
            case 'ClassFile'
                if ~isempty(varargin{2*ind})
                    data=importdata(varargin{2*ind});
                    data.data(isnan(data.data))=0;
                    classes=data.data;
                end
            case 'Normalize'
                normalize_flag=varargin{2*ind};
%             case 'num_iterations'
%                 num_iterations=varargin{2*ind};
        end
    end
end
%% Reformat Alignment
Sequences=char({Alignment.Sequence}')';
%% Guess if nucleic acid or protein
NAseq=sum(ismember(cellstr(Sequences(:,1)),{'A','T','U','G','C','-'}))/size(Sequences,1) > 0.9;
%% Set default classification (individiual residues in each class)
if ~exist('classes','var')
    if NAseq
        classes=eye(4);
    else
        classes=(eye(20));
    end
end
%% Set size variables
L=size(Sequences,1);
N=size(Sequences,2);
S=size(classes,2);
%% Compute Population Fraction
if NAseq
    for i=L:-1:1;
        Counts(i)=basecount(Sequences(i,:),'Ambiguous',ambiguous,'Gaps',Gaps);
    end
else
    for i=L:-1:1;
        Counts(i)=aacount(Sequences(i,:),'Ambiguous',ambiguous,'Gaps',Gaps);
    end
end

Freqs=squeeze(cell2mat(struct2cell(Counts)))/N;
gap_penalty=ones(1,L);
%% Deal with Gaps?
if Gaps
    
else
    switch gap_mode
        case 'ignore'
            normalize_flag=true();
        case 'prorate'
            Freqs=Freqs+repmat((1-sum(Freqs))/S,S,1);
            Freqs(Freqs<0)=0;
        case 'penalize'
            gap_penalty=sum(Freqs);
    end
end
%% Classify residues
F=zeros(S,L);
for j=1:S
    F(j,:)=sum(Freqs(logical(classes(:,j)),:),1);
end
if normalize_flag
    F=F./repmat(sum(F,1),S,1);
end
%% Convert F to P_Shannon
P_Shannon=zeros(S,S,L);
for l=1:L
    P_Shannon(:,:,l)=repmat(F(:,l)',S,1);
end
%% Convert F to P_mutation
Q=ones(S,S,L);

switch lower(Method)
    case 'shannon'
        P_mutation={P_Shannon};
    case 'p21_frac'
        num_iterations=length(P21_frac);
        if S~=2
            error('p21_frac mode is currently only supported for a two class model')
        else
            P21max=F(1,:)./(1-F(1,:));
            P21max(P21max>1)=1;
            P_mutation=cell(1,num_iterations);
            for i=1:num_iterations
                P21=P21_frac(i)*P21max;
                P_mutation{i}=zeros(S,S,L);
                P_mutation{i}(2,1,:)=P21;
                P_mutation{i}(2,2,:)=1-P21;
                P_mutation{i}(1,2,:)=P21.*F(2,:)./F(1,:);
                P_mutation{i}(1,1,:)=1-P_mutation{i}(1,2,:);
            end
        end
    case 'p21_rand'
%         num_iterations=length(P21_frac);
        if S~=2
            error('p21_rand mode is currently only supported for a two class model')
        else
            P21max=F(1,:)./(1-F(1,:));
            P21max(P21max>1)=1;
            P_mutation=cell(1,num_iterations);
            for i=1:num_iterations
                P21=rand(1,L).*P21max;
                P_mutation{i}=zeros(S,S,L);
                P_mutation{i}(2,1,:)=P21;
                P_mutation{i}(2,2,:)=1-P21;
                P_mutation{i}(1,2,:)=P21.*F(2,:)./F(1,:);
                P_mutation{i}(1,1,:)=1-P_mutation{i}(1,2,:);
            end
        end
    case 'prand'
        %Unsure about this one, need to look into it
    case 'blosum'
        %this needs work
        load Q35;
        Q=repmat(Q35,[1,1,L]);
        P_mutation={P_Shannon};
end
%% Calculate Shannon_Entropy from P_Shannon
Pl_Shannon=P_Shannon.*(log(P_Shannon));
Pl_Shannon(isnan(Pl_Shannon))=0;
H_sh=-sum(Pl_Shannon,2)/log(2);
Shannon_Entropy=sum(F .* squeeze(H_sh),1)./gap_penalty;
%% Calculate Mutation_Entropy from P_mutation
Pl_mutation=cell(1,num_iterations);
H_mut=cell(1,num_iterations);
Mutation_Entropy=cell(1,num_iterations);
for i=1:num_iterations
    Pl_mutation{i}=P_mutation{i}.*(log(P_mutation{i}./Q));
    Pl_mutation{i}(isnan(Pl_mutation{i}))=0;
    H_mut{i}=-sum(Pl_mutation{i},2)/log(2);
    Mutation_Entropy{i}=sum(F .* squeeze(H_mut{i}),1)./gap_penalty;    
end

%% old code
% switch Method

%         
%     case 'Lichtarge35'
%         dSequences=double(lower(Sequences));
%         numAA=20;
%         N=zeros(numAA,numAA,size(Sequences,1));
%         Haa=zeros(numAA,numAA,size(Sequences,1));
%         MaxPairs=length(Alignment)*(length(Alignment)-1)/2;
%         H_w_gaps=hist(dSequences',21);
%         H=H_w_gaps(2:end,:);
%         Hgaps=H_w_gaps(1,:);
% %         if strcmpi(Gaps,'false')
% %             H=H(2:end,:);
% %         end
% %             %numAA=21;
% %         else
% %             %dSequences(dSequences==45)=NaN;
% %         end
% %         
% %         %dSequences=dSequences-96;
% %         %H=hist(dSequences',numAA);
%         for l=1:size(N,3)
%             for h=1:numAA
%                 for k=1:h-1
%                     N(h,k,l)=H(h,l)*H(k,l);
%                 end
%                 N(h,h,l)=H(h,l)*(H(h,l)-1)/2;
%             end
%         end
%        %Feature, count only non-gapped sequences in Max pairs??
%         P=N/MaxPairs;
%         Hl=zeros(1,size(N,3));
%         for l=1:size(N,3)
%             Haa(:,:,l)=P(:,:,l).*log(P(:,:,l)./Q);
%             Haa_single=Haa(:,:,l);            
%             Haa_single(isnan(Haa_single))=0;
%             for h=1:20
%                 Hl(l)=Hl(l)-sum(Haa_single(h,1:h));
%             end
%                     
%         end
%         if strcmpi(Gaps,'true')
%             fGaps=Hgaps/length(Alignment);
%             Variability=Hl+abs(Hl./(1-fGaps)-Hl);
% %             fGaps.*abs(Hl)
% %             Variability=Hl./(1-fGaps);
%         else
%             Variability=Hl;
%         end
%     case {'Manny2','Manny20'}

%         figure()
%         subplot(2,1,1),plot(Variability)
%         %legend({'30% P21Max','50% P21Max','70% P21Max','Shannon'},'Location','EastOutside')
%         xlabel('Alignment Index')
%         ylabel('Entropy')
%         title('Various Entropy Measures for Ribosomal Protein ')
%         h=get(gca,'Children');
%         set(h(1),'Color','k')
%         set(h(1),'LineWidth',2)
%         
%         subplot(2,1,2),plot(Variability(:,end),Variability(:,1:end),'.')    
% %         legend({'0.1%','1%','10%','30% P21Max','50% P21Max','70% P21Max','90%','99%','99.9%','Shannon'},'Location','NorthWest')
% %         legend on        
%         xlabel('Shannon Entropy')
%         ylabel('Entropy')        
%         title('Various Entropy Measures vs. Shannon Entropy [Correlation Plot]')
%         h=get(gca,'Children');
%         set(h(1),'Color','k')
%         set(h(1),'LineWidth',2)
%         
%         Variability=Variability';
%     case 'mutation-based'
%         
%         
%         
% end


end
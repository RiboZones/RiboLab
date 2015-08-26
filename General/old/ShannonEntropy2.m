function [ Mutation_Entropy, Shannon_Entropy, F ] = ShannonEntropy2(Alignment,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Set default options
Method='shannon';
Gaps=false();
gap_mode='ignore';
ambiguous='Prorate';
% Q=[];
normalize_flag=false();
% num_iterations=3;
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
switch lower(Method)
    case 'shannon'
        P_mutation=P_Shannon;
    case 'pmax'
        if S~=2
            error('P_Max mode is currently only supported for a two class model')
        else
            
        end
        %             %         f1(f1==1)=.5;
%             P21max=f1./(1-f1);
%             P21max(P21max>1)=1;
%             I=[0.3,0.5,0.7,0.9];
%             %         c=colormap;
%             Variability=zeros(size(Sequences,1),length(I)+1);
%             F=[f1;1-f1];
%             for i=1:length(I)
%                 P21=I(i)*P21max;
%                 P=zeros(2,2,size(Sequences,1));
%                 P(2,1,:)=P21;
%                 P(2,2,:)=1-P21;
%                 P(1,2,:)=P21.*(1-f1)./f1;
%                 P(1,1,:)=1-P(1,2,:);
    case 'prand'
    
    case 'blosum'
        
end
% P_mutation=zeros(S,S,L);
% for l=1:L
%     P_mutation(:,:,l)=repmat(F(:,l)',S,1);
% end
%% Calculate Shannon_Entropy from P_Shannon
Pl_Shannon=P_Shannon.*(log(P_Shannon));
Pl_Shannon(isnan(Pl_Shannon))=0;
H_sh=-sum(Pl_Shannon,2)/log(2);
Shannon_Entropy=sum(F .* squeeze(H_sh),1)./gap_penalty;
%% Calculate Mutation_Entropy from P_mutation
Pl_mutation=P_mutation.*(log(P_mutation));
Pl_mutation(isnan(Pl_mutation))=0;
H_mut=-sum(Pl_mutation,2)/log(2);
Mutation_Entropy=sum(F .* squeeze(H_mut),1)./gap_penalty;

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
%         %hard code in two classes, hydrophobic for now
%  
%         if sum(ismember(cellstr(Sequences(1,:)'),{'A','T','U','G','C','-'})) / ...
%                 length(Sequences(1,:)) > 0.9
%             Counts(size(Sequences,1))=basecount(Sequences(size(Sequences,1),:),...
%                 'Ambiguous','individual','Gaps',Gaps);
%             for i=1:size(Sequences,1)-1;
%                 Counts(i)=basecount(Sequences(i,:),'Ambiguous','individual','Gaps',Gaps);
%             end
%         else
%             Counts(size(Sequences,1))=aacount(Sequences(size(Sequences,1),:),'Gaps',Gaps);
%             for i=1:size(Sequences,1)-1;
%                 Counts(i)=aacount(Sequences(i,:),'gaps',Gaps);
%             end
%         end
%      
%         if strcmp(Method,'Manny2')
%             Freqs=squeeze(cell2mat(struct2cell(Counts)))/size(Sequences,2);
%             %         if size(classes,2)==2
%             %
%             %
%             %         else
%             %             classes=zeros(20,2);
%             %             classes(:,1)=[1 0 0 0 0 0 0 1 0 1 1 0 1 1 1 0 0 1 1 1];
%             %             classes(:,2)=~[1 0 0 0 0 0 0 1 0 1 1 0 1 1 1 0 0 1 1 1];
%             %         end
%             
%             %hard code, divide freqs into hydrophobic, hydrophillic
%             %         hydrophobic=logical([1 0 0 0 0 0 0 1 0 1 1 0 1 1 1 0 0 1 1 1]);
%             f1=sum(Freqs(logical(classes(:,1)),:));
%             
%             if normalize_flag
%                 f2=sum(Freqs(logical(classes(:,2)),:));
%                 f1=f1./(f1+f2);
%             end
%             
%             %         f1(f1==1)=.5;
%             P21max=f1./(1-f1);
%             P21max(P21max>1)=1;
%             I=[0.3,0.5,0.7,0.9];
%             %         c=colormap;
%             Variability=zeros(size(Sequences,1),length(I)+1);
%             F=[f1;1-f1];
%             for i=1:length(I)
%                 P21=I(i)*P21max;
%                 P=zeros(2,2,size(Sequences,1));
%                 P(2,1,:)=P21;
%                 P(2,2,:)=1-P21;
%                 P(1,2,:)=P21.*(1-f1)./f1;
%                 P(1,1,:)=1-P(1,2,:);
%                 
%                 Hi=-sum(P.*(log(P)),2)/log(2);
%                 Variability(:,i)=sum(F.*squeeze(Hi))';
%                 %             Variability(:,i)=variability';
%             end
%             Variability(isnan(Variability))=0;
%             %         Variability=sum(repmat(Hi',1, length(Freqs)) .* Freqs);
%             %         Hi=-1/log(2)*sum(Q.*log(Q));
%             F(F==0)=NaN;
%             H=F.*log2(F);
%             H(isnan(H))=0;
%             variability=-sum(H,1)';
%             Variability(:,end)=variability;
%         else
%            classes=[eye(20);0.05*ones(1,20)];
%            Variability=mutation_entropy(Sequences,classes,num_iterations)/log(2);
%         end
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
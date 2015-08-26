function  [ KeepAccession,KeepTaxID] = AlignFromTaxID(QuerySequences,TaxID_file)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

exclude_organellar=true;

%% Read Tax ID's and convert into an Entrez Query
TaxIDs=xlsread(TaxID_file);
numSpecies=length(TaxIDs);


Query=cell(numSpecies,1);
for i=1:numSpecies
    Query{i}=[' OR (txid',num2str(TaxIDs(i)),'[Organism])'];
end
Query{1}(1:3)=[];
QueryString=horzcat(Query{:});

if exclude_organellar
    QueryString=[QueryString,' NOT (mitochondrial[All] OR chloroplastic[All] OR plastid[All])'];
end

%% Loop through query sequences, expressed as accession codes
numQuerySeqs=length(QuerySequences);
RID=cell(numQuerySeqs,1);
Sequences=cell(numQuerySeqs,1);
KeepAccession=cell(numQuerySeqs,1);
KeepTaxID=cell(numQuerySeqs,1);

for query_ind=1:numQuerySeqs
    %% Submit BLAST report
    
    %determine Domain of query sequences
    QuerySeq{query_ind} = getgenpept(QuerySequences{query_ind}); 
    DomainQuery{query_ind}=regexp(QuerySeq{query_ind}.SourceOrganism(2,:),'([^;]+);','once','tokens');
    [RID{query_ind},RTOE] = blastncbi(QuerySequences{query_ind}, 'blastp','Entrez',QueryString,'Alignments',10*numSpecies);
    
    %% Read BLAST report
    done=false;
    while ~done
        try
            getblast(RID{query_ind}, 'WaitTime',2*RTOE','format','xml','ToFile' ,[QuerySequences{query_ind},'_BLAST.xml']);
            done=true();    
        catch ErrMsg
            disp(42)
        end
        
    end
    V = xml_parseany(fileread([QuerySequences{query_ind},'_BLAST.xml']));
    
    %% Process BLAST report
    
    numHits=length(V.BlastOutput_iterations{1}.Iteration{1}.Iteration_hits{1}.Hit);
    Accession=cell(1,numHits);
    Seq=cell(1,numHits);
    FoundTaxID=cell(1,numHits);
    Evalues=cell(1,numHits);
    
    % Query=cell(1,numSpecies);
    for i=1:numHits
        Accession{i}=V.BlastOutput_iterations{1}.Iteration{1}.Iteration_hits{1}.Hit{i}.Hit_accession{1}.CONTENT;
        Seq{i} = getgenpept(Accession{i});
        FoundTaxID(i)=regexp(reshape(Seq{i}.Features',1,[]),'"taxon:([0-9]+)"','tokens');
        Evalues{i}=V.BlastOutput_iterations{1}.Iteration{1}.Iteration_hits{1}.Hit{i}.Hit_hsps{1}.Hsp{1}.Hsp_evalue{1}.CONTENT;
    end
    
    EValues=str2double(Evalues);
    FoundTaxIDs=str2double([FoundTaxID{:}]);
    [uniqTaxIDs,I]=unique(FoundTaxIDs);
    
    %% Filter by domain
    if numQuerySeqs>1
       %assuming it's 3 for now
       DomainHits=cell(length(I),1);
       for k=1:length(I)
           DomainHits(k)=regexp(Seq{I(k)}.SourceOrganism(2,:),'([^;]+);','once','tokens');
       end   
        uniqTaxIDs(~ismember(DomainHits,DomainQuery{query_ind}))=[];
    end
    
    FoundnumSpecies=length(uniqTaxIDs);
    Sequences{query_ind}(FoundnumSpecies,1)=struct('Header','','Sequence','');
    Pos=zeros(1,FoundnumSpecies);
    for j=1:FoundnumSpecies
        idx=find(FoundTaxIDs==uniqTaxIDs(j));
        [~,I]=min(EValues(idx));
        Pos(j)=idx(I);
        Sequences{query_ind}(j).Header=Seq{Pos(j)}.Source;
        Sequences{query_ind}(j).Sequence=upper(Seq{Pos(j)}.Sequence);
        Sequences{query_ind}(j).Domain=DomainQuery{query_ind};
        Sequences{query_ind}(j).TaxID=uniqTaxIDs(j);


    end
    KeepAccession{query_ind}=Accession(Pos);
    KeepTaxID{query_ind}=FoundTaxIDs(Pos);
    
end

%% Combine into one dataset ????

for query_ind=1:numQuerySeqs
    [~,b]=sort({Sequences{query_ind}.Header});
    Sequences{query_ind}=Sequences{query_ind}(b);
end
Alignment=multialign(vertcat(Sequences{:}));
multialignviewer(Alignment)
distances = seqpdist(Alignment,'Method','Jukes-Cantor');
tree = seqlinkage(distances,'UPGMA',Alignment);
phytreetool(tree)
end
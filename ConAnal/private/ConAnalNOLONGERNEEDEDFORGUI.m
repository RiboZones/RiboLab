function [ CAOut] = ConAnal(gene_list,newcenter,options,...
    shellboundaries,variability_bins)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin <4
    shellboundaries='ribosome';
end
if nargin<5
    variability_bins='standard';
end
if strcmp(gene_list,'aln')
    [FileName,PathName] = uigetfile({'*.aln';'*.*'},'Select the aln File',...
        'MultiSelect', 'off');
    if ~isequal(FileName,0) && ~isequal(PathName,0)
        Alignment = multialignread([PathName,FileName]);       
    end
    
elseif exist('options','var') && isfield(options,'Method') && strcmp(options.Method,'alignment')
    Alignment=multialignread(options.alignment_file);
    
else
    num_genes=length(gene_list);
    Sequences(num_genes).Header=[];
    Sequences(num_genes).Sequence=[];

    for i=1:num_genes
        GenePept(i)=getgenpept(gene_list{i});
        Sequences(i).Sequence=GenePept(i).Sequence;
        source=GenePept(i).Source;
        source(isspace(source))='_';
        Sequences(i).Header=source;
    end

    if exist('options','var') && isfield(options,'Method') && strcmp(options.Method,'clustal')
        if exist([options.Name,'.fa'],'file')
            recycle('on');
            delete([options.Name,'.fa']);
        end
        fastawrite([options.Name,'.fa'],Sequences);
        command=[options.Path,' -INFILE=',options.Name,'.fa',' -OUTORDER=INPUT -QUIET'];
        system(command);
        Alignment=multialignread([options.Name,'.aln']);
    else
        Alignment=multialign(Sequences,'ScoringMatrix','gonnet','GapOpen',...
            10,'ExtendGap',0.2);
    end
end

cSequence=seqconsensus(Alignment,'gaps','all');
Variability=ShannonEntropy(Alignment);
variability=Variability;
cSequenceCut=cSequence;
if ~isempty(newcenter)
    species3D=MatchSequence(Alignment,options.File);
    sequence=Alignment(species3D).Sequence;
    variability(strfind(sequence,'-'))=[];
    cSequenceCut(strfind(sequence,'-'))=[];
end

if exist('options','var') && isfield(options,'File')
    Proteins = BuildProteins(newcenter,shellboundaries,...
        variability_bins,{cSequenceCut},{variability},options.File);
else
    Proteins = BuildProteins(newcenter,shellboundaries,...
        variability_bins,{cSequenceCut},{variability});
end

CAOut=ConAnalOutput(Proteins,Alignment,Variability);
if ~isempty(newcenter)
    CAOut.AddSpecies3D(species3D);
end
end

function species3D=MatchSequence(Alignment,File)
FAM=ImportPDBs(File);
%Warning, this doesn't handle skipped amino acids yet
AllSequences={Alignment(:).Sequence};
[~,I]=unique([FAM{1}.Model.resSeq]);
TargetSequence=aminolookup([FAM{1}.Model(I).resName]);
lenTS=length(TargetSequence);
numSeqs=length(AllSequences);
pmatch=zeros(1,numSeqs);
for i=1:numSeqs
    AllSequences{i}(AllSequences{i}=='-')=[];
    offset=min(strfind(AllSequences{i},TargetSequence(1)))-1;
    numres=length(AllSequences{i});
    if offset+lenTS <= numres
        match=zeros(1,lenTS);
        for j=1:lenTS
            match(j)=TargetSequence(j)==AllSequences{i}(j+offset);
        end
        pmatch(i)=sum(match)/numres;
    end   
end    
[~,species3D]=max(pmatch);
end
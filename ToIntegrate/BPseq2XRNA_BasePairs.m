function [ XRNAstruct ] = BPseq2XRNA_BasePairs( BPseq_file, ShiftBase, ShiftDirection )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%This version is assuming consecutively numbered nucleotides. This works
%for most species, except Thermus thermophilus. At some point we can remove
%this limitation.

%This version only handles one strand of rRNA right now. Will fix later of
%course.

NucsChecked=0;
FoundHelices=0;
helix_length=0;
nuc1=0;
nuc2=0;



if exist(BPseq_file,'file')
    BPseqdata=fileread(BPseq_file);
    XRNAstruct=struct('nucID','','length','','bpNucID','');
else
    XRNAstruct=[];
    return
end

%% Text labels
BPseqs=regexp(BPseqdata,'(?<Nuc1>[\d]+)\s(?<NucLetter>[ACUG])\s(?<Nuc2>[\d]+)','names');

numNuc=length(BPseqs);

CoveredNucs=false(1,numNuc);



while NucsChecked < numNuc
    if ~strcmp(BPseqs(NucsChecked + 1).Nuc2,'0') && ~CoveredNucs(NucsChecked + 1)
        FoundHelices = FoundHelices + 1;
        
        nuc1=str2double(BPseqs(NucsChecked + 1).Nuc1);
        nuc2=str2double(BPseqs(NucsChecked + 1).Nuc2);
        if nuc1 > ShiftBase
            nuc1 = nuc1 + ShiftDirection;
        end
        if nuc2 > ShiftBase
            nuc2 = nuc2 + ShiftDirection;
        end
        XRNAstruct(FoundHelices).nucID=num2str(nuc1);
        XRNAstruct(FoundHelices).bpNucID=num2str(nuc2);
        
        while ~strcmp(BPseqs(NucsChecked + 1).Nuc2,'0')
            CoveredNucs(NucsChecked + 1)=true;
            CoveredNucs(str2double(BPseqs(NucsChecked + 1).Nuc2))=true;
            NucsChecked = NucsChecked + 1;
            helix_length = helix_length + 1;
        end
        XRNAstruct(FoundHelices).length=helix_length;
        helix_length=0;
        
    else
         CoveredNucs(NucsChecked + 1)=true;
         NucsChecked = NucsChecked + 1;
       
    end
    
    
end

end

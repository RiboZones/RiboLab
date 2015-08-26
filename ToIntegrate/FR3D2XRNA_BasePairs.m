function [ XRNAstruct ] = FR3D2XRNA_BasePairs( FR3D_file )
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

FR3Ddata=fileread(FR3D_file);

%% Text labels
FR3Dpairs=regexp(FR3Ddata,['"[\w\d]{4}\|[\w\d]\|[\w\d]\|(?<NucLetter>[\w])\|(?<Nuc1>[\w\d]+)"',...
    ',"[\w]+","[\w\d]{4}\|[\w\d]\|[\w\d]\|(?<NucLetter2>[\w])\|(?<Nuc2>[\w\d]+)"'],'names');

numNuc=length(FR3Dpairs);

CoveredNucs=false(1,numNuc);

XRNAstruct=struct('nucID','','length','','bpNucID','');

%% Not working. Postponed.
% while NucsChecked < numNuc
%     if ~strcmp(FR3Dpairs(NucsChecked + 1).Nuc2,'0') && ~CoveredNucs(NucsChecked + 1)
%         FoundHelices = FoundHelices + 1;
%         XRNAstruct(FoundHelices).nucID=FR3Dpairs(NucsChecked + 1).Nuc1;
%         XRNAstruct(FoundHelices).bpNucID=FR3Dpairs(NucsChecked + 1).Nuc2;
%         
%         while ~strcmp(FR3Dpairs(NucsChecked + 1).Nuc2,'0')
%             CoveredNucs(NucsChecked + 1)=true;
%             CoveredNucs(str2double(FR3Dpairs(NucsChecked + 1).Nuc2))=true;
%             NucsChecked = NucsChecked + 1;
%             helix_length = helix_length + 1;
%         end
%         XRNAstruct(FoundHelices).length=helix_length;
%         helix_length=0;
%         
%     else
%          CoveredNucs(NucsChecked + 1)=true;
%          NucsChecked = NucsChecked + 1;
%        
%     end
%     
%     
% end

end

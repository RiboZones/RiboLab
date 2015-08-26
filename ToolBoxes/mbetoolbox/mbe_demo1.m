%% MBEToolbox DEMO - Alignment file IO 
% Welcome to MBEToolbox.  This is a demonstration of 
% MBEToolbox's file IO functions.
%
% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007


cd(fileparts(which('mbe_demo1')))
% Current working directory will be changed.

%%
% First, let's just show how to read a FASTA formatted file
% into a MATLAB structure represents an alignment.

if (isunix), slashid='/'; else slashid='\'; end
aln = readfasta(['seq_examples',slashid,'HCV_aligned.fas'],2,1)

%%
% Now let's view the sequences in this alignment.
% 
% Notice MBEToolbox display sequences PHYLIP format by default.

viewseq(aln)

%%
% If you use readfasta function without specify sequence type or genetic 
% code, a dialogue will come up. 

aln = readfasta(['seq_examples',slashid,'HCV_aligned.fas'])

%%
% Make sure the alignment structure is a valid coding sequence alignment...

isvalidaln(aln,'CODING')

%%
% Of course, you can save the alignment into as a new FASTA formatted file.

writefasta(aln,['seq_examples',slashid,'CopyOfHCV_aligned.fas'])

%%
% ...or you may save it as an interleaved PHYLIP formatted file, 

writephylip_i(aln,['seq_examples',slashid,'CopyOfHCV_aligned_I.phy'])

%%
% or as a sequential PHYLIP formatted file.

writephylip_s(aln,['seq_examples',slashid,'CopyOfHCV_aligned_S.phy'])

%%
% Two functions are provided by MBEToolbox for read interleaved or 
% sequential PHYLIP formatted file respectively.

aln2 = readphylip_i(['seq_examples',slashid,'CopyOfHCV_aligned_I.phy'],2,1)
Aln3 = readphylip_s(['seq_examples',slashid,'CopyOfHCV_aligned_S.phy'],2,1)

%%
% If you have a set of unaligned DNA/Protein sequences in FASTA file, 
% MBEToolbox, using its build-in CLUSTALW, can align these sequences 
% and import the alignment.

AlnDNA = alignseqfile('DNA',['seq_examples',slashid,'unaligned_DNA.fas'])
AlnPro = alignseqfile('PROTEIN',['seq_examples',slashid,'unaligned_Protein.fas'])

%%
% MBEToolbox can align coding DNA sequences according to protein alignment.

AlnCDS = alignseqfile('CDS',['seq_examples',slashid,'unaligned_CDS.fas'],1)

%%
% Take a look of the alignment.

viewseq(AlnCDS)

%%
% Thank you for viewing this introduction to MBEToolbox file IO funcation.
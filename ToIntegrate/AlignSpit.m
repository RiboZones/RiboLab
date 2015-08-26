%Read in fasta q file
Seqs_Name=fastqread('WMg_S174_L001_R1_001.fastq');

%Divide set into smaller pieces. Here, we have 12 sets of 1016 sequences. 
numSets=12;
numSeqsSet=1016;
%Check that numbers divide total sequences evenly. 
if numSets * numSeqsSet ~= size(Seqs_Name,2)
	error('numSets x numSeqsSet must equal total number of sequences.')
end

% Calculate indices, set partitioning	
EndIndices=numSeqsSet*[1:numSets]; 
BeginIndices = EndIndices - numSeqsSet + 1;

% pre-allocate a cell array for the results
Aligned_Seqs=cell(1,numSets);

%loop through numSets, computing an alignment for each set
for i=1:numSets
	disp(sprintf('Aligning set %d of %d\n',i,numSets));
	Aligned_Seqs{i}=multialign(Seqs_Name(BeginIndices(i):EndIndices(i))); 
	disp(sprintf('Finished set %d of %d\n',i,numSets));
end

%Exercise for Jessica. Convert this script to a function, make numSets, and numSeqsSet input parameters. 
% Add code to check to see that all alignments in Aligned_Seqs are the same length. If they are, concatenate them. 
% That would look something like this, [Aligned_Seqs{:}]. 
function [ Sequences] = SequenceScramble(fasta_file,num_sequences)
%SequenceScramble Produces random permutations of fasta sequences
%   Function to read in a fasta file and scramble the sequences, optionally
%   producing more than one permutation. 

if nargin < 2
    num_sequences=1;
end
Original=fastaread(fasta_file);
Sequences(length(Original),num_sequences)=struct('Header','','Sequence','');
for i=1:length(Original)
    for j=1:num_sequences
        Sequences(i,j).Sequence=Original(i).Sequence(randperm(length(Original(i).Sequence)));
        Sequences(i,j).Header=[Original(i).Header,' Random Permutation ',num2str(j)];
    end
end
[path,oldname,ext]=fileparts(fasta_file);
newname=[oldname,'_random_permutation(',num2str(num_sequences),')'];
fastawrite(fullfile(path,[newname,ext]),Sequences');

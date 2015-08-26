function [aln2] = translatealn(aln)
%TRANSLATEALN - Translate coding DNA sequence into protein sequence in an alignment
%
% Syntax: [aln2] = translatealn(aln)
%
% Inputs:
%    aln      - Alignment structure (protein-coding nucleotide sequences)
%
% Outputs:
%    aln2     - New alignment structure (protein sequences)
%
% See also: REVERSEALN, REVCOMALN

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007


%if ~(isvalidaln(aln,'CODING'))
%	error ('ERROR: Not coding seq')
%end

aln2=aln;
aln2.seqtype=3;
aln2.seq = translateseq(aln.seq,aln.geneticcode);
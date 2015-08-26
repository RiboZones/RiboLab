function [D,gap]=countntchange(s1,s2)
%COUNTNTCHANGE - Count nucleotide changes in two DNA sequences
%D is a 4x4 array, with bases in seq1 along top, seq2 along side, 
%in order A,C,G,T.
%
% Syntax: [D,gap]=countntchange(s1,s2)
%
% Inputs:
%    s1      - Sequence 1 vector
%    s2      - Sequence 2 vector
%
% Outputs:
%    D       - Codon Adaptation Index value
%    gap     - Codon Adaptation Index value
%
%
% See also: COUNTAACHANGE COUNTCDCHANGE

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 3/28/2006

if (nargout>1)
	[D,gap]=countchange(s1,s2,4);
else
	[D]=countchange(s1,s2,4);
end

function [D,V,GAP]=dp_aadiff(aln)
%DP_AADIFF - Uncorrected distance of protein sequences
%Uncorrected distances
%This method does not make any corrections for multiple substitutions. Therefore, the score
%will be an underestimate of the distance between the sequences. This will not be less significant
%for highly similar sets of sequences.
%
% S = m/(npos + gaps*gap_penalty)                                  (1)
%
% m 	    - score of matches (1 for an exact match, a fraction for partial
% 	      matches and 0 for no match)
% npos	    - number of positions included in m
% gaps        - number of gaps in the sequences
% gap_penalty - the score given to a gapped position
%
% D = uncorrected distance = p-distance = 1-S          (2)
% The score of match includes all exact matches. For nucleotides, if the flag "-ambiguous"
% is used then partial matches are included in the score. For example, a match of M (A or C)
% with A will increment m by 0.5 (0.5*1.0). Gaps are not included in the calculation unless a
% non zero value is given with "-gapweight". 
%
% Syntax: [D,V,GAP]=dp_aadiff(aln)
%
% Inputs:
%    aln          - Alignment structure
%
% Outputs:
%    D      - Distance matrix
%    V      - Distance matrix
%    GAP    - Gap matrix
%
% See also: 

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/3/2006

if (isstruct(aln)), 
	S=aln.seq;
else
	S=aln;
end

[n,m] = size(S);
D = zeros(n);
GAP = zeros(n);



for i=1:n-1
for j=i+1:n
	% D(i,j)=sum(aln.seq(i,:)~=aln.seq(j,:));
	[S,gap] = countaachange(aln.seq(i,:), aln.seq(j,:));
	D(i,j) = sum(sum(S))-sum(diag(S));
	GAP(i,j) = gap;
	D(j,i) = D(i,j);
	GAP(j,i) = GAP(i,j);
end
end

V=D.*(m-D)./m;

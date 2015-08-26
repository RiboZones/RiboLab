function [D,V,GAP] = dn_ntdiff(aln)
%DN_NTDIFF - Number of different nucleotides and gaps between two sequences
%Uncorrected distances
%This method does not make any corrections for multiple substitutions. Therefore, 
%the score will be an underestimate of the distance between the sequences. This 
%will not be less significant for highly similar sets of sequences.
%
% S = m/(npos + gaps*gap_penalty)                                  (1)
%
% m 	    - score of matches (1 for an exact match, a fraction for partial
% 	      matches and 0 for no match)
% npos	    - number of positions included in m
% gaps      - number of gaps in the sequences
% gap_penalty - the score given to a gapped position
%
% D = uncorrected distance = p-distance = 1-S          (2)
%
%
% Syntax: [D,V,GAP]=dn_ntdiff(aln)
%
% Inputs:
%    aln   - Alignment structure
%
% Outputs:
%    D     - Distance matrix
%    V     - (optional) Gap penalty
%    GAP   - (optional) Shape parameter of gamma distribution
%
% See also: 

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/3/2006

if (isstruct(aln)), seq=aln.seq; else seq=aln; end


[n,m] = size(seq);
D = zeros(n);
GAP = zeros(n);



for i=1:n-1
for j=i+1:n
	% D(i,j)=sum(seq(i,:)~=seq(j,:));
	[S,gap] = countntchange(seq(i,:), seq(j,:));
	%D(i,j) = sum(sum(S))-sum(diag(S));
	D(i,j) = sum(sum(S))-trace(S);
	GAP(i,j) = gap;
	D(j,i) = D(i,j);
	GAP(j,i) = GAP(i,j);
end
end

V=D.*(m-D)./m;
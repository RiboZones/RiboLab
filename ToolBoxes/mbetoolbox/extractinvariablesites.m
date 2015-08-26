function [aln2]=extractinvariablesites(aln)
%EXTRACTINVARIABLESITES - Extract invariable sites
%
% Syntax: [aln2]=extractinvariablesites(aln)
%
% Inputs:
%    aln     - Alignment structure
%
% Outputs:
%    aln2     - New alignment including invariable sites only
%
% See also: EXTRACTSEGREGATINGSITES

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

aln2.seqtype = aln.seqtype;
aln2.geneticcode = 0;
aln2.seqnames =	 aln.seqnames;

[n,m] = size(aln.seq);
aln2.seq=zeros(n,0);

k = 0;
for j=1:m
	minnt = min(aln.seq(:,j));
	maxnt = max(aln.seq(:,j));
	if (minnt>0 & maxnt < 5)
		if (minnt==maxnt)
		k = k+1;
		aln2.seq(:,k) = aln.seq(:,j);
		end

	end
end

function [y]=isvalidaln(aln,typestr)
%ISVALIDALN - Validate alignment
%
% [y]=isvalidaln(aln,typestr)

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007


if (nargin<2)
	error = 'typestr is empty.'
end

y=0;
if ~(isstruct(aln))
	return;
else
	if (isempty(aln.seq)), 
		return; 
	end
end

if ~(isaln(aln)), return; end

switch (upper(typestr))
    case ('NUCLEOTIDE')	
	y = (aln.seqtype==1)|(aln.seqtype==2);
	if (any(isnNT(aln.seq))), y = 0; end
    case ('CODING')
	[n,m] = size(aln.seq);
	y = (mod(m,3)==0)&(aln.seqtype==2)&(aln.geneticcode>=1)&(aln.geneticcode<=13);
	if (any(isnNT(aln.seq))), y = 0; end
    case ('CDS')
	[n,m] = size(aln.seq);
	y = (mod(m,3)==0)&(aln.seqtype==2)&(aln.geneticcode>=1)&(aln.geneticcode<=13);
	if (any(isnNT(aln.seq))), y = 0; end
    case ('NONCODING')
	y = (aln.seqtype==1);
	if (any(isnNT(aln.seq))), y = 0; end
    case ('DNA')
	y = (aln.seqtype==1);
	if (any(isnNT(aln.seq))), y = 0; end
    case ('PROTEIN')
	y = (aln.seqtype==3);
	if (any(isnAA(aln.seq))), y = 0; end
    otherwise
	y = 0;
end
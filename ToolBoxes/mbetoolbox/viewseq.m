function viewseq(aln,isaa)
%VIEWSEQ - View sequences
%
% Syntax:  viewseq(aln)
%
% Inputs:
%    aln         - Alignment structure
%
% See also: 

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

if nargin<2
    isaa=0;
end

[NT,AA] = seqcode;
if (isstruct(aln)), 

	[n,m]=size(aln.seq);
	switch (aln.seqtype)
	    case (3)	% Protein
		aln.seq(find(isnAA(aln.seq)))=i_getcode4gap('PROTEIN');
		% AA = 'ARNDCQEGHILKMFPSTWYV*-';
		Seq=AA(aln.seq);
	    otherwise	% nucleotides
		aln.seq(find(isnNT(aln.seq)))=i_getcode4gap('DNA');
		% NT = ['ACGT-'];
		Seq=NT(aln.seq);
	end
			seqnames=aln.seqnames;
else 
	seq=aln; 
	[n,m]=size(seq);
    if (isaa)
	Seq=AA(seq);
    else
	Seq=NT(seq);
    end
	for (k=1:n),
	      seqnames{k}=sprintf(['Seq%d'],k);
	end
end
	fprintf('\n');
	[ssiz,slen]=size(Seq);
	mt = 1:60:slen;
	mt = cat(1,mt',slen+1);
    

	for (j=1:length(mt)-1),
	for (i=1:n),
         xs=char(Seq(i,[mt(j):mt(j+1)-1]));
		if (j==1),            
			name=char(seqnames{i});
			fprintf(['%10s %s\n'], i_name10(name), xs);
		else
			fprintf(['%10s %s\n'], ' ', xs);
		end
	end
		fprintf('\n');
	end


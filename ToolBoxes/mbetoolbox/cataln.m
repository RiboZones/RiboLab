function [aln,pos] = cataln(alnarray,rmgap)
%CATALN - Concatenate alignments

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

if (nargin<2)
 rmgap=0;
end

n=length(alnarray);
aln=alnarray(1,1);
if (rmgap)
	if (aln.seqtype=2)
	   if (hasgap(aln)), aln=rmcodongaps(aln); end
        else
	   if (hasgap(aln)), aln=rmgaps(aln); end
	end
end

pos=zeros(1,n);
pos(1,1)=length(aln.seq);

for (k=2:n),
      alnk=alnarray(1,k);
	if (rmgap)
		if (alnk.seqtype=2)
		   if (hasgap(alnk)), alnk=rmcodongaps(alnk); end
		else
		   if (hasgap(alnk)), alnk=rmgaps(alnk); end
		end
	end

      aln.seq=cat(2, aln.seq, alnk.seq);
      pos(1,k)=size(alnk.seq,2);
end
pos=cumsum(pos);


% regionspos=pos;
% hold on;
% y=0:0.1:1.6;
% for (k=1:length(regionspos)-1),
%       x=ones(1,length(y))*regionspos(k);
%       x=x./3;
%       plot(x,y,'-r');
% end
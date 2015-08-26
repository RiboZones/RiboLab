function [D]=protdist(aln,mdlname)

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

if (nargin<2)
	mdlname='jtt';
end

[n,m] = size(aln.seq);
D = zeros(n);

switch (lower(mdlname))
    case {'jtt'}
	 model=modeljtt;
    case {'dayhoff'}
	model=modeldayhoff;
    case {'wag'}
	model=modelwag;
   otherwise
	model=modeljtt;
end

%	fprintf(['\n']);
for i=1:n
	fprintf(['%s '],aln.seqnames{i});
for j=i:n
if (i~=j)
	s1=aln.seq(i,:);
	s2=aln.seq(j,:);
	D(i,j) = optimseqpairlikeli(model,s1,s2);
	fprintf(['.']);
end
D(j,i) = D(i,j);
end
	fprintf(['\n']);
end
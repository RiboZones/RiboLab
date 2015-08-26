function [y] = decodonise61(x)
%DECODONISE61 - decodonises codonise61 encoded seq (e.g., 1->[1 1 1], 61->[4 4 4])
%used by RANDSEQ2 and MUTATESEQ
%
% See also: CODONISE61

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007


[n,m]=size(x);
y=ones(n,m*3)*5;
[TABLE,CODON] = codontable;
icode=1;
stops=find(TABLE(icode,:)=='*');
	%CODON=[1 1 1; 1 1 2; 1 1 3; 1 1 4; 1 2 1; 1 2 2; 1 2 3; 1 2 4;
	%       1 3 1; 1 3 2; 1 3 3; 1 3 4; 1 4 1; 1 4 2; 1 4 3; 1 4 4;
	%       2 1 1; 2 1 2; 2 1 3; 2 1 4; 2 2 1; 2 2 2; 2 2 3; 2 2 4;
	%       2 3 1; 2 3 2; 2 3 3; 2 3 4; 2 4 1; 2 4 2; 2 4 3; 2 4 4;
	%       3 1 1; 3 1 2; 3 1 3; 3 1 4; 3 2 1; 3 2 2; 3 2 3; 3 2 4;
	%       3 3 1; 3 3 2; 3 3 3; 3 3 4; 3 4 1; 3 4 2; 3 4 3; 3 4 4;
	%       4 1 1; 4 1 2; 4 1 3; 4 1 4; 4 2 1; 4 2 2; 4 2 3; 4 2 4; 
	%       4 3 1; 4 3 2; 4 3 3; 4 3 4; 4 4 1; 4 4 2; 4 4 3; 4 4 4];
	CODON(stops,:)=[];

for (i=1:n),
for (j=1:m),
      c=CODON(x(i,j),:);
      y(i,(j-1)*3+1)=c(1,1);
	  y(i,(j-1)*3+2)=c(1,2);
	  y(i,(j-1)*3+3)=c(1,3);
end
end

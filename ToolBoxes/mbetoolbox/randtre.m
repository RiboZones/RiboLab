function rt = randtre(n)
%RANDTRE - Generates a random tree with n OTUs
%
% Adopted from PHYLLAB toolbox v1.1

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

if (nargin<1), n=3; end
if (n<3), error('Tree should contain at least 3 elements.'); end


otu = randperm(n);
% unite the first pair (in any tree is at least one pare!!)
rt = sprintf('(%d,%d)',otu(1),otu(2));

% process the others
flag = 0;
for i=3:n
	if flag
		flag = 0; 
	else
		if rand > 0.5
			% it's a standalone otu
			rt = sprintf('(%s,%d)',rt,otu(i));
		else
			% it's a paired otu
			if i+1 <= n 
				rt = sprintf('(%s,(%d,%d))',rt,otu(i),otu(i+1));
				flag = 1;
			else
				% it can't be paired, we running out of availible otu's
				rt = sprintf('(%s,%d)',rt,otu(i));
			end;
		end;
	end;
end;

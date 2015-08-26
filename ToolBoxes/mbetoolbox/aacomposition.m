function [n,freq] = aacomposition(s)
%AACOMPOSITION - Counts AA composition
%
% Syntax: [n,freq] = aacomposition(s)
%
% Inputs:
%    s   - Protein sequence(s)
%
% Outputs:
%    n      - 1x20 vector containg number of AAs
%    freq   - Frequencies of n
%
% See also: 

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

[n,m]=size(s);
%if ~(n==1)
%	error('Must be a single sequence.')
%end

n=zeros(1,20);

for (k=1:20),
      n(1,k)=sum(sum(s==k));
end
if (nargout>1), freq=n./sum(n); end

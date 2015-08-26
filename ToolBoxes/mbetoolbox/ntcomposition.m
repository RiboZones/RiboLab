function [N,Nf,NN,NNf] = ntcomposition(s)
%NTCOMPOSITION - Counts nucleotide and dinucleotide composition
%
% Syntax: [N,Nf,NN,NNf] = ntcomposition(s)
%
% Inputs:
%    s   - Nucleotide sequence
%
% Outputs:
%    N     - 1x4 vector containg number of A, C, G, T
%    Nf    - Frequencies of N
%    NN    - 4x4 matrix containg dinucleotide number
%    Nf    - Frequencies of NN
%
% See also: COUNTBASECHANGE, PRINTMATRIX

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

if (isstruct(s)), s=s.seq; end     % in case aln structure passing in

[n,m]=size(s);
if ~(n==1)
	error('Must be a single sequence.')
end

s(find(s>4|s<1))=[];    %remove gaps
N=cat(2,sum(s==1),sum(s==2),sum(s==3),sum(s==4));
if (nargout>1), Nf=N./sum(N); end

if (nargout>2)
	NN=zeros(4);
	[n,m] = size(s);
	m=m-mod(m,2);
	for (k=1:2:m),
	      NN(s(1,k),s(1,k+1)) = NN(s(1,k),s(1,k+1))+1;
	end
	if (nargout>3), NNf=NN./(m/2); end
end
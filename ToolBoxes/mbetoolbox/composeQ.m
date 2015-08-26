function [Q] = composeQ(R,PI)
%COMPOSEQ - computes normalized rate matrix Q from R matrix (general reversible model)
%
% [Q] = composeQ(R,PI)

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

error(nargchk(2, 2, nargin));

if (trace(R)~=0)
	error('error in R');
end

[x,y]=size(PI);
if ~(x==y), PI=diag(PI); end

Q=R*PI;
% Make it a valid rate matrix (make sum of rows = 0)
Q=Q+diag(-1*sum(Q,2));	% Markov Q requires sum(Q,2)==0


% Scale/normalize rate matrix to one expected substitution per unit time
%Q=Q*length(Q);		% rescale Q, x4 for nt, x20 for aa, x61 for codon
%Q=Q./abs(trace(Q));
Q=(Q./abs(trace(Q)))*length(Q);
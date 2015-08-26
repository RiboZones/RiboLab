function [P,Q]=countseqpq(S)
%COUNTSEQPQ - Counts transition (P) and transversion (Q) for the given sequence pair S

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

if (isstruct(S)), S=S.seq; end
[n,m] = size(S);

TS = [0, 0, 1, 0;
      0, 0, 0, 1;
      1, 0, 0, 0;
      0, 1, 0, 0];

TV = [0, 1, 0, 1;
      1, 0, 1, 0;
      0, 1, 0, 1;
      1, 0, 1, 0];


P = zeros(n);
Q = zeros(n);


for i=1:n-1
for j=i+1:n
	[X] = countntchange(S(i,:), S(j,:));
	P(i,j) = sum(sum(TS.*X));
	Q(i,j) = sum(sum(TV.*X));
P(j,i) = P(i,j);
Q(j,i) = Q(i,j);
end
end

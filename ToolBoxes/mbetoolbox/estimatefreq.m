function [freq] = estimatefreq(S)
%ESTIMATEFREQ - Estimates base frequencies of the given sequence(s)
%Get empirical base frequencies from the data 
%
% Syntax: [freq] = estimatefreq(S)
%
% Inputs:
%    S        - Sequence pair
%
% Outputs:
%    freq - Frequencies of base, e.g. [.1 .2 .3 .4]
%
% See also:

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007


N=[sum(sum(S==1)),sum(sum(S==2)),sum(sum(S==3)),sum(sum(S==4))];
freq=N./sum(N);		% Pi(A,C,G,T);

function [S,N] = estsynnonsynsites(s1,s2);
%GETSYNNONSYNSITES - Estimate Syn- Nonsyn- sites 

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 7/17/2006

[dS,dN,dN_dS,lnL,value] = dc_gy94([s1;s2],1,2);
S=value.S;
N=value.N;

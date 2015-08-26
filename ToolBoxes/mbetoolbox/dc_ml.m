function [dS,dN,dN_dS,lnL] = dc_ml(aln,a,b)
%DC_ML - dS, dN estimation by codeml method
%
% [dS,dN] = dc_ml(aln,a,b)
% calculates dS and dN between sequence a and b in aln.
% 
%%

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 9/1/2005


[dS,dN,dN_dS,lnL] = dc_gy94(aln,a,b);


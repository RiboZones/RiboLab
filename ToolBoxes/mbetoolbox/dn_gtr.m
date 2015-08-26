function [d] = dn_gtr(s1,s2,rmatrix,freq)
%DN_GTR - Distance of GTR model
%
% Syntax: [D,VarD]=dn_gtr(s1,s2,rmatrix,freq)
%
% Inputs:
%    aln    - Alignment structure
%    freq   - (optional) 1x4 vector of equilibrium base frequencies
%
% Outputs:
%    d      - Distance matrix
%
%REF: Yan Z and Nielsen R (2000) Estimating synonymous and nonsynonymous
%     subsititution rates under realistic evolutionary models. p. 34
%
% See also: 

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

[X]=countntchange(s1,s2);

model=modelgtr(rmatrix,freq);

F=((sum(sum(X))-trace(X))*model.R)./4;
F=eye(4)*trace(X)./4+F;


PI=diag(model.freq);
d=-trace(PI*logm(inv(PI)*F));
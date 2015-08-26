function [t]=dinuclise16(s)
%DINUCLISE16 - Codonises sequence(s)
%
% Syntax:  t=dinuclise16(s)
%
% Inputs:
%    s   - Input sequence(s)
%
% Outputs:
%    t   - Codonised sequence(s)
%
% See also: ENCODESEQ, ENCODEALN

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

[n,m]=size(s);
m=m-mod(m,2);
%if (mod(m,2)>0) error('length of coding sequence cannot divide by 2!'); end
t = zeros(n,m/2);

p=1:2:m; q=1:m/2;
t(:,q)=(s(:,p)-1).*4+(s(:,p+1)-1)+1;
t(t>16)=17;
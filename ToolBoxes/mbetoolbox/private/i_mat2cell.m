function [C]=i_mat2cell(M)

% Molecular Biology & Evolution Toolbox, (C) 2005
% Author: James J. Cai
% Email: jamescai@hkusua.hku.hk
% Website: http://web.hku.hk/~jamescai/
% Last revision: 5/28/2005

[n,m]=size(M);
C={};
for (k=1:n),
     C{k}=removeblanks(M(k,:));
     disp(C{k})
end
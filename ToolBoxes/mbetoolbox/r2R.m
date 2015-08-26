function [R] = r2R(r,reverse)
%R2R - Converts PAUP* rate rmatrix r to R
%For example:
%
% rmatrix=[1.0 1.33333 1.0 1.0 1.333333 1];
% nst=6
%
% R =
%
%         0    0.3000    0.4000    0.3000
%    0.3000         0    0.3000    0.4000
%    0.4000    0.3000         0    0.3000
%    0.3000    0.4000    0.3000         0
%%

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

if (nargin==1)
      reverse=0;
end

map=[1,2; 1,3; 1,4; 2,3; 2,4; 3,4];

if ~(reverse)
	R=zeros(4);
	n=6-length(r);
	for (k=6-n+1:6),
	      r(k)=1;
	end


	for (k=1:6),
	      id=map(k,:);
	      R(id(1),id(2))=r(k);
	      R(id(2),id(1))=r(k);
	end

	for (k=1:4),
		sumQ=sum(R,2);
		R(k,:)=R(k,:)./sumQ(k);
		%Q(k,k)=-sum(Q(k,:));
	end
else
	R=zeros(1,5);
	for (k=1:5),
	      R(k)=r(map(k,1),map(k,2));
	end
end
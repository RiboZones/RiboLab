function [s_site,v_site]=countinvariablesites(aln)
%COUNTINVARIABLESITES - Counts invariable sites.
%
% Syntax: [s_site,v_site]=countinvariablesites(aln)
%
% Inputs:
%    aln   - Alignment structure
%
% Outputs:
%    s_site   - Number of invariable sites
%    v_site   - Number of valid sites = total length - gaps
%
% See also: COUNTBASECHANGE

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

if (isstruct(aln)), seq=aln.seq; else seq=aln; end

[n,m]=size(seq);
s_site=0;
v_site=0;
for j=1:m,
	minnt=min(seq(:,j));
	maxnt=max(seq(:,j));
	if (minnt>0 & maxnt<5)
		s_site=s_site+(minnt==maxnt);
	else
		v_site=v_site+1;	% take invalid char(>5 or <0) into account
	end
end
v_site=m-v_site;

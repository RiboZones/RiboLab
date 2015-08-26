function [D,gap]=countaachange(s1,s2)
%COUNTAACHANGE - Counts amino-acid replacements in two protein sequences
%
% Syntax: [D,gap]=countaachange(s1,s2)
%
% Inputs:
%    s1   - Sequence 1 vector
%    s2   - Sequence 2 vector
%
% Outputs:
%    D    - Matrix of AA difference
%    gap  - Number of gaps
%
%
% See also: COUNTAACHANGE COUNTCDCHANGE

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 3/28/2006


if (nargout>1)
	[D,gap]=countchange(s1,s2,20);
else
	[D]=countchange(s1,s2,20);
end

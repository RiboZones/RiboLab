function [aln2]=extractpos(aln,pos1,pos2)
%EXTRACTPOS - Extract coding position 1, 2, 3 or 1 and 2
%
% Syntax: [aln2]=extractinvariablesites(aln)
%
% Inputs:
%    aln    - Alignment structure
%    pos1   - Position 1
%    pos2   - (optional) Position 2
%
% Outputs:
%    aln2     - New alignment including invariable sites only
%
% See also: CALCULATERSCU

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007


%EXTRACTPOSITION
%
% [aln2]=extractpos(aln,pos1,pos2)

% Molecular Biology & Evolution Toolbox, (C) 2007


if (isstruct(aln))

	if ~(isvalidaln(aln,'CODING')) error ('Not coding seq'); end

	aln2=copyalnheader(aln);
	aln2.geneticcode = 0;
	[n,m] = size(aln.seq);


	if (nargin < 2)
	      error('Requires at least 2 inputs.');
	elseif (nargin==2)
		picker=pos1:3:m;
		aln2.seq=aln.seq(:,picker);
	else
		A=zeros(1,3); A(1,pos1)=1; A(1,pos2)=1;
		B=repmat(A,1,m/3);
		C=1:m;
		picker=C(logical(B));
		aln2.seq=aln.seq(:,picker);
	end

else
	seq=aln;
	[n,m] = size(seq);

	if (nargin < 2)
	      error('Requires at least 2 inputs.');
	elseif (nargin==2)
		picker=pos1:3:m;
		aln2=seq(:,picker);
	else
		A=zeros(1,3); A(1,pos1)=1; A(1,pos2)=1;
		B=repmat(A,1,m/3);
		C=1:m;
		picker=C(logical(B));
		aln2=seq(:,picker);
	end

end
function [lnL] = seqpairlikeli(t,model,s1,s2)
%SEQPAIRLIKELI - Estimates log-likelihood of branch length (distance)
%Estimates log-likelihood of distance/branch length given subst. model
%
% Syntax: [lnL] = likelidist(t,model,s1,s2)
%
% Inputs:
%    t       - Distance/branch length
%    model   - Substitution model
%    s1      - Nucleotide sequence 1
%    s2      - Nucleotide sequence 2
%
% Outputs:
%    lnL   - Log-likelihood
%
% See also:

% Molecular Biology & Evolution Toolbox, (C) 2007
% Author: James J. Cai
% Email: jamescai@stanford.edu
% Website: http://bioinformatics.org/mbetoolbox/
% Last revision: 5/18/2007

% t=0.3
% model=modeljtt;

%if ~(isempty(model.Q))
	R=model.R;
	freq2=model.freq;
	
	[N,freq] = aacomposition([s1;s2]);
	PI=diag(freq2);
	Q=composeQ(R,PI);
%else
%	Q=20*(model.Q);
%end

[V,D] = eig(Q*t);
P=V*diag(exp(diag(D)))/V;
PI=diag(model.freq);
%P=expm(Q*t);

switch (length(model.freq))
    case (4)
	[X]=countntchange(s1,s2);
    case (20)
	[X]=countaachange(s1,s2);
    case (61)
	[X]=countcdchange(s1,s2);
end




% In the following form, instead of lnL=sum(sum(log(P).*X));
% so that we supress Warning: Log of zero.
lnL=sum(sum(log(P.^X)));